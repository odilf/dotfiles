{
  pkgs,
  lib,
  config,
  ...
}:
let
  inherit (pkgs.stdenv.hostPlatform) isDarwin;
  cfg = config.custom.theme-switch;

  # Toggles the system appearance and exports THEME_MODE=light|dark
  # with the mode that was just switched to.
  toggleAppearance =
    if isDarwin then
      ''
        osascript -e 'tell app "System Events" to tell appearance preferences to set dark mode to not dark mode'
        if [[ "$(osascript -e 'tell app "System Events" to tell appearance preferences to get dark mode')" == "true" ]]; then
          export THEME_MODE=dark
        else
          export THEME_MODE=light
        fi
      ''
    else
      "poopoo";
  # ''
  #   current=$(${pkgs.glib}/bin/gsettings get org.gnome.desktop.interface color-scheme)
  #   if [[ "$current" == *dark* ]]; then
  #     ${pkgs.glib}/bin/gsettings set org.gnome.desktop.interface color-scheme prefer-light
  #     export THEME_MODE=light
  #   else
  #     ${pkgs.glib}/bin/gsettings set org.gnome.desktop.interface color-scheme prefer-dark
  #     export THEME_MODE=dark
  #   fi
  # '';

  # Reads the current appearance (without changing it)
  readAndExportTheme =
    if isDarwin then
      ''
        # AppleInterfaceStyle only exists in dark mode. The sleep gives
        # macOS time to persist the new value after the notification.
        sleep 0.5
        if [[ "$(defaults read -g AppleInterfaceStyle 2>/dev/null)" == "Dark" ]]; then
          export THEME_MODE=dark
        else
          export THEME_MODE=light
        fi
      ''
    else
      "poopoo";
  # ''
  #   if [[ "$(${pkgs.glib}/bin/gsettings get org.gnome.desktop.interface color-scheme)" == *dark* ]]; then
  #     export THEME_MODE=dark
  #   else
  #     export THEME_MODE=light
  #   fi
  # '';

  # Runs all hooks. Uses THEME_MODE if the caller already set it,
  # otherwise detects the current appearance.
  runHooks = pkgs.writeShellScript "theme-switch-run-hooks" ''
    if [[ -z "''${THEME_MODE:-}" ]]; then
      ${readAndExportTheme}
    fi

    if [[ "$THEME_MODE" == "dark" ]]; then
      ${lib.concatStringsSep "\n" (map ({ on-dark, ... }: on-dark) cfg.hooks)}
    else
      ${lib.concatStringsSep "\n" (map ({ on-light, ... }: on-light) cfg.hooks)}
    fi
  '';

  toggle-theme = pkgs.writeShellScriptBin "toggle-theme" ''
    ${toggleAppearance}
    ${lib.optionalString (!cfg.watch) "${runHooks}"}
  '';

  # Tiny Objective-C program: runs argv[1..] whenever the macOS
  # appearance changes. Only depends on Foundation.
  darkModeNotify = pkgs.runCommandCC "dark-mode-notify" { } ''
    mkdir -p $out/bin
    cat > main.m <<'EOF'
    #import <Foundation/Foundation.h>

    int main(int argc, char **argv) {
      @autoreleasepool {
        if (argc < 2) {
          fprintf(stderr, "usage: %s command [args...]\n", argv[0]);
          return 1;
        }
        NSMutableArray<NSString *> *args = [NSMutableArray array];
        for (int i = 2; i < argc; i++) [args addObject:@(argv[i])];
        NSString *cmd = @(argv[1]);

        [[NSDistributedNotificationCenter defaultCenter]
            addObserverForName:@"AppleInterfaceThemeChangedNotification"
                        object:nil
                         queue:nil
                    usingBlock:^(NSNotification *note) {
          NSTask *task = [[NSTask alloc] init];
          task.executableURL = [NSURL fileURLWithPath:cmd];
          task.arguments = args;
          NSError *err = nil;
          [task launchAndReturnError:&err];
          if (err) NSLog(@"failed to launch %@: %@", cmd, err);
        }];
        [[NSRunLoop mainRunLoop] run];
      }
      return 0;
    }
    EOF
    $CC -fobjc-arc -framework Foundation main.m -o $out/bin/dark-mode-notify
  '';
in
{
  options.custom.theme-switch = {
    hooks = lib.mkOption {
      description = "Snippets to run when switching themes";
      type = lib.types.listOf (
        lib.types.submodule {
          options = {
            on-dark = lib.mkOption {
              type = lib.types.lines;
            };
            on-light = lib.mkOption {
              type = lib.types.lines;
            };
          };
        }
      );

      default = [ ];
    };

    watch = lib.mkOption {
      description = ''
        Run the hooks whenever the system appearance changes (including
        changes made from the OS settings/menu), not only via `toggle-theme`.
      '';
      type = lib.types.bool;
      default = config.gui;
      defaultText = lib.literalExpression "config.gui";
    };

    package = lib.mkPackageOption pkgs "theme-switcher" {
      default = toggle-theme;
      # default = null;
    };
  };

  config = {
    custom.theme-switch.package = toggle-theme;

    home-manager.sharedModules = lib.mkIf config.gui [
      {
        home.packages = [ toggle-theme ];
      }
    ];

    launchd.user.agents.theme-switch-watcher = lib.mkIf (isDarwin && cfg.watch) {
      serviceConfig = {
        ProgramArguments = [
          "${darkModeNotify}/bin/dark-mode-notify"
          "${runHooks}"
        ];
        RunAtLoad = true;
        KeepAlive = true;
        # launchd's default PATH is minimal; add the Nix system profile
        # so hooks can find your tools.
        EnvironmentVariables.PATH = lib.concatStringsSep ":" [
          "/run/current-system/sw/bin"
          "/usr/local/bin"
          "/usr/bin"
          "/bin"
          "/usr/sbin"
          "/sbin"
        ];
        StandardErrorPath = "/tmp/theme-switch-watcher.log";
        StandardOutPath = "/tmp/theme-switch-watcher.log";
      };
    };

    systemd.user.services.theme-switch-watcher = lib.mkIf (!isDarwin && cfg.watch) {
      description = "Run theme hooks when the color scheme changes";
      wantedBy = [ "graphical-session.target" ];
      partOf = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      environment = {
        GSETTINGS_SCHEMA_DIR = "${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}/glib-2.0/schemas";
        GIO_EXTRA_MODULES = "${pkgs.dconf.lib}/lib/gio/modules";
      };
      script = ''
        ${pkgs.glib}/bin/gsettings monitor org.gnome.desktop.interface color-scheme |
          while read -r _; do
            ${runHooks} || true
          done
      '';
      serviceConfig.Restart = "on-failure";
    };
  };
}
