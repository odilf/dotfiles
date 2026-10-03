#!/usr/bin/python3

"""Update one Firefox addon in firefox-addons.nix from addons.mozilla.org.

Usage: firefox-addons-update.py <addonId>

The addonId (GUID) identifies the addon's block in
modules/derivations/firefox-addons.nix. The script queries the AMO API for the
latest version and download URL, downloads the xpi to compute its SRI hash, and
rewrites the block's version/url/hash fields in place.
"""

import base64
import hashlib
import json
import re
import sys
import urllib.parse
import urllib.request

FILE = "modules/derivations/firefox-addons.nix"
API = "https://addons.mozilla.org/api/v5/addons/addon/{}/"
USER_AGENT = "firefox-addons-update/1.0"


def fetch_json(url):
    req = urllib.request.Request(url, headers={"User-Agent": USER_AGENT})
    with urllib.request.urlopen(req) as resp:
        return json.load(resp)


def fetch_sri_sha256(url):
    req = urllib.request.Request(url, headers={"User-Agent": USER_AGENT})
    with urllib.request.urlopen(req) as resp:
        data = resp.read()
    return "sha256-" + base64.b64encode(hashlib.sha256(data).digest()).decode()


def main():
    if len(sys.argv) != 2:
        sys.exit("usage: firefox-addons-update.py <addonId>")

    guid = sys.argv[1]

    addon = fetch_json(API.format(urllib.parse.quote(guid, safe="")))
    current = addon["current_version"]
    new_version = current["version"]
    new_url = current["file"]["url"]

    with open(FILE) as f:
        lines = f.read().splitlines()

    # Find the block `<attr> = buildFirefoxAddon { ... };` that declares this
    # addonId, so we only touch this addon's fields.
    block_start: int | None = None
    block_ranges: list[tuple[int, int]] = []
    for i, line in enumerate(lines):
        if re.match(r"^\s*[A-Za-z0-9_-]+\s*=\s*buildFirefoxAddon\s*\{\s*$", line):
            block_start = i
        elif block_start is not None and re.match(r"^\s*\};\s*$", line):
            block_ranges.append((block_start, i))
            block_start = None

    target: tuple[int, int] | None = None
    for begin, end in block_ranges:
        for line in lines[begin : end + 1]:
            m = re.match(r'^\s*addonId\s*=\s*"(.*)";\s*$', line)
            if m and m.group(1) == guid:
                target = (begin, end)
                break
        if target is not None:
            break

    if target is None:
        sys.exit(f"addonId {guid!r} not found in {FILE}")

    start, end = target

    old_version = None
    old_hash = None
    for i in range(start, end + 1):
        m = re.match(r'^\s*version\s*=\s*"(.*)";\s*$', lines[i])
        if m and old_version is None:
            old_version = m.group(1)
        m = re.match(r'^\s*hash\s*=\s*"(.*)";\s*$', lines[i])
        if m and old_hash is None:
            old_hash = m.group(1)

    # A missing hash still needs to be filled in, even if the version is current.
    if old_version == new_version and old_hash:
        print(f"{guid}: already at {new_version}")
        return

    new_hash = fetch_sri_sha256(new_url)

    def replace(key, value):
        for i in range(start, end + 1):
            m = re.match(rf'^(\s*{key}\s*=\s*")[^"]*(";\s*)$', lines[i])
            if m:
                lines[i] = m.group(1) + value + m.group(2)
                return True
        return False

    for key, value in (("version", new_version), ("url", new_url), ("hash", new_hash)):
        if not replace(key, value):
            sys.exit(f"failed to replace {key} for addonId {guid!r}")

    try:
        with open(FILE, "w") as f:
            f.write("\n".join(lines) + "\n")
    except OSError as e:
        sys.exit(f"failed to write {FILE}: {e}")

    if old_version != new_version:
        print(f"{guid}: {old_version} -> {new_version}")
    else:
        print(f"{guid}: filled missing hash ({new_version})")


if __name__ == "__main__":
    main()
