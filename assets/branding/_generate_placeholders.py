"""Generate placeholder branding assets for the boilerplate.

Run from repo root: ``python3 assets/branding/_generate_placeholders.py``

Produces:
  * icon.png / icon_dev.png / icon_staging.png / icon_prod.png  (1024x1024)
  * splash.png / splash_dev.png / splash_staging.png / splash_prod.png
    (1242x2436, the iPhone X-class portrait canvas that flutter_native_splash
    expects as the source of truth for the brand mark).

These are intentionally simple, color-coded placeholders so each flavor is
visually distinguishable on the home screen and during launch. Replace them
with real artwork before shipping.
"""
from __future__ import annotations

from pathlib import Path

from PIL import Image, ImageDraw, ImageFont

HERE = Path(__file__).resolve().parent
ICON_SIZE = 1024
SPLASH_SIZE = (1242, 2436)

# (filename suffix, hex color, label)  — flavor-specific variants.
FLAVORS: list[tuple[str, str, str]] = [
    ("", "#1976D2", "B"),  # default fallback (also prod baseline)
    ("_dev", "#388E3C", "D"),
    ("_staging", "#F57C00", "S"),
    ("_prod", "#1976D2", "P"),
]


def _font(size: int) -> ImageFont.ImageFont:
    """Best-effort system font; falls back to PIL's default bitmap font."""
    for candidate in (
        "/System/Library/Fonts/SFNS.ttf",
        "/System/Library/Fonts/Helvetica.ttc",
        "/Library/Fonts/Arial.ttf",
        "/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf",
    ):
        if Path(candidate).exists():
            try:
                return ImageFont.truetype(candidate, size)
            except OSError:
                continue
    return ImageFont.load_default()


def _draw_icon(color: str, label: str, out: Path) -> None:
    img = Image.new("RGBA", (ICON_SIZE, ICON_SIZE), (0, 0, 0, 0))
    draw = ImageDraw.Draw(img)

    # Rounded square background with a 2px inset so iOS doesn't clip the
    # corner radius (iOS applies its own mask on top).
    pad = 16
    draw.rounded_rectangle(
        [(pad, pad), (ICON_SIZE - pad, ICON_SIZE - pad)],
        radius=int(ICON_SIZE * 0.22),
        fill=color,
    )

    # Centered letter mark.
    font = _font(int(ICON_SIZE * 0.55))
    bbox = draw.textbbox((0, 0), label, font=font)
    text_w = bbox[2] - bbox[0]
    text_h = bbox[3] - bbox[1]
    x = (ICON_SIZE - text_w) / 2 - bbox[0]
    y = (ICON_SIZE - text_h) / 2 - bbox[1]
    draw.text((x, y), label, fill="#FFFFFF", font=font)

    img.save(out, "PNG", optimize=True)
    print(f"  wrote {out.name}")


def _draw_splash(color: str, label: str, out: Path) -> None:
    width, height = SPLASH_SIZE
    img = Image.new("RGB", (width, height), color)
    draw = ImageDraw.Draw(img)

    # Centered brand mark on the splash canvas.
    mark_size = int(min(width, height) * 0.28)
    font = _font(int(mark_size * 0.55))
    bbox = draw.textbbox((0, 0), label, font=font)
    text_w = bbox[2] - bbox[0]
    text_h = bbox[3] - bbox[1]
    x = (width - text_w) / 2 - bbox[0]
    y = (height - text_h) / 2 - bbox[1]
    draw.text((x, y), label, fill="#FFFFFF", font=font)

    img.save(out, "PNG", optimize=True)
    print(f"  wrote {out.name}")


def main() -> None:
    print(f"Generating branding assets in {HERE} ...")
    for suffix, color, label in FLAVORS:
        icon_name = "icon.png" if suffix == "" else f"icon{suffix}.png"
        splash_name = "splash.png" if suffix == "" else f"splash{suffix}.png"
        _draw_icon(color, label, HERE / icon_name)
        _draw_splash(color, label, HERE / splash_name)
    print("Done.")


if __name__ == "__main__":
    main()