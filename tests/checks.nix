{
  pkgs,
  systemConfig,
}: let
  inherit (pkgs) lib;
  user = systemConfig.config.home-manager.users.z30n;
  source = lib.fileset.toSource {
    root = ../.;
    fileset = lib.fileset.unions [
      ../flake.nix
      ../configuration.nix
      ../hardware-configuration.nix
      ../home.nix
      ../home
      ../modules
      ./.
    ];
  };
  withoutLain = systemConfig.extendModules {
    modules = [{home-manager.users.z30n.disabledModules = [../home/themes/lain];}];
  };
  unthemed = withoutLain.config.home-manager.users.z30n;
  luaConfig = pkgs.writeText "hyprland.lua" user.xdg.configFile."hypr/hyprland.lua".text;
  cheatsheet = pkgs.writeText "z30n.json" user.xdg.configFile."DankMaterialShell/cheatsheets/z30n.json".text;
in {
  system = systemConfig.config.system.build.toplevel;
  without-lain = assert unthemed.desktop.dms.preset == null;
  assert !(unthemed.programs.kitty.settings ? custom_shaders);
  assert !(unthemed.programs.starship.settings ? palette);
    unthemed.home.activationPackage;

  formatting = pkgs.runCommand "nix-formatting" {nativeBuildInputs = [pkgs.alejandra];} ''
    alejandra --check ${source}
    touch "$out"
  '';

  lint = pkgs.runCommand "nix-lint" {nativeBuildInputs = [pkgs.statix pkgs.deadnix];} ''
    statix check ${source}
    deadnix --fail ${source}
    touch "$out"
  '';

  dms-preset = pkgs.runCommand "dms-preset-tests" {nativeBuildInputs = [pkgs.python3];} ''
    cd ${source}
    python3 -B -m unittest discover -s tests -v
    touch "$out"
  '';

  desktop = pkgs.runCommand "desktop-shortcuts" {nativeBuildInputs = [pkgs.lua pkgs.python3];} ''
    lua ${./capture_hyprland.lua} ${luaConfig} > runtime.json
    python3 ${./check_desktop.py} runtime.json ${cheatsheet}
    touch "$out"
  '';
}
