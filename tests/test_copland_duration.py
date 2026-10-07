"""Boot and shutdown wait only for the unfinished part of the minimum splash."""

import importlib.util
from pathlib import Path
import unittest


SCRIPT = Path(__file__).resolve().parents[1] / "modules/boot/copland/duration.py"
PLYMOUTH_THEME = Path(__file__).resolve().parents[1] / "modules/boot/copland/copland.script"


class CoplandDurationTests(unittest.TestCase):
    def setUp(self):
        self.assertTrue(SCRIPT.exists(), "The shared Copland splash timer is not implemented")
        spec = importlib.util.spec_from_file_location("copland_duration", SCRIPT)
        self.module = importlib.util.module_from_spec(spec)
        spec.loader.exec_module(self.module)

    def test_minimum_splash_duration_is_sixteen_seconds(self):
        self.assertEqual(self.module.MINIMUM_SPLASH_SECONDS, 16.0)

    def test_minimum_shutdown_duration_is_three_seconds(self):
        self.assertEqual(self.module.MINIMUM_SHUTDOWN_SECONDS, 3.0)
        self.assertEqual(self.module.remaining_seconds(started=100, now=102, minimum=3), 1)

    def test_boot_emblem_begins_without_a_black_hold(self):
        script = PLYMOUTH_THEME.read_text()
        self.assertIn("local.appear = Math.Clamp(time / 1.1, 0, 1)", script)
        self.assertNotIn("Math.Clamp((time - 1.6) / 1.1, 0, 1)", script)

    def test_wait_is_bounded_by_time_already_spent_in_the_splash(self):
        self.assertEqual(self.module.remaining_seconds(started=100, now=110, minimum=16), 6)
        self.assertEqual(self.module.remaining_seconds(started=100, now=125, minimum=16), 0)

    def test_shutdown_animation_finishes_in_three_seconds(self):
        script = PLYMOUTH_THEME.read_text()
        self.assertIn("Math.Clamp(time / 3, 0, 1)", script)
        self.assertIn("Math.Clamp((time - 2.4) / 0.6, 0, 1)", script)
        self.assertIn("Math.Clamp((3 - time) / 0.5, 0, 1)", script)
        self.assertIn('show_status("Desligando o sistema...")', script)
        self.assertIn('show_status("Reiniciando o sistema...")', script)
        self.assertNotIn("E N T E R P R I S E", script)
        self.assertIn('mode == "reboot"', script)

    def test_shutdown_gate_uses_short_duration_without_changing_boot_minimum(self):
        boot_module = (SCRIPT.parent / "default.nix").read_text()
        self.assertIn("duration.py} /run/copland-splash-start 16", boot_module)
        self.assertIn("duration.py} /run/copland-shutdown-start 3", boot_module)
        self.assertIn('lib.optionals config.hardware.nvidia.enabled ["nvidia" "nvidia_modeset" "nvidia_drm"]', boot_module)


if __name__ == "__main__":
    unittest.main()
