#!/usr/bin/env bash
set -u

quickshell=$1
transition_shell=$2
timeout_binary=${3:-timeout}
timeout_duration=${4:-8s}

COPLAND_TRANSITION_MODE=logout "$timeout_binary" \
  --signal=TERM --kill-after=1s "$timeout_duration" \
  "$quickshell" --no-duplicate --path "$transition_shell" &
animation_pid=$!

wait "$animation_pid" || :

# XDG_SESSION_ID is not consistently exported by this Hyprland session.
# An empty ID tells loginctl to terminate the session of this process.
if loginctl terminate-session "${XDG_SESSION_ID:-}"; then
  exit 0
fi

# DMS may run its power action from the user manager, outside the login scope.
if command -v hyprctl >/dev/null 2>&1 && hyprctl dispatch exit >/dev/null 2>&1; then
  exit 0
fi

printf '%s\n' "Copland logout failed: could not terminate the login session or Hyprland." >&2
exit 1
