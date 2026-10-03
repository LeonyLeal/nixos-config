{
  pkgs,
  dms,
  ...
}: {
  programs.dms-shell = {
    enable = true;
    package = dms.packages.${pkgs.stdenv.hostPlatform.system}.default;
    # O Home Manager gerencia dms.service com o launcher desktop-shell.
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
