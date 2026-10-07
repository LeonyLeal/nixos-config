{
  config,
  lib,
  osConfig,
  pkgs,
  ...
}: let
  themePath = "${config.xdg.configHome}/DankMaterialShell/themes/copland-os.json";
  wallpaperPath = "${config.home.homeDirectory}/Imagens/Wallpapers/lain-wired.png";
  transitionShell = pkgs.runCommand "copland-transition-shell" {} ''
    for mode in login logout; do
      mkdir -p "$out/$mode"
      cp ${./transition.qml} "$out/$mode/shell.qml"
      cp ${../../../modules/boot/copland/logo.svg} "$out/$mode/logo.svg"
      cp ${../../../modules/boot/copland/orb.svg} "$out/$mode/orb.svg"
      cp ${../../../modules/boot/copland/ripple.svg} "$out/$mode/ripple.svg"
      cp ${../../../modules/boot/copland/scanlines.svg} "$out/$mode/scanlines.svg"
    done
  '';
  quickshell = lib.getExe osConfig.programs.dms-shell.quickshell.package;
  loginAnimation = pkgs.writeShellScript "copland-login-animation-start" ''
    exec ${pkgs.bash}/bin/bash ${./login.sh} \
      ${quickshell} \
      ${transitionShell}/login
  '';
  wallpaperFullscreenCheck = pkgs.writeShellScript "copland-wallpaper-fullscreen-check" ''
    exec ${pkgs.python3}/bin/python3 ${./wallpaper-fullscreen.py} \
      ${lib.getExe' osConfig.programs.hyprland.package "hyprctl"} \
      ${lib.getExe' pkgs.systemd "systemctl"}
  '';
  logoutAction = pkgs.writeShellScriptBin "copland-logout" ''
    exec ${pkgs.bash}/bin/bash ${./logout.sh} \
      ${quickshell} ${transitionShell}/logout \
      ${lib.getExe' pkgs.coreutils "timeout"} 8s
  '';
in {
  desktop.dms.logoutCommand = lib.getExe logoutAction;

  desktop.dms.preset = {
    settings = {
      currentThemeName = "custom";
      currentThemeCategory = "custom";
      customThemeFile = themePath;
      matugenScheme = "scheme-neutral";
      matugenSmartMode = false;
      matugenTemplateGtk = false;
      matugenTemplateKitty = false;
      customPowerActionLogout = lib.getExe logoutAction;
      cornerRadius = 12;
      fontFamily = "Inter";
      monoFontFamily = "JetBrainsMono Nerd Font";
      popupTransparency = 0.95;
      dockTransparency = 0.85;
      dockBorderEnabled = false;
      widgetBackgroundColor = "s";
      widgetColorMode = "colorful";
      wallpaperFillMode = "Fill";
    };
    bar = {
      # DankIsland é outra interface; preserva a barra e seus widgets.
      island = false;
      spacing = 5;
      innerPadding = 4;
      bottomGap = 8;
      transparency = 0.0;
      widgetTransparency = 0.75;
      squareCorners = false;
      noBackground = false;
      borderEnabled = false;
      gothCornersEnabled = false;
      widgetOutlineEnabled = false;
      shadowIntensity = 0;
    };
    defaultBar = {
      id = "default";
      name = "CoplandOS";
      enabled = true;
      position = 0;
      screenPreferences = ["all"];
      leftWidgets = ["launcherButton" "workspaceSwitcher" "focusedWindow"];
      centerWidgets = ["clock"];
      rightWidgets = ["systemTray" "cpuUsage" "memUsage" "notificationButton" "controlCenterButton"];
    };
    session = {
      isLightMode = false;
      inherit wallpaperPath;
      perMonitorWallpaper = false;
      perModeWallpaper = false;
      wallpaperCyclingEnabled = false;
      wallpaperTransition = "fade";
    };
  };

  xdg.configFile."DankMaterialShell/themes/copland-os.json".text =
    builtins.toJSON (import ./palette.nix).dms;
  home.file."Imagens/Wallpapers/lain-wired.png".source = ../lain/wallpaper.png;
  xdg.configFile."hypr/hyprland.lua".text = lib.mkAfter ''
    hl.on("hyprland.start", function()
      hl.exec_cmd("${loginAnimation}")
      hl.exec_cmd("${wallpaperFullscreenCheck}")
    end)
    hl.on("window.fullscreen", function()
      hl.exec_cmd("${wallpaperFullscreenCheck}")
    end)
    hl.on("window.destroy", function()
      hl.exec_cmd("${wallpaperFullscreenCheck}")
    end)
  '';
}
