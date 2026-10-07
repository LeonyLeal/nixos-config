{config, ...}: let
  themePath = "${config.xdg.configHome}/DankMaterialShell/themes/lain-wired.json";
  wallpaperPath = "${config.home.homeDirectory}/Imagens/Wallpapers/lain-wired.png";
in {
  desktop.dms.preset = {
    settings = {
      currentThemeName = "custom";
      currentThemeCategory = "custom";
      customThemeFile = themePath;
      matugenScheme = "scheme-neutral";
      matugenSmartMode = false;
      # GTK e Kitty são gerenciados pelo Home Manager.
      matugenTemplateGtk = false;
      matugenTemplateKitty = false;
      cornerRadius = 6;
      fontFamily = "Inter";
      monoFontFamily = "JetBrainsMono Nerd Font";
      popupTransparency = 0.98;
      dockTransparency = 0.96;
      dockBorderEnabled = true;
      dockBorderColor = "primary";
      dockBorderOpacity = 0.35;
      dockBorderThickness = 1;
      widgetBackgroundColor = "sch";
      widgetColorMode = "default";
      wallpaperFillMode = "Fill";
      # Restaura o fundo integrado ao voltar de um tema com player externo.
      screenPreferences.wallpaper = ["all"];
    };
    bar = {
      island = false;
      spacing = 4;
      innerPadding = 4;
      bottomGap = 8;
      transparency = 0.96;
      widgetTransparency = 1.0;
      squareCorners = false;
      noBackground = false;
      borderEnabled = true;
      borderColor = "primary";
      borderOpacity = 0.35;
      borderThickness = 1;
      gothCornersEnabled = false;
      widgetOutlineEnabled = false;
      shadowIntensity = 0;
    };
    defaultBar = {
      id = "default";
      name = "Wired";
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
  xdg.configFile."DankMaterialShell/themes/lain-wired.json" = {
    text = builtins.toJSON (import ./palette.nix).dms;
  };

  home.file."Imagens/Wallpapers/lain-wired.png".source = ./wallpaper.png;
}
