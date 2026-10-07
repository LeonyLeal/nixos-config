"""Forward useful journal events to Plymouth; the journal remains the history."""

import json
import os
import re
import selectors
import subprocess
import sys
import time
import unicodedata


ANSI = re.compile(r"\x1b\[[0-?]*[ -/]*[@-~]|\x1b\][^\x07]*(?:\x07|\x1b\\)")
MINIMUM_MESSAGE_INTERVAL = 1.2


class StatusCoalescer:
    """Keep only the newest fast status update and pace visible changes."""

    def __init__(self, interval=MINIMUM_MESSAGE_INTERVAL):
        self.interval = interval
        self.next_allowed = 0.0
        self.last_message = None
        self.pending = None

    def push(self, message, now):
        if message == self.last_message:
            self.pending = None
            return None
        if message == self.pending:
            return None
        if now >= self.next_allowed:
            self.pending = None
            self.last_message = message
            self.next_allowed = now + self.interval
            return message
        self.pending = message
        return None

    def flush(self, now):
        if self.pending is None or now < self.next_allowed:
            return None
        message = self.pending
        self.pending = None
        self.last_message = message
        self.next_allowed = now + self.interval
        return message

    def wait_timeout(self, now):
        if self.pending is None:
            return None
        return max(0.0, self.next_allowed - now)


def safe_text(text):
    text = text.replace("…", "...").replace("—", "-").replace("–", "-")
    text = unicodedata.normalize("NFKD", text)
    return text.encode("ascii", "ignore").decode("ascii")


def format_entry(entry):
    if not isinstance(entry, dict) or not isinstance(entry.get("MESSAGE"), str):
        return None
    try:
        priority = int(entry.get("PRIORITY", 6))
    except (ValueError, TypeError):
        priority = 6
    if entry.get("_PID") != "1" and priority > 4:
        return None
    text = safe_text(ANSI.sub("", entry["MESSAGE"]))
    text = " ".join("".join(c if c.isprintable() else " " for c in text).split())
    if not text:
        return None
    prefix = "[ERRO] " if priority <= 3 else "[AVISO] " if priority == 4 else ""
    text = prefix + text
    return text if len(text) <= 160 else text[:157] + "..."


def send_status(player, message):
    try:
        result = subprocess.run(
            [player, "display-message", "--text=" + message],
            timeout=1, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL,
            check=False,
        )
    except (OSError, subprocess.TimeoutExpired):
        return False
    return result.returncode == 0


def main():
    player = sys.argv[1]
    descriptor = sys.stdin.buffer.fileno()
    selector = selectors.DefaultSelector()
    selector.register(descriptor, selectors.EVENT_READ)
    coalescer = StatusCoalescer()
    buffer = b""
    eof = False

    def queue_line(line):
        try:
            message = format_entry(json.loads(line.decode("utf-8", errors="replace")))
        except (ValueError, TypeError):
            return True
        if not message:
            return True
        ready = coalescer.push(message, time.monotonic())
        return ready is None or send_status(player, ready)

    while True:
        events = selector.select(coalescer.wait_timeout(time.monotonic()))
        for _, _ in events:
            chunk = os.read(descriptor, 4096)
            if not chunk:
                eof = True
                selector.unregister(descriptor)
                if buffer:
                    if not queue_line(buffer):
                        return
                    buffer = b""
                break
            buffer += chunk
            while b"\n" in buffer:
                line, buffer = buffer.split(b"\n", 1)
                if not queue_line(line):
                    return

        ready = coalescer.flush(time.monotonic())
        if ready is not None and not send_status(player, ready):
            return  # Plymouth has handed the display over; never delay boot.
        if eof and coalescer.pending is None:
            return


if __name__ == "__main__":
    main()
