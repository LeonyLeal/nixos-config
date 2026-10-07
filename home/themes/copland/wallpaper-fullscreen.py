"""Stop the shared wallpaper player while any Hyprland client is fullscreen."""

import json
import subprocess
import sys


def has_fullscreen_client(clients):
    if not isinstance(clients, list):
        raise ValueError("Hyprland did not return a client list")
    return any(
        isinstance(client, dict)
        and isinstance(client.get("fullscreen", 0), (bool, int))
        and client.get("fullscreen", 0) > 0
        for client in clients
    )


def main():
    hyprctl, systemctl = sys.argv[1:3]
    result = subprocess.run(
        [hyprctl, "-j", "clients"], capture_output=True, text=True, check=True,
    )
    clients = json.loads(result.stdout)
    action = "stop" if has_fullscreen_client(clients) else "start"
    subprocess.run(
        [systemctl, "--user", action, "copland-wallpaper.service"],
        check=True,
    )


if __name__ == "__main__":
    main()
