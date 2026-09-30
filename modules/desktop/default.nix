{pkgs, ...}: {
  imports = [./hyprland.nix ./dms.nix];

  fonts.fontconfig.enable = true;
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.meslo-lg
    nerd-fonts.fira-code
    noto-fonts-color-emoji
  ];

  programs.thunar = {
    enable = true;
    plugins = with pkgs; [thunar-archive-plugin thunar-volman];
  };
  programs.xfconf.enable = true;
  services = {
    gvfs.enable = true;
    tumbler.enable = true;
    udisks2.enable = true;
    pulseaudio.enable = false;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
    printing.enable = true;
  };

  security.polkit.enable = true;

  security.rtkit.enable = true;

  # Integrações e utilitários compartilhados do desktop.
  environment.systemPackages = with pkgs; [
    xdg-user-dirs
    xdg-utils
    ffmpegthumbnailer
    wl-clipboard
    grim
    slurp
    playerctl
    brightnessctl
  ];
}
