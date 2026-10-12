"""Open $EDITOR, pre-filled with any command-line text, to capture a fleeting
thought into ~/brain/dump/{name}.md."""

import contextlib
import os
import re
import shlex
import subprocess
import sys
import tempfile

TEMPLATE = """---
tags:
- fleeting
---

# References

> [!QUOTE] Original Capture
> {value}
"""


def slugify(text: str) -> str:
    text = text.strip().lower()
    text = re.sub(r"[^a-z0-9]+", "-", text)
    return text.strip("-") or "untitled"


def main() -> int:
    editor = os.environ.get("EDITOR")
    if not editor:
        editor = "vi"
        print(f"warning: $EDITOR is not set, falling back to '{editor}'", file=sys.stderr)

    fd, tmp_path = tempfile.mkstemp(suffix=".md")
    try:
        initial = " ".join(sys.argv[1:]).strip()
        with os.fdopen(fd, "w") as f:
            if initial:
                f.write(initial + "\n")

        subprocess.run([*shlex.split(editor), tmp_path], check=True)

        with open(tmp_path) as f:
            content = f.read().strip()
    finally:
        with contextlib.suppress(FileNotFoundError):
            os.remove(tmp_path)


    if not content:
        print("Empty capture, aborting.", file=sys.stderr)
        return 1

    dump_dir = os.path.expanduser("~/brain/dump")
    if not os.path.isdir(os.path.expanduser("~/brain")):
        raise RuntimeError("~/brain does not exist")

    lines = content.splitlines()

    name = slugify(lines[0].split(". ")[0])
    path = os.path.join(dump_dir, f"{name}.md")

    if os.path.exists(path):
        raise RuntimeError(f"{path} already exists")

    quoted = "\n> ".join(lines)
    try:
        with open(path, "w") as f:
            f.write(TEMPLATE.format(value=quoted))
    except OSError as e:
        print(f"Failed to write '{path}': {e}", file=sys.stderr)
        return 1

    print(f"Wrote to '{path}'")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
