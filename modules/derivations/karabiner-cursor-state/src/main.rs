use std::env;
use std::ffi::{c_void, CStr};
use std::io;
use std::io::Write;
use std::os::raw::c_uint;
use std::process::{Child, ChildStdin, Command, Stdio};
use std::ptr::NonNull;
use std::thread;
use std::time::Duration;

const DEFAULT_KARABINER_CLI: &str =
    "/Library/Application Support/org.pqrs/Karabiner-Elements/bin/karabiner_cli";
const DEFAULT_VAR_NAME: &str = "cursor_captured";

const POLL_INTERVAL: Duration = Duration::from_millis(25);
const SPAWN_SETTLE: Duration = Duration::from_millis(100);

const SKYLIGHT_PATH: &CStr = c"/System/Library/PrivateFrameworks/SkyLight.framework/SkyLight";
const CORE_GRAPHICS_PATH: &CStr = c"/System/Library/Frameworks/CoreGraphics.framework/CoreGraphics";

// SLCursorIsVisible is a C++ `bool` (1 byte); CGCursorIsVisible returns
// `boolean_t` (a 4-byte unsigned int). Declaring each with its real return type
// avoids reading uninitialised upper bits from the return register.
type SkyLightCursorVisible = unsafe extern "C" fn() -> bool;
type CoreGraphicsCursorVisible = unsafe extern "C" fn() -> c_uint;

fn log(message: &str) {
    eprintln!("karabiner-cursor-state: {message}");
}

/// Load a dynamic library, returning `None` if the OS could not load it.
fn load_library(path: &CStr) -> Option<NonNull<c_void>> {
    // SAFETY: `path` is a `&CStr`.
    let handle = unsafe { libc::dlopen(path.as_ptr(), libc::RTLD_LAZY) };
    NonNull::new(handle)
}

/// Look up `name` in `handle`. The returned pointer is non-null on success.
fn load_symbol(handle: NonNull<c_void>, name: &CStr) -> Option<NonNull<c_void>> {
    // SAFETY: `handle` came from `dlopen` and is still open (it is owned by the
    // reader for at least as long as any symbol used from it), and `name` is a
    // valid NUL-terminated C string.
    let symbol = unsafe { libc::dlsym(handle.as_ptr(), name.as_ptr()) };
    NonNull::new(symbol)
}

enum CursorSource {
    SkyLight(SkyLightCursorVisible),
    CoreGraphics(CoreGraphicsCursorVisible),
    AssumeVisible,
}

/// Reads whether the system cursor is currently visible.
///
/// Applications that capture the pointer (games, remote desktops, ...) hide the
/// cursor for as long as they hold it, so visibility doubles as a "the mouse is
/// captured" signal. The backing system symbol is resolved once and kept loaded
/// for the reader's lifetime.
struct CursorReader {
    handle: Option<NonNull<c_void>>,
    source: CursorSource,
}

impl CursorReader {
    fn load() -> Self {
        Self::load_skylight()
            .or_else(Self::load_core_graphics)
            .unwrap_or_else(Self::assume_visible)
    }

    fn load_skylight() -> Option<Self> {
        let handle = load_library(SKYLIGHT_PATH)?;
        let Some(symbol) = load_symbol(handle, c"SLCursorIsVisible") else {
            // SAFETY: closing the handle exactly once here.
            unsafe {
                libc::dlclose(handle.as_ptr());
            }
            return None;
        };
        // SAFETY: promised `SLCursorIsVisible` signature, and library is not closed until `Self` is dropped.
        let f = unsafe { std::mem::transmute::<NonNull<c_void>, SkyLightCursorVisible>(symbol) };
        Some(Self {
            handle: Some(handle),
            source: CursorSource::SkyLight(f),
        })
    }

    fn load_core_graphics() -> Option<Self> {
        let handle = load_library(CORE_GRAPHICS_PATH)?;
        let Some(symbol) = load_symbol(handle, c"CGCursorIsVisible") else {
            // SAFETY: closing the handle exactly once here.
            unsafe {
                libc::dlclose(handle.as_ptr());
            }
            return None;
        };
        // SAFETY: promised `CGCursorIsVisible` signature (returns  `boolean_t`,
        // which is a 4-byte unsigned int), and library is not closed until
        // `Self` is dropped.
        let f =
            unsafe { std::mem::transmute::<NonNull<c_void>, CoreGraphicsCursorVisible>(symbol) };
        Some(Self {
            handle: Some(handle),
            source: CursorSource::CoreGraphics(f),
        })
    }

