"""Apply a versioned appearance preset to writable DMS preferences."""

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


def write_preferences(path, data):
    content = json.dumps(data, ensure_ascii=False, indent=2) + "\n"
    if path.exists() and json.loads(path.read_text()) == data:
        return
    path.parent.mkdir(parents=True, exist_ok=True)
    if path.exists():
        # Keep the original backup name for existing installations.
        backup = path.with_suffix(path.suffix + ".pre-lain")
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


def main():
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
