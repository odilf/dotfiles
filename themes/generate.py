#!/usr/bin/env python3
# FIXME: I think I should use https://github.com/chriskempson/base16-templates-source
"""Generate ghostty, alacritty, and wezterm theme files from base palettes
with a saturation boost.

Tweak SATURATION_BOOST (or a theme's palette colors) below, then run:

    ./generate.py

This overwrites the generated files under ghostty/, alacritty/, and
wezterm/ in this directory.
"""

import colorsys
from pathlib import Path

THEMES_DIR = Path(__file__).parent

ANSI_NAMES = [
    "black",
    "red",
    "green",
    "yellow",
    "blue",
    "magenta",
    "cyan",
    "white",
]

# Palette indices left untouched by the saturation boost: 0/15 are the
# near-neutral black/white slots and 7 doubles as a background-ish tone in
# both themes, 1 (red) is already fully saturated.
SKIP_INDICES = {0, 1, 7, 15}

# How much saturation (0-1) to add to each theme's non-skipped palette colors.
SATURATION_BOOST = {
    "flatblack": 0.20,
    "flatwhite": 0.50,
}

# Base (unboosted) palettes and UI colors, straight from the original muted theme.
THEMES = {
    "flatblack": {
        "palette": {
            0: "#000000",
            1: "#ff1414",
            2: "#d8e0b8",
            3: "#e3cfb5",
            4: "#b8c5e0",
            5: "#e0b8e0",
            6: "#b8e0d3",
            7: "#2d271f",
            8: "#b3a289",
            9: "#8f7a5b",
            10: "#5d4f3c",
            11: "#d7ac75",
            12: "#6e8ecf",
            13: "#433a2d",
            14: "#6ecfb0",
            15: "#d6d1cb",
        },
        "background": "#000000",
        "foreground": "#d6d1cb",
        "cursor-color": "#6a4cff",
        "cursor-text": "#000000",
        "selection-background": "#5d4f3c",
        "selection-foreground": "#d6d1cb",
    },
    "flatwhite": {
        "palette": {
            0: "#f7f3ee",
            1: "#ff1414",
            2: "#525643",
            3: "#5b5143",
            4: "#4c5361",
            5: "#614c61",
            6: "#465953",
            7: "#f1ece4",
            8: "#93836c",
            9: "#b9a992",
            10: "#dcd3c6",
            11: "#957f5f",
            12: "#7382a0",
            13: "#e4ddd2",
            14: "#5f8c7d",
            15: "#605a52",
        },
        "background": "#f7f3ee",
        "foreground": "#605a52",
        "cursor-color": "#6a4cff",
        "cursor-text": "#f7f3ee",
        "selection-background": "#dcd3c6",
        "selection-foreground": "#605a52",
    },
}


def hex_to_rgb(h: str) -> tuple[float, float, float]:
    h = h.lstrip("#")
    return tuple(int(h[i : i + 2], 16) / 255 for i in (0, 2, 4))


def rgb_to_hex(rgb: tuple[float, float, float]) -> str:
    return "#" + "".join(f"{max(0, min(255, round(c * 255))):02x}" for c in rgb)


def boost_saturation(hex_color: str, add: float) -> str:
    r, g, b = hex_to_rgb(hex_color)
    h, l, s = colorsys.rgb_to_hls(r, g, b)
    s = max(0.0, min(1.0, s + add))
    return rgb_to_hex(colorsys.hls_to_rgb(h, l, s))


def boosted_palette(theme: dict, boost: float) -> dict[int, str]:
    return {
        idx: color if idx in SKIP_INDICES else boost_saturation(color, boost)
        for idx, color in theme["palette"].items()
    }


def render_ghostty(theme: dict, palette: dict[int, str]) -> str:
    lines = [f"palette = {idx}={palette[idx]}" for idx in range(16)]
    for key in (
        "background",
        "foreground",
        "cursor-color",
        "cursor-text",
        "selection-background",
        "selection-foreground",
    ):
        lines.append(f"{key} = {theme[key]}")
    return "\n".join(lines) + "\n"


def render_alacritty(theme: dict, palette: dict[int, str]) -> str:
    lines = [
        "[colors.primary]",
        f"background = '{theme['background']}'",
        f"foreground = '{theme['foreground']}'",
        "",
        "[colors.cursor]",
        f"text = '{theme['cursor-text']}'",
        f"cursor = '{theme['cursor-color']}'",
        "",
        "[colors.selection]",
        f"text = '{theme['selection-foreground']}'",
        f"background = '{theme['selection-background']}'",
        "",
        "[colors.normal]",
    ]
    for i, name in enumerate(ANSI_NAMES):
        lines.append(f"{name} = '{palette[i]}'")
    lines.append("")
    lines.append("[colors.bright]")
    for i, name in enumerate(ANSI_NAMES):
        lines.append(f"{name} = '{palette[i + 8]}'")
    return "\n".join(lines) + "\n"


def render_wezterm(theme: dict, palette: dict[int, str]) -> str:
    ansi = ", ".join(f'"{palette[i]}"' for i in range(8))
    brights = ", ".join(f'"{palette[i + 8]}"' for i in range(8))
    lines = [
        "[colors]",
        f"foreground = \"{theme['foreground']}\"",
        f"background = \"{theme['background']}\"",
        f"cursor_bg = \"{theme['cursor-color']}\"",
        f"cursor_border = \"{theme['cursor-color']}\"",
        f"cursor_fg = \"{theme['cursor-text']}\"",
        f"selection_bg = \"{theme['selection-background']}\"",
        f"selection_fg = \"{theme['selection-foreground']}\"",
        f"ansi = [{ansi}]",
        f"brights = [{brights}]",
    ]
    return "\n".join(lines) + "\n"


RENDERERS = {
    "ghostty": (render_ghostty, ""),
    "alacritty": (render_alacritty, ".toml"),
    "wezterm": (render_wezterm, ".toml"),
}


def main() -> None:
    for name, theme in THEMES.items():
        boost = SATURATION_BOOST.get(name, 0.0)
        palette = boosted_palette(theme, boost)
        for target, (render, ext) in RENDERERS.items():
            out_dir = THEMES_DIR / target
            out_dir.mkdir(exist_ok=True)
            out_path = out_dir / f"{name}{ext}"
            out_path.write_text(render(theme, palette))
            print(f"wrote {out_path} (saturation +{boost * 100:.0f} pts)")


if __name__ == "__main__":
    main()
