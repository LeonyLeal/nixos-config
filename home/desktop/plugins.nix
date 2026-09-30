{
  config,
  inputs,
  lib,
  osConfig,
  pkgs,
  ...
}: let
  preset = pkgs.writeText "dms-plugins-preset.json" (builtins.toJSON {
    plugins = {
      dockerManager = {
        enabled = true;
        dockerBinary = lib.getExe osConfig.virtualisation.docker.package;
        terminalApp = "${lib.getExe config.programs.kitty.package} --hold";
      };
      vscodeLauncher = {
        enabled = true;
        editorMode = "VSCode";
        customExecutable = lib.getExe pkgs.vscode;
        trigger = "vs";
      };
    };
    widgets = ["dockerManager"];
  });
in {
  xdg.configFile = {
    "DankMaterialShell/plugins/dockerManager".source = inputs.dms-docker-manager;
    "DankMaterialShell/plugins/vscodeLauncher".source = inputs.dms-vscode-launcher;
  };

  # DMS must be stopped while preparing its writable settings.
  desktop.dms.beforeStart = ''
    ${pkgs.python3}/bin/python3 ${./apply-theme.py} --plugins \
      ${preset} \
      ${lib.escapeShellArg "${config.xdg.configHome}/DankMaterialShell/plugin_settings.json"} \
      ${lib.escapeShellArg "${config.xdg.configHome}/DankMaterialShell/settings.json"}
  '';
}
