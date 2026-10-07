"""The GRUB emblem is part of its centered background artwork."""

from pathlib import Path
import unittest


ROOT = Path(__file__).resolve().parents[1]
THEME = ROOT / "modules/boot/copland/grub/theme.txt"
BACKGROUND = ROOT / "modules/boot/copland/grub/background.svg"


class CoplandGrubTests(unittest.TestCase):
    def test_grub_does_not_overlay_a_second_positioned_logo(self):
        theme = THEME.read_text()
        background = BACKGROUND.read_text()

        self.assertIn('desktop-image: "background.png"', theme)
        self.assertNotIn("copland-logo.png", theme)
        self.assertNotIn("+ image {", theme)
        self.assertIn('width="1920" height="1080"', background)
        self.assertIn('transform="translate(960 270)"', background)

    def test_menu_starts_below_emblem_and_fits_ten_generations(self):
        theme = THEME.read_text()
        menu = theme.split("+ boot_menu {", 1)[1].split("}", 1)[0]
        values = {}
        for line in menu.splitlines():
            key, separator, value = line.strip().partition("=")
            if separator:
                values[key.strip()] = value.strip()

        top = float(values["top"].rstrip("%"))
        height = float(values["height"].rstrip("%"))
        item_height = int(values["item_height"])
        spacing = int(values["item_spacing"])
        padding = int(values["item_padding"])
        ten_generation_rows = 10 * item_height + 9 * spacing + 2 * padding

        # The emblem extends to about 46% of the background height; the
        # illustrated menu panel begins at 49%. Keep the menu inside that panel.
        self.assertGreaterEqual(top, 50)
        self.assertLessEqual(top + height, 89)
        self.assertLessEqual(ten_generation_rows, height / 100 * 1080)


if __name__ == "__main__":
    unittest.main()
