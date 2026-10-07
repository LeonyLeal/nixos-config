"""The animated background stops globally while any monitor is fullscreen."""

import json
from pathlib import Path
import subprocess
import sys
import tempfile
import unittest


SCRIPT = Path(__file__).resolve().parents[1] / "home/themes/copland/wallpaper-fullscreen.py"


class WallpaperFullscreenTests(unittest.TestCase):
    def run_check(self, clients):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            clients_file = root / "clients.json"
            clients_file.write_text(json.dumps(clients))
            calls = root / "systemctl.log"
            hyprctl = root / "hyprctl"
            hyprctl.write_text(
                "#!/bin/sh\n"
                "[ \"$1\" = -j ] && [ \"$2\" = clients ] || exit 2\n"
                "cat \"$CLIENTS_FILE\"\n"
            )
            hyprctl.chmod(0o755)
            systemctl = root / "systemctl"
            systemctl.write_text(
                "#!/bin/sh\nprintf '%s\\n' \"$*\" >> \"$SYSTEMCTL_LOG\"\n"
            )
            systemctl.chmod(0o755)
            import os
            env = os.environ.copy()
            env.update(CLIENTS_FILE=str(clients_file), SYSTEMCTL_LOG=str(calls))
            result = subprocess.run(
                [sys.executable, str(SCRIPT), str(hyprctl), str(systemctl)],
                env=env, text=True, capture_output=True,
            )
            return result, calls.read_text().splitlines() if calls.exists() else []

    def test_fullscreen_window_on_second_monitor_stops_the_single_wallpaper_service(self):
        result, calls = self.run_check([
            {"monitor": 0, "fullscreen": 0},
            {"monitor": 1, "fullscreen": 2},
        ])
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertEqual(calls, ["--user stop copland-wallpaper.service"])

    def test_no_fullscreen_clients_restarts_the_wallpaper_service(self):
        result, calls = self.run_check([
            {"monitor": 0, "fullscreen": 0},
            {"monitor": 1, "fullscreen": 0},
        ])
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertEqual(calls, ["--user start copland-wallpaper.service"])

    def test_invalid_hyprland_state_does_not_change_the_service(self):
        result, calls = self.run_check({"unexpected": True})
        self.assertNotEqual(result.returncode, 0)
        self.assertEqual(calls, [])


if __name__ == "__main__":
    unittest.main()
