"""Exercise wallpaper source selection without starting a graphical player."""

import json
from pathlib import Path
import subprocess
import sys
import tempfile
import unittest


SCRIPT = Path(__file__).resolve().parents[1] / "home/themes/copland/wallpaper.sh"
CONFIG = Path(__file__).resolve().parents[1] / "home/themes/copland/wallpaper.nix"


class WallpaperTests(unittest.TestCase):
    def test_uses_downloaded_video_with_spaces_in_path(self):
        self.check_source(video_present=True)

    def test_missing_video_uses_static_fallback(self):
        self.check_source(video_present=False)

    def test_static_fallback_stays_visible_indefinitely(self):
        self.assertIn("image-display-duration=inf", CONFIG.read_text())

    def check_source(self, video_present):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            video = root / "Copland OS [1080p].mp4"
            fallback = root / "static.png"
            fallback.write_bytes(b"static")
            if video_present:
                video.write_bytes(b"video")
            # Capture the argv passed to the external player; no Wayland required.
            result = subprocess.run([
                "bash", str(SCRIPT), str(video), str(fallback), sys.executable,
                "-c", "import json,sys; print(json.dumps(sys.argv[1:]))",
                "-o", "no-config no-audio loop-file=inf image-display-duration=inf vf=fps=30 cache=no demuxer-max-bytes=64MiB demuxer-max-back-bytes=16MiB hwdec=auto-safe",
            ], capture_output=True, text=True)
            self.assertEqual(result.returncode, 0, result.stderr)
            self.assertEqual(json.loads(result.stdout), [
                "-o", "no-config no-audio loop-file=inf image-display-duration=inf vf=fps=30 cache=no demuxer-max-bytes=64MiB demuxer-max-back-bytes=16MiB hwdec=auto-safe",
                "--auto-stop", "ALL",
                str(video if video_present else fallback),
            ])