    fn assume_visible() -> Self {
        Self {
            handle: None,
            source: CursorSource::AssumeVisible,
        }
    }

    /// Whether the system cursor is currently visible.
    ///
    /// Reports `true` when no system source could be resolved, erring towards
    /// leaving input untouched.
    fn is_visible(&self) -> bool {
        match self.source {
            // SAFETY: `f` is the function declared for this exact symbol and the
            // library providing it is kept loaded in `self.handle`.
            CursorSource::SkyLight(f) => unsafe { f() },
            // SAFETY: same as above for the CoreGraphics symbol.
            CursorSource::CoreGraphics(f) => unsafe { f() != 0 },
            CursorSource::AssumeVisible => true,
        }
    }

    fn source_name(&self) -> &'static str {
        match self.source {
            CursorSource::SkyLight(_) => "SkyLight SLCursorIsVisible",
            CursorSource::CoreGraphics(_) => "CoreGraphics CGCursorIsVisible",
            CursorSource::AssumeVisible => "none (assuming cursor visible)",
        }
    }
}

impl Drop for CursorReader {
    fn drop(&mut self) {
        if let Some(handle) = self.handle {
            // SAFETY: `handle` came from `dlopen` and is closed exactly once
            // here; `self` is being dropped, so nothing uses it afterwards.
            unsafe {
                libc::dlclose(handle.as_ptr());
            }
        }
    }
}

fn variable_json(var_name: &str, captured: bool) -> String {
    format!("{{\"{var_name}\":{}}}\n", u8::from(captured))
}

/// A persistent `karabiner_cli --set-variables-from-stdin` child. Spawning the
/// CLI fresh per update costs ~180ms (process startup), so instead we keep one
/// alive and push JSON lines to its stdin (sub-ms each).
struct KarabinerClient {
    child: Child,
    stdin: ChildStdin,
}

impl KarabinerClient {
    fn spawn(karabiner_cli: &str) -> io::Result<Self> {
        let mut child = Command::new(karabiner_cli)
            .arg("--set-variables-from-stdin")
            .stdin(Stdio::piped())
            .stdout(Stdio::null())
            .stderr(Stdio::null())
            .spawn()?;

        let stdin = child
            .stdin
            .take()
            .ok_or_else(|| io::Error::other("karabiner_cli stdin unavailable"))?;

        // Let the CLI start up and connect before feeding it variables.
        thread::sleep(SPAWN_SETTLE);
        Ok(Self { child, stdin })
    }

    fn set(&mut self, var_name: &str, captured: bool) -> io::Result<()> {
        self.stdin
            .write_all(variable_json(var_name, captured).as_bytes())?;
        self.stdin.flush()
    }

    fn is_alive(&mut self) -> bool {
        matches!(self.child.try_wait(), Ok(None))
    }
}

// The run loop never returns; it hands failures to launchd by exiting. If the
// process unwinds instead (e.g. a panic), this keeps `karabiner_cli` from being
// orphaned.
impl Drop for KarabinerClient {
    fn drop(&mut self) {
        let _ = self.child.kill();
        let _ = self.child.wait();
    }
}

fn main() {
    let karabiner_cli =
        env::var("KARABINER_CLI").unwrap_or_else(|_| DEFAULT_KARABINER_CLI.to_string());
    let var_name =
        env::var("CURSOR_CAPTURED_VARIABLE").unwrap_or_else(|_| DEFAULT_VAR_NAME.to_string());

    let reader = CursorReader::load();
    log(&format!(
        "cursor visibility source: {}",
        reader.source_name()
    ));
    log(&format!("watching `{var_name}` every {POLL_INTERVAL:?}"));

    let mut client = match KarabinerClient::spawn(&karabiner_cli) {
        Ok(client) => {
            log(&format!("connected to {karabiner_cli}"));
            client
        }
        Err(err) => {
            log(&format!("failed to start {karabiner_cli}: {err}"));
            std::process::exit(1);
        }
    };

    let mut last: Option<bool> = None;

    loop {
        if !client.is_alive() {
            log("karabiner_cli exited; exiting for launchd to restart");
            std::process::exit(1);
        }

        let captured = !reader.is_visible();
        if last != Some(captured) {
            if let Err(err) = client.set(&var_name, captured) {
                log(&format!(
                    "write failed: {err}; exiting for launchd to restart"
                ));
                std::process::exit(1);
            }
            log(&format!("{var_name} = {}", u8::from(captured)));
            last = Some(captured);
        }

        thread::sleep(POLL_INTERVAL);
    }
}
