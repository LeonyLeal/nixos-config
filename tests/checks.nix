{
  pkgs,
  systemConfig,
}: let
  inherit (pkgs) lib;
  user = systemConfig.config.home-manager.users.z30n;
  grub = systemConfig.config.boot.loader.grub;
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
  withoutTheme = systemConfig.extendModules {
    modules = [{home-manager.users.z30n.disabledModules = [../home/themes/lain ../home/themes/copland];}];
  };
  unthemed = withoutTheme.config.home-manager.users.z30n;
  luaConfig = pkgs.writeText "hyprland.lua" user.xdg.configFile."hypr/hyprland.lua".text;
  cheatsheet = pkgs.writeText "z30n.json" user.xdg.configFile."DankMaterialShell/cheatsheets/z30n.json".text;
in {
  system = systemConfig.config.system.build.toplevel;
  copland-boot = import ./copland-boot.nix {inherit pkgs;};
  copland-grub-theme = assert systemConfig.config.boot.loader.timeout == 5;
  assert grub.configurationLimit == 10;
  assert grub.timeoutStyle == "menu";
  assert lib.elem "nvidia" systemConfig.config.boot.initrd.kernelModules;
  assert lib.elem "nvidia_modeset" systemConfig.config.boot.initrd.kernelModules;
  assert lib.elem "nvidia_drm" systemConfig.config.boot.initrd.kernelModules;
  assert grub.theme != null;
  assert grub.splashImage != null;
    pkgs.runCommand "copland-grub-theme-check" {nativeBuildInputs = [pkgs.gnugrep];} ''
      test -s "${grub.theme}/theme.txt" || { echo "GRUB theme.txt is missing"; exit 1; }
      grep -q 'Copland OS' "${grub.theme}/theme.txt" || { echo "GRUB theme has no Copland label"; exit 1; }
      ! grep -q 'copland-logo.png' "${grub.theme}/theme.txt" || { echo "GRUB theme must not overlay a separately positioned logo"; exit 1; }
      test -s "${grub.theme}/background.png" || { echo "GRUB theme background is missing"; exit 1; }
      test -s "${grub.splashImage}" || { echo "GRUB splash image is missing"; exit 1; }
      touch "$out"
    '';

  plymouth-script = pkgs.runCommand "copland-plymouth-parser" {nativeBuildInputs = [pkgs.python3];} ''
    python3 - <<'PY'
    import ctypes
    lib = ctypes.CDLL("${systemConfig.config.boot.plymouth.package}/lib/plymouth/script.so")
    lib.script_parse_file.argtypes = [ctypes.c_char_p]
    lib.script_parse_file.restype = ctypes.c_void_p
    assert lib.script_parse_file(b"${../modules/boot/copland/copland.script}"), "Invalid Plymouth script"
    PY
    touch "$out"
  '';
  without-theme = assert unthemed.desktop.dms.preset == null;
  assert !(unthemed.programs.kitty.settings ? custom_shaders);
  assert !(unthemed.programs.starship.settings ? palette);
  assert !(unthemed.systemd.user.services ? copland-wallpaper);
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

  dms-preset = pkgs.runCommand "dms-preset-tests" {nativeBuildInputs = [pkgs.python3 pkgs.coreutils];} ''
    cd ${source}
    python3 -B -m unittest discover -s tests -v
    touch "$out"
  '';

  desktop = pkgs.runCommand "desktop-shortcuts" {nativeBuildInputs = [pkgs.lua pkgs.python3 systemConfig.config.programs.hyprland.package];} ''
    export XDG_RUNTIME_DIR="$TMPDIR/hyprland-runtime"
    mkdir -m 700 "$XDG_RUNTIME_DIR"
    # Valida tipos e valores com o compositor, além de executar o Lua abaixo.
    Hyprland --verify-config --config ${luaConfig}
    lua ${./capture_hyprland.lua} ${luaConfig} > runtime.json
    python3 ${./check_desktop.py} runtime.json ${cheatsheet}
    touch "$out"
  '';
}
