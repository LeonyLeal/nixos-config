"""The login overlay waits for Hyprland's Wayland socket before launching."""

from pathlib import Path
import os
import shutil
import subprocess
import tempfile
import unittest


SCRIPT = Path(__file__).resolve().parents[1] / "home/themes/copland/login.sh"
TRANSITION = Path(__file__).resolve().parents[1] / "home/themes/copland/transition.qml"


class CoplandLoginTests(unittest.TestCase):
    def test_login_and_logout_use_a_short_two_point_four_second_timeline(self):
        qml = TRANSITION.read_text()
        self.assertIn("readonly property real transitionDuration: 2.4", qml)
        self.assertIn("elapsed / shellRoot.transitionDuration", qml)
        self.assertNotIn("elapsed / 16", qml)
        self.assertIn("Navi: encerrando a sessao com seguranca...", qml)
        self.assertNotIn("E N T E R P R I S E", qml)
        self.assertNotIn("interval: 3600", qml)
        self.assertIn("interval: 16", qml)
        self.assertIn("statusPhaseDuration: shellRoot.transitionDuration / 2", qml)

    def test_transition_clock_uses_elapsed_wall_time(self):
        qml = TRANSITION.read_text()
        self.assertIn("property double startedAtMs: Date.now()", qml)
        self.assertIn("property double clockMs: startedAtMs", qml)
        self.assertIn("(clockMs - startedAtMs) / 1000", qml)
        self.assertIn("shellRoot.clockMs = Date.now()", qml)

    def test_transition_does_not_set_unsupported_quickshell_timer_type(self):
        self.assertNotIn("timerType:", TRANSITION.read_text())

    def test_login_logo_has_no_initial_hold(self):
        qml = TRANSITION.read_text()
        self.assertIn("pragma ComponentBehavior: Bound", qml)
        self.assertIn("model: Quickshell.screens", qml)
        self.assertIn("PanelWindow {", qml)
        self.assertIn("readonly property real progress: Math.min(elapsed / shellRoot.transitionDuration, 1)", qml)
        self.assertIn("if (shellRoot.firstWindowReady && shellRoot.elapsed >= shellRoot.finishAt)", qml)
        self.assertIn("Qt.quit()", qml)
        self.assertIn('console.info("Copland transition window opened:', qml)
        self.assertIn("shellRoot.transitionDuration - 0.6", qml)
        self.assertIn(": Math.max(0, Math.min(elapsed / 0.45, 1))", qml)
        self.assertNotIn("(elapsed - 2.2) / 3.5", qml)

    def test_late_monitor_gets_a_full_animation_before_shell_exit(self):
        qml = TRANSITION.read_text()
        self.assertIn("ShellRoot {", qml)
        shared_scope = qml.split("ShellRoot {", 1)[1].split("Variants {", 1)[0]
        self.assertIn("property double startedAtMs: Date.now()", shared_scope)
        self.assertIn("readonly property real elapsed: Math.max(0, (clockMs - startedAtMs) / 1000)", shared_scope)
        self.assertIn("readonly property real transitionDuration: 2.4", shared_scope)
        self.assertIn("property real finishAt: transitionDuration", shared_scope)
        self.assertIn("Timer {", shared_scope)
        self.assertIn("Qt.quit()", shared_scope)
        self.assertIn("shellRoot.elapsed >= shellRoot.finishAt", shared_scope)
        self.assertEqual(qml.count("Timer {"), 1)
        self.assertEqual(qml.count("Qt.quit()"), 2)
        panel = qml.split("PanelWindow {", 1)[1]
        self.assertIn("property real startedAt: 0", panel)
        self.assertIn("readonly property real elapsed: Math.max(0, shellRoot.elapsed - startedAt)", panel)
        self.assertIn("Component.onCompleted", panel)
        self.assertIn("shellRoot.finishAt = Math.max(", panel)
        self.assertIn("shellRoot.elapsed + shellRoot.transitionDuration", panel)

    def test_shell_waits_for_first_monitor_window_before_finishing(self):
        qml = TRANSITION.read_text()
        shared_scope = qml.split("ShellRoot {", 1)[1].split("Variants {", 1)[0]
        panel = qml.split("PanelWindow {", 1)[1]
        self.assertIn("property bool firstWindowReady: false", shared_scope)
        self.assertIn("property real firstWindowDeadline: 7", shared_scope)
        self.assertIn("shellRoot.firstWindowReady && shellRoot.elapsed >= shellRoot.finishAt", shared_scope)
        self.assertIn("shellRoot.elapsed >= shellRoot.firstWindowDeadline", shared_scope)
        self.assertIn("shellRoot.firstWindowReady = true", panel)
        self.assertIn("required property var modelData", panel)

    def test_login_and_logout_use_distinct_quickshell_config_paths(self):
        dms = (SCRIPT.parent / "dms.nix").read_text()
        self.assertIn("${transitionShell}/login", dms)
        self.assertIn("${transitionShell}/logout", dms)

    def test_launches_without_waiting_for_a_monitor(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            runtime = root / "runtime"
            runtime.mkdir()
            log = root / "calls.log"
            hypr_calls = root / "hyprctl-calls.log"
            sleep_calls = root / "sleep-calls.log"
            bindir = root / "bin"
            bindir.mkdir()

            hyprctl = bindir / "hyprctl"
            hyprctl.write_text("#!/bin/sh\nprintf 'called\\n' >> \"$HYPR_CALLS\"\nexit 1\n")
            hyprctl.chmod(0o755)

            sleep = bindir / "sleep"
            sleep.write_text("#!/bin/sh\nprintf 'called\\n' >> \"$SLEEP_CALLS\"\n")
            sleep.chmod(0o755)

            quickshell = root / "quickshell"
            quickshell.write_text(
                "#!/bin/sh\n"
                "printf 'launch' >> \"$CALL_LOG\"\n"
                "for arg in \"$@\"; do printf ' <%s>' \"$arg\" >> \"$CALL_LOG\"; done\n"
                "printf '\\n' >> \"$CALL_LOG\"\n"
            )
            quickshell.chmod(0o755)

            env = os.environ.copy()
            env.update(
                XDG_RUNTIME_DIR=str(runtime), HYPRLAND_INSTANCE_SIGNATURE="test-session",
                CALL_LOG=str(log), HYPR_CALLS=str(hypr_calls), SLEEP_CALLS=str(sleep_calls),
            )
            command = [shutil.which("bash"), str(SCRIPT), str(quickshell), str(root / "shell"),
                       str(hyprctl), shutil.which("grep"), str(sleep)]
            result = subprocess.run(command, env=env, text=True, capture_output=True)
            self.assertFalse(hypr_calls.exists(), "login must not poll hyprctl for monitor readiness")
            self.assertFalse(sleep_calls.exists(), "login must not wait for monitor readiness")
            self.assertEqual(result.returncode, 0, result.stderr)
            self.assertEqual(log.read_text().count("launch"), 1)
            self.assertIn("launch <--no-duplicate> <--path>", log.read_text())

    def test_launches_only_once_per_session(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            runtime = root / "runtime"
            runtime.mkdir()
            log = root / "calls.log"
            quickshell = root / "quickshell"
            quickshell.write_text("#!/bin/sh\nprintf 'launch\\n' >> \"$CALL_LOG\"\n")
            quickshell.chmod(0o755)

            env = os.environ.copy()
            env.update(
                XDG_RUNTIME_DIR=str(runtime), HYPRLAND_INSTANCE_SIGNATURE="test-session",
                CALL_LOG=str(log),
            )
            command = [shutil.which("bash"), str(SCRIPT), str(quickshell), str(root / "shell")]
            first = subprocess.run(command, env=env, text=True, capture_output=True)
            repeated = subprocess.run(command, env=env, text=True, capture_output=True)

            self.assertEqual(first.returncode, 0, first.stderr)
            self.assertEqual(repeated.returncode, 0, repeated.stderr)
            self.assertEqual(log.read_text().splitlines(), ["launch"])
            self.assertTrue((runtime / "copland-login-test-session").is_dir())



if __name__ == "__main__":
    unittest.main()
