"""The Copland logout action must end the current login session."""

from pathlib import Path
import os
import shutil
import subprocess
import tempfile
import unittest


SCRIPT = Path(__file__).resolve().parents[1] / "home/themes/copland/logout.sh"


class CoplandLogoutTests(unittest.TestCase):
    def test_quickshell_wait_is_bounded_by_eight_seconds(self):
        script = SCRIPT.read_text()
        dms = (SCRIPT.parent / "dms.nix").read_text()
        self.assertIn('timeout_duration=${4:-8s}', script)
        self.assertIn('--signal=TERM --kill-after=1s "$timeout_duration"', script)
        self.assertIn('${lib.getExe\' pkgs.coreutils "timeout"} 8s', dms)

    def run_logout(self, loginctl_exit=0, hyprctl_exit=0, quickshell_exit=0, quickshell_hangs=False):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            log = root / "calls.log"
            bindir = root / "bin"
            bindir.mkdir()
            for name, code in (("loginctl", loginctl_exit), ("hyprctl", hyprctl_exit)):
                command = bindir / name
                command.write_text(
                    "#!/bin/sh\n"
                    f"printf '{name}' >> \"$CALL_LOG\"\n"
                    "for arg in \"$@\"; do printf ' <%s>' \"$arg\" >> \"$CALL_LOG\"; done\n"
                    "printf '\\n' >> \"$CALL_LOG\"\n"
                    f"exit {code}\n"
                )
                command.chmod(0o755)
            sleep = bindir / "sleep"
            sleep.write_text("#!/bin/sh\nexit 0\n")
            sleep.chmod(0o755)
            timeout = bindir / "timeout"
            real_timeout = shutil.which("timeout")
            if real_timeout is None:
                self.fail("GNU timeout is required to test bounded logout animation")
            timeout.write_text(f"#!/bin/sh\nexec {real_timeout} \"$@\"\n")
            timeout.chmod(0o755)
            quickshell = root / "quickshell"
            if quickshell_hangs:
                quickshell.write_text(
                    "#!/bin/sh\n"
                    "printf 'animation-started\\n' >> \"$CALL_LOG\"\n"
                    "while :; do :; done\n"
                )
            else:
                quickshell.write_text(
                    "#!/bin/sh\n"
                    "printf 'animation-started\\n' >> \"$CALL_LOG\"\n"
                    "/bin/sleep 1\n"
                    f"printf 'animation-{('failed' if quickshell_exit else 'finished')}\\n' >> \"$CALL_LOG\"\n"
                    f"exit {quickshell_exit}\n"
                )
            quickshell.chmod(0o755)

            env = os.environ.copy()
            env.pop("XDG_SESSION_ID", None)
            env.update(PATH=f"{bindir}:{env['PATH']}", CALL_LOG=str(log))
            result = subprocess.run(
                [shutil.which("bash"), str(SCRIPT), str(quickshell), str(root / "shell"), str(timeout), "0.2s" if quickshell_hangs else "8s"],
                env=env,
                text=True,
                capture_output=True,
                timeout=3,
            )
            return result, log.read_text() if log.exists() else ""

    def test_terminates_callers_session_when_session_id_is_not_exported(self):
        result, calls = self.run_logout()

        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertLess(calls.index("animation-finished"), calls.index("loginctl"))
        self.assertIn("loginctl <terminate-session> <>\n", calls)
        self.assertNotIn("hyprctl", calls)

    def test_uses_hyprland_exit_if_logind_cannot_identify_callers_session(self):
        result, calls = self.run_logout(loginctl_exit=1)

        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertIn("loginctl <terminate-session> <>\n", calls)
        self.assertIn("hyprctl <dispatch> <exit>\n", calls)

    def test_terminates_session_when_animation_fails(self):
        result, calls = self.run_logout(quickshell_exit=42)

        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertLess(calls.index("animation-failed"), calls.index("loginctl"))
        self.assertIn("loginctl <terminate-session> <>\n", calls)

    def test_a_quickshell_that_never_opens_a_window_cannot_block_logout(self):
        result, calls = self.run_logout(quickshell_hangs=True)

        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertIn("animation-started\n", calls)
        self.assertIn("loginctl <terminate-session> <>\n", calls)


if __name__ == "__main__":
    unittest.main()
