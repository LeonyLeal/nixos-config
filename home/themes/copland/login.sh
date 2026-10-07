#!/usr/bin/env bash
set -u

quickshell=$1
transition_shell=$2

runtime="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}"
marker="$runtime/copland-login-${HYPRLAND_INSTANCE_SIGNATURE:-unknown}"
if ! mkdir "$marker" 2>/dev/null; then
  exit 0
fi

export COPLAND_TRANSITION_MODE=login
exec "$quickshell" --no-duplicate --path "$transition_shell"
