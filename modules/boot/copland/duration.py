"""Wait only for the remainder of Copland's minimum visible transition."""

from pathlib import Path
import sys
import time


MINIMUM_SPLASH_SECONDS = 16.0
MINIMUM_SHUTDOWN_SECONDS = 3.0


def remaining_seconds(started, now, minimum=MINIMUM_SPLASH_SECONDS):
    return max(0.0, minimum - (now - started))


def main():
    marker = Path(sys.argv[1])
    minimum = float(sys.argv[2]) if len(sys.argv) > 2 else MINIMUM_SPLASH_SECONDS
    try:
        started = float(marker.read_text())
    except (OSError, ValueError):
        started = time.monotonic()
    time.sleep(remaining_seconds(started, time.monotonic(), minimum))


if __name__ == "__main__":
    main()
