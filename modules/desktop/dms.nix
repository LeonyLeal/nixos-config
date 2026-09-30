{
  pkgs,
  dms,
  ...
}: {
  programs.dms-shell = {
    enable = true;
    package = dms.packages.${pkgs.stdenv.hostPlatform.system}.default;
    # Iniciado por lain-dms no Hyprland, após preparar as preferências.
    systemd.enable = false;
    enableSystemMonitoring = true;
    enableVPN = true;
    enableDynamicTheming = true;
    enableAudioWavelength = true;
    enableCalendarEvents = true;
    enableClipboardPaste = true;
  };
  programs.dms-greeter = {
    enable = true;
    compositor.name = "hyprland";
    configHome = "/home/z30n";
  };
}
