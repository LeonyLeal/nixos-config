{
  config,
  lib,
  osConfig,
  pkgs,
  ...
}: let
  cfg = config.desktop.dms;
  jsonFormat = pkgs.formats.json {};
  bindings = import ../hyprland/keybindings.nix {inherit lib;};
  preset = jsonFormat.generate "desktop-preset.json" cfg.preset;
  launcher = pkgs.writeShellScriptBin "desktop-shell" ''
    set -e
    ${lib.optionalString (cfg.preset != null) ''
      ${pkgs.python3}/bin/python3 ${./apply-theme.py} \
        ${preset} \
        ${lib.escapeShellArg "${config.xdg.configHome}/DankMaterialShell/settings.json"} \
        ${lib.escapeShellArg "${config.xdg.stateHome}/DankMaterialShell/session.json"}
    ''}
    exec ${lib.getExe cfg.package} run "$@"
  '';
in {
  options.desktop.dms = {
    package = lib.mkOption {
      type = lib.types.package;
      default = osConfig.programs.dms-shell.package;
      description = "DMS package used by the desktop launcher.";
    };
    preset = lib.mkOption {
      type = lib.types.nullOr jsonFormat.type;
      default = null;
      description = "Optional appearance preset with settings, bar, defaultBar and session objects.";
    };
  };

  config = {
    home.packages = [launcher];

    # Apply before DMS starts: SessionData does not reload external edits.
    xdg.configFile."hypr/hyprland.lua".text = lib.mkAfter ''
      hl.on("hyprland.start", function()
        hl.exec_cmd("${lib.getExe launcher}")
      end)
    '';

    xdg.configFile."DankMaterialShell/cheatsheets/z30n.json".text = builtins.toJSON {
      title = "Z30N Hyprland";
      provider = "z30n";
      binds = lib.mapAttrs (_: entries:
        map (binding: {
          inherit (binding) key;
          desc = binding.description;
        })
        entries)
      (lib.groupBy (binding: binding.group) bindings);
    };
  };
}
