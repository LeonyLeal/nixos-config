import json
from pathlib import Path
import subprocess
import sys
import tempfile
import unittest


SCRIPT = Path(__file__).resolve().parents[1] / "home/desktop/apply-theme.py"


class ApplyThemeTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.addCleanup(self.temp.cleanup)
        self.root = Path(self.temp.name)
        self.settings = self.root / "config/settings.json"
        self.session = self.root / "state/session.json"
        self.preset = self.root / "preset.json"
        self.preset.write_text(json.dumps({
            "settings": {"currentThemeName": "custom", "cornerRadius": 6},
            "bar": {"borderEnabled": True, "island": False},
            "defaultBar": {"id": "default", "leftWidgets": ["launcherButton"]},
            "session": {"wallpaperPath": "/wallpaper.png", "isLightMode": False},
        }))

    def apply(self):
        return subprocess.run(
            [sys.executable, str(SCRIPT), str(self.preset), str(self.settings), str(self.session)],
            capture_output=True, text=True,
        )

    def seed(self):
        self.settings.parent.mkdir()
        self.session.parent.mkdir()
        self.settings.write_text(json.dumps({
            "currentThemeName": "purple", "clockFormat": "24h",
            "barConfigs": [{"id": "main", "leftWidgets": ["workspaceSwitcher"], "island": True}],
        }))
        self.session.write_text(json.dumps({"wallpaperPath": "/old.png", "weatherLocation": "Brasília"}))

    def test_preserves_widgets_and_unrelated_preferences_and_original_backup(self):
        self.seed()
        original = self.settings.read_bytes()
        result = self.apply()
        self.assertEqual(result.returncode, 0, result.stderr)
        data = json.loads(self.settings.read_text())
        self.assertEqual(data["currentThemeName"], "custom")
        self.assertEqual(data["clockFormat"], "24h")
        self.assertEqual(data["barConfigs"][0]["leftWidgets"], ["workspaceSwitcher"])
        self.assertFalse(data["barConfigs"][0]["island"])
        self.assertEqual(json.loads(self.session.read_text())["weatherLocation"], "Brasília")
        self.assertEqual(self.settings.with_suffix(".json.pre-lain").read_bytes(), original)
        before = self.settings.stat().st_mtime_ns
        self.assertEqual(self.apply().returncode, 0)
        self.assertEqual(self.settings.stat().st_mtime_ns, before)
        self.assertEqual(self.settings.with_suffix(".json.pre-lain").read_bytes(), original)

    def test_initializes_missing_preferences(self):
        result = self.apply()
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertTrue(self.settings.exists())
        self.assertEqual(json.loads(self.settings.read_text())["barConfigs"][0]["id"], "default")
        self.assertEqual(json.loads(self.session.read_text())["wallpaperPath"], "/wallpaper.png")

    def test_invalid_session_does_not_modify_settings(self):
        self.seed()
        self.session.write_text("{invalid")
        original = self.settings.read_bytes()
        self.assertNotEqual(self.apply().returncode, 0)
        self.assertEqual(self.settings.read_bytes(), original)
        self.assertEqual(self.session.read_text(), "{invalid")

    def test_refuses_symlink_without_changing_target(self):
        self.seed()
        target = self.root / "managed.json"
        self.settings.rename(target)
        self.settings.symlink_to(target)
        original = target.read_bytes()
        self.assertNotEqual(self.apply().returncode, 0)
        self.assertTrue(self.settings.is_symlink())
        self.assertEqual(target.read_bytes(), original)


if __name__ == "__main__":
    unittest.main()
