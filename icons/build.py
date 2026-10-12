#!/usr/bin/env python3
"""Generate the Goat-Cream folder icons as scalable SVGs.

Each folder is drawn here (crisp corners, soft gradient, fine highlight) and
the special folders get Yaru's symbolic glyph embossed on the front panel.
Everything that isn't a folder is inherited from Yaru-wartybrown.
"""

import re
import shutil
import sys
from pathlib import Path

# Output directory: the first argument, or Goat-Cream next to this script.
OUT = Path(sys.argv[1]) if len(sys.argv) > 1 else Path(__file__).parent / "Goat-Cream"
GLYPHS = Path("/usr/share/icons/Yaru/scalable/places")

# Palette: creamy light-brown front, walnut back and tab.
FRONT_TOP, FRONT_BOTTOM = "#d1b994", "#bb9f77"
BACK_TOP, BACK_BOTTOM = "#977a55", "#7f6446"
PAPER = "#efe9dc"
GLYPH = "#6e5539"
RADIUS = 6

# icon name -> Yaru symbolic glyph (None for a plain folder)
ICONS = {
    "folder": None,
    "inode-directory": None,
    "folder-dropbox": None,
    "insync-folder": None,
    "folder-documents": "folder-documents",
    "folder-download": "folder-download",
    "folder-music": "folder-music",
    "folder-pictures": "folder-pictures",
    "folder-publicshare": "folder-publicshare",
    "folder-remote": "folder-remote",
    "folder-templates": "folder-templates",
    "folder-videos": "folder-videos",
    "folder-saved-search": "folder-saved-search",
    "user-desktop": "user-desktop",
    "user-home": "user-home",
    "user-bookmarks": "user-bookmarks",
}


def glyph_markup(name):
    """Yaru's 16x16 symbolic glyph, recolored and scaled onto the front panel."""
    svg = (GLYPHS / f"{name}-symbolic.svg").read_text()
    inner = re.search(r"<svg[^>]*>(.*)</svg>", svg, re.S).group(1)
    inner = re.sub(r'fill="[^"]*"', "", inner)
    inner = re.sub(r'style="[^"]*"', "", inner)
    return (
        f'<svg x="100" y="124" width="56" height="56" viewBox="0 0 16 16">'
        f'<g fill="{GLYPH}" fill-opacity="0.62">{inner}</g></svg>'
        # A one-pixel light offset underneath reads as a subtle emboss.
        f'<svg x="100" y="125.5" width="56" height="56" viewBox="0 0 16 16" opacity="0.35">'
        f'<g fill="#fffaf0">{inner}</g></svg>'
    )


def folder_svg(glyph=None, open_=False):
    r = RADIUS
    # Back panel with a straight-edged tab on the left.
    back = (
        f"M{20 + r},44 H{96} L{108},58 H{236 - r} Q236,58 236,{58 + r} "
        f"V{212} H20 V{44 + r} Q20,44 {20 + r},44 Z"
    )
    front_y = 96 if open_ else 82
    paper = (
        f'<rect x="34" y="{66 if open_ else 70}" width="188" height="120" rx="2" '
        f'fill="{PAPER}"/>'
    )
    glyph_part = glyph_markup(glyph) if glyph else ""
    return f"""<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 256 256" width="256" height="256">
  <defs>
    <linearGradient id="front" x1="0" y1="0" x2="0" y2="1">
      <stop offset="0" stop-color="{FRONT_TOP}"/>
      <stop offset="1" stop-color="{FRONT_BOTTOM}"/>
    </linearGradient>
    <linearGradient id="back" x1="0" y1="0" x2="0" y2="1">
      <stop offset="0" stop-color="{BACK_TOP}"/>
      <stop offset="1" stop-color="{BACK_BOTTOM}"/>
    </linearGradient>
    <filter id="shadow" x="-10%" y="-10%" width="120%" height="130%">
      <feGaussianBlur stdDeviation="4"/>
    </filter>
  </defs>
  <rect x="24" y="{front_y + 10}" width="208" height="{216 - front_y}" rx="{r}" fill="#000" opacity="0.28" filter="url(#shadow)"/>
  <path d="{back}" fill="url(#back)"/>
  {paper}
  <rect x="20" y="{front_y}" width="216" height="{220 - front_y}" rx="{r}" fill="url(#front)"/>
  <rect x="21" y="{front_y + 1}" width="214" height="1.5" rx="0.75" fill="#fffaf0" opacity="0.55"/>
  <rect x="20.5" y="{front_y + 0.5}" width="215" height="{219 - front_y}" rx="{r - 0.5}" fill="none" stroke="#5a4530" stroke-opacity="0.18"/>
  {glyph_part}
</svg>
"""


def main():
    shutil.rmtree(OUT, ignore_errors=True)
    places = OUT / "scalable" / "places"
    places.mkdir(parents=True, exist_ok=True)

    for name, glyph in ICONS.items():
        (places / f"{name}.svg").write_text(folder_svg(glyph))
    (places / "folder-open.svg").write_text(folder_svg(open_=True))

    (OUT / "index.theme").write_text(
        "[Icon Theme]\n"
        "Name=Goat-Cream\n"
        "Comment=Cream folders for the Goat theme\n"
        "Inherits=Yaru-wartybrown,Yaru,Humanity,hicolor\n"
        "Example=folder\n"
        "Directories=scalable/places\n"
        "\n"
        "[scalable/places]\n"
        "Context=Places\n"
        "Size=256\n"
        "MinSize=8\n"
        "MaxSize=512\n"
        "Type=Scalable\n"
    )


if __name__ == "__main__":
    main()
