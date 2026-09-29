{ config, pkgs, dms, ... }:

{
  # ============================================================
  # GRAPHICS
  # ============================================================

  hardware.graphics = {
    enable = true;

    enable32Bit = true;
  };


  # ============================================================
  # NVIDIA RTX 4060
  # ============================================================

  services.xserver.videoDrivers = [
    "nvidia"
  ];


  hardware.nvidia = {
    modesetting.enable =
      true;

    open =
      true;

    nvidiaSettings =
      true;

    powerManagement.enable =
      false;

    package =
      config.boot.kernelPackages.nvidiaPackages.stable;
  };


  # ============================================================
  # HYPRLAND
  # ============================================================

  programs.hyprland = {
    enable = true;

    withUWSM = true;

    xwayland.enable = true;
  };


  # ============================================================
  # DANK MATERIAL SHELL
  # ============================================================

  programs.dms-shell = {
    enable = true;

    package =
      dms.packages.${pkgs.stdenv.hostPlatform.system}.default;

    # O teu Hyprland já inicia DMS.
    systemd.enable =
      false;

    enableSystemMonitoring =
      true;

    enableVPN =
      true;

    enableDynamicTheming =
      true;

    enableAudioWavelength =
      true;

    enableCalendarEvents =
      true;

    enableClipboardPaste =
      true;
  };


  # ============================================================
  # DANK GREETER
  # ============================================================

  programs.dms-greeter = {
    enable = true;

    compositor.name =
      "hyprland";

    configHome =
      "/home/z30n";
  };


  # ============================================================
  # FILE MANAGER
  # ============================================================

  programs.thunar.enable =
    true;


  services.gvfs.enable =
    true;


  services.tumbler.enable =
    true;


  # ============================================================
  # POLKIT
  # ============================================================

  security.polkit.enable =
    true;


  # ============================================================
  # WAYLAND
  # ============================================================

  environment.sessionVariables = {
    NIXOS_OZONE_WL =
      "1";
  };


  # ============================================================
  # AUDIO
  # ============================================================

  services.pulseaudio.enable =
    false;


  security.rtkit.enable =
    true;


  services.pipewire = {
    enable = true;

    alsa.enable = true;

    alsa.support32Bit = true;

    pulse.enable = true;
  };


  # ============================================================
  # PRINTING
  # ============================================================

  services.printing.enable =
    true;


  # ============================================================
  # DESKTOP PACKAGES
  # ============================================================

  environment.systemPackages = with pkgs; [
    kitty

    spotify

    obsidian

    syncthing

    vlc

    discord

    stremio-linux-shell

    qbittorrent

    qutebrowser

    cmatrix

    xdg-user-dirs

    wl-clipboard

    grim

    slurp

    playerctl

    pavucontrol

    brightnessctl
  ];
}