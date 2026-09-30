"""Exercise plugin setup against writable preferences, without a DMS session."""
import json
from pathlib import Path
import subprocess
import sys
import tempfile
import unittest

SCRIPT = Path(__file__).resolve().parents[1] / "home/desktop/apply-theme.py"


class PluginSetupTests(unittest.TestCase):
    def setUp(self):
        temporary = tempfile.TemporaryDirectory()
        self.addCleanup(temporary.cleanup)
        self.root = Path(temporary.name)
        self.plugins = self.root / "plugin_settings.json"
        self.settings = self.root / "settings.json"
        self.preset = self.root / "preset.json"
        self.preset.write_text(json.dumps({
            "plugins": {
                "dockerManager": {"enabled": True, "terminalApp": "kitty --hold"},
                "vscodeLauncher": {"enabled": True, "trigger": "vs"},
            },
            "widgets": ["dockerManager"],
        }))

    def apply(self):
        return subprocess.run([
            sys.executable, str(SCRIPT), "--plugins", str(self.preset),
            str(self.plugins), str(self.settings),
        ], capture_output=True, text=True)

    def test_merges_plugins_preserves_preferences_and_is_idempotent(self):
        self.plugins.write_text(json.dumps({
            "other": {"enabled": True},
            "dockerManager": {"terminalApp": "alacritty", "showPortMappings": False},
        }))
        self.settings.write_text(json.dumps({"clockFormat": "24h", "barConfigs": [
            {"enabled": False, "rightWidgets": ["clock"]},
            {"id": "main", "rightWidgets": ["systemTray"]},
        ]}))
        originals = [p.read_bytes() for p in [self.plugins, self.settings]]
        result = self.apply()
        self.assertEqual(result.returncode, 0, result.stderr)
        plugins = json.loads(self.plugins.read_text())
        self.assertTrue(plugins["other"]["enabled"])
        self.assertFalse(plugins["dockerManager"]["showPortMappings"])
        self.assertEqual(plugins["dockerManager"]["terminalApp"], "kitty --hold")
        self.assertTrue(plugins["vscodeLauncher"]["enabled"])
        settings = json.loads(self.settings.read_text())
        self.assertEqual(settings["clockFormat"], "24h")
        self.assertEqual(settings["barConfigs"][0]["rightWidgets"], ["clock"])
        self.assertEqual(settings["barConfigs"][1]["rightWidgets"], ["systemTray", "dockerManager"])
        stamps = [p.stat().st_mtime_ns for p in [self.plugins, self.settings]]
        self.assertEqual(self.apply().returncode, 0)
        self.assertEqual(stamps, [p.stat().st_mtime_ns for p in [self.plugins, self.settings]])
        for path, original in zip([self.plugins, self.settings], originals):
            self.assertEqual(path.with_suffix(".json.pre-plugins").read_bytes(), original)

    def test_does_not_duplicate_widget_already_placed_as_an_object(self):
        bars = [{"leftWidgets": [{"id": "dockerManager", "enabled": True}]}]
        self.settings.write_text(json.dumps({"barConfigs": bars}))
        result = self.apply()
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertEqual(json.loads(self.settings.read_text())["barConfigs"], bars)

    def test_missing_preferences_enable_plugins_without_overriding_dms_default_layout(self):
        result = self.apply()
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertTrue(json.loads(self.plugins.read_text())["dockerManager"]["enabled"])
        self.assertNotIn("barConfigs", json.loads(self.settings.read_text()))

    def test_invalid_bar_does_not_modify_plugin_settings(self):
        self.plugins.write_text('{"other": {"enabled": true}}')
        self.settings.write_text('{"barConfigs": "invalid"}')
        original = self.plugins.read_bytes()
        result = self.apply()
        self.assertNotEqual(result.returncode, 0)
        self.assertIn("barConfigs", result.stderr)
        self.assertEqual(self.plugins.read_bytes(), original)

    def test_symlink_is_rejected_without_changing_other_preferences(self):
        target = self.root / "managed.json"
        target.write_text('{}')
        self.plugins.symlink_to(target)
        self.settings.write_text('{}')
        result = self.apply()
        self.assertNotEqual(result.returncode, 0)
        self.assertIn("symlink", result.stderr)
        self.assertEqual(target.read_text(), '{}')
        self.assertEqual(self.settings.read_text(), '{}')


if __name__ == "__main__":
    unittest.main()
