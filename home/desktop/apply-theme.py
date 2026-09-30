"""Apply versioned appearance or plugin presets to writable DMS preferences."""

import json
import os
from pathlib import Path
import sys
import tempfile


def read_preferences(path):
    if path.is_symlink():
        raise ValueError(f"{path} is managed by a symlink; refusing to replace it")
    data = json.loads(path.read_text()) if path.exists() else {}
    if not isinstance(data, dict):
        raise ValueError(f"{path} must contain a JSON object")
    return data


def write_preferences(path, data, backup_suffix=".pre-lain"):
    content = json.dumps(data, ensure_ascii=False, indent=2) + "\n"
    if path.exists() and json.loads(path.read_text()) == data:
        return
    path.parent.mkdir(parents=True, exist_ok=True)
    if path.exists():
        # Keep the original backup name for existing installations.
        backup = path.with_suffix(path.suffix + backup_suffix)
        try:
            with backup.open("xb") as output:
                output.write(path.read_bytes())
        except FileExistsError:
            pass
    with tempfile.NamedTemporaryFile(mode="w", dir=path.parent, delete=False) as output:
        temporary = Path(output.name)
        try:
            output.write(content)
            output.flush()
            os.fsync(output.fileno())
            os.replace(temporary, path)
        finally:
            temporary.unlink(missing_ok=True)


def apply_plugins(preset_path, plugins_path, settings_path):
    preset = read_preferences(preset_path)
    plugins = read_preferences(plugins_path)
    settings = read_preferences(settings_path)
    for plugin_id, options in preset["plugins"].items():
        current = plugins.get(plugin_id, {})
        if not isinstance(current, dict):
            raise ValueError(f"{plugin_id} settings must be a JSON object")
        plugins[plugin_id] = current | options

    bars = settings.get("barConfigs", [])
    if not isinstance(bars, list) or not all(isinstance(bar, dict) for bar in bars):
        raise ValueError("barConfigs must be a list of objects")
    present = set()
    for bar in bars:
        for section in ("leftWidgets", "centerWidgets", "rightWidgets"):
            widgets = bar.get(section, [])
            if not isinstance(widgets, list):
                raise ValueError(f"{section} must be a list")
            for widget in widgets:
                widget_id = widget.get("id") if isinstance(widget, dict) else widget
                if not isinstance(widget_id, str):
                    raise ValueError("Each widget must have a string id")
                present.add(widget_id)
    active_bar = next((bar for bar in bars if bar.get("enabled", True)), None)
    if active_bar is not None:
        for widget_id in preset["widgets"]:
            if widget_id not in present:
                active_bar.setdefault("rightWidgets", []).append(widget_id)
                present.add(widget_id)

    # Validate both documents before modifying either; keep unrelated UI options.
    write_preferences(plugins_path, plugins, ".pre-plugins")
    write_preferences(settings_path, settings, ".pre-plugins")


def main():
    if sys.argv[1:2] == ["--plugins"]:
        apply_plugins(*map(Path, sys.argv[2:]))
        return
    preset_path, settings_path, session_path = map(Path, sys.argv[1:])
    preset = json.loads(preset_path.read_text())
    # Read and validate both files before changing either one.
    settings = read_preferences(settings_path)
    session = read_preferences(session_path)
    settings.update(preset["settings"])
    bars = settings.get("barConfigs", [preset["defaultBar"]])
    if not isinstance(bars, list) or not all(isinstance(bar, dict) for bar in bars):
        raise ValueError("barConfigs must be a list of objects")
    settings["barConfigs"] = [bar | preset["bar"] for bar in bars]
    session.update(preset["session"])
    write_preferences(settings_path, settings)
    write_preferences(session_path, session)


if __name__ == "__main__":
    try:
        main()
    except (OSError, ValueError) as error:
        sys.exit(f"DMS preset: {error}")
