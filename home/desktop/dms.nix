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
    ${cfg.beforeStart}
    exec ${lib.getExe cfg.package} run "$@"
  '';
in {
  options.desktop.dms = {
    beforeStart = lib.mkOption {
      type = lib.types.lines;
      default = "";
      description = "Preparation commands run after the appearance preset, before DMS starts.";
    };
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

    # Apply preferences before DMS starts, including on service restarts.
    systemd.user.services.dms = {
      Unit = {
        Description = "Dank Material Shell (DMS)";
        PartOf = ["graphical-session.target"];
        After = ["graphical-session.target"];
        Requisite = ["graphical-session.target"];
      };
      Service = {
        Type = "dbus";
        BusName = "org.freedesktop.Notifications";
        ExecStart = "${lib.getExe launcher} --session";
        ExecReload = "${pkgs.coreutils}/bin/kill -USR1 $MAINPID";
        LimitNOFILE = "16384:infinity";
        Restart = "on-failure";
        RestartForceExitStatus = "TEMPFAIL";
        SuccessExitStatus = "TEMPFAIL";
        RestartSec = "1.23";
        TimeoutStartSec = "90s";
        TimeoutStopSec = "10s";
      };
      Install.WantedBy = ["graphical-session.target"];
    };

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
