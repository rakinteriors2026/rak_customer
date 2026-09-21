#!/usr/bin/env python3
"""Build branding assets: copy the RAK logo and a square app icon."""

from __future__ import annotations

import shutil
import sys
from pathlib import Path

try:
    from PIL import Image
except ImportError:
    sys.exit("Pillow is required")

ROOT = Path("/Volumes/Santo personal/RAK interiors/RAK_customer")
SOURCE = Path(
    "/Users/santomartin/.cursor/projects/Volumes-Santo-personal-RAK-interiors-RAK-customer/assets/raklogo-b15fea1d-2e31-4a71-98ae-ea39c4d8d092.png"
)
OUT_DIR = ROOT / "assets" / "branding"
LOGO = OUT_DIR / "rak_logo.png"
ICON = OUT_DIR / "rak_app_icon.png"
ICON_SIZE = 1024
PAD = 96


def main() -> None:
    OUT_DIR.mkdir(parents=True, exist_ok=True)
    shutil.copyfile(SOURCE, LOGO)

    logo = Image.open(SOURCE).convert("RGBA")
    canvas = Image.new("RGB", (ICON_SIZE, ICON_SIZE), (0, 0, 0))
    max_w = ICON_SIZE - PAD * 2
    max_h = ICON_SIZE - PAD * 2
    fitted = logo.copy()
    fitted.thumbnail((max_w, max_h), Image.Resampling.LANCZOS)
    x = (ICON_SIZE - fitted.width) // 2
    y = (ICON_SIZE - fitted.height) // 2
    if fitted.mode == "RGBA":
        canvas.paste(fitted, (x, y), fitted)
    else:
        canvas.paste(fitted.convert("RGB"), (x, y))
    canvas.save(ICON, format="PNG")
    print(f"Wrote {LOGO}")
    print(f"Wrote {ICON} ({canvas.size[0]}x{canvas.size[1]})")


if __name__ == "__main__":
    main()
