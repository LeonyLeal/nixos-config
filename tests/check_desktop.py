"""Check the generated Hyprland/DMS contract, including omitted shortcuts."""

import json
from pathlib import Path
import sys

runtime = json.loads(Path(sys.argv[1]).read_text())
cheatsheet = json.loads(Path(sys.argv[2]).read_text())
bindings = runtime["binds"]
by_key = {entry["key"]: entry for entry in bindings}
assert len(by_key) == len(bindings), "Duplicate Hyprland shortcut"

assert by_key["SUPER + RETURN"]["action"] == {"name": "exec_cmd", "args": ["kitty"]}
assert by_key["SUPER + Q"]["action"] == {"name": "window.close", "args": {}}
assert by_key["SUPER + CTRL + H"]["options"]["repeating"] is True
assert by_key["SUPER + mouse:272"]["options"]["mouse"] is True
assert by_key["XF86AudioRaiseVolume"]["options"]["locked"] is True
assert by_key["XF86AudioRaiseVolume"]["options"]["repeating"] is True
for workspace in range(1, 11):
    key = workspace % 10
    assert by_key[f"SUPER + {key}"]["action"] == {"name": "focus", "args": [{"workspace": workspace}]}
    assert by_key[f"SUPER + SHIFT + {key}"]["action"] == {"name": "window.move", "args": [{"workspace": workspace}]}

# Compare the real generated help with every actual bind, not the source list.
help_entries = [entry for group in cheatsheet["binds"].values() for entry in group]
assert len(help_entries) == len(bindings), "DMS help is missing shortcuts"
help_pairs = {(entry["key"], entry["desc"]) for entry in help_entries}
for binding in bindings:
    assert (binding["key"], binding["options"]["description"]) in help_pairs, binding["key"]
assert any(rule["name"] == "picture-in-picture" for rule in runtime["rules"])
print(f"Verified {len(bindings)} shortcuts, dispatcher arguments, flags and DMS help.")
