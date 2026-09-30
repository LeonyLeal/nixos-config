{pkgs, ...}: {
  # ============================================================
  # DESKTOP EXTRAS
  # ============================================================
  #
  # Recursos normalmente presentes em um desktop completo,
  # adicionados ao nosso stack:
  #
  # Hyprland
  # +
  # DMS
  # +
  # Thunar
  #

  # ============================================================
  # THUNAR
  # ============================================================
  #
  # O Thunar principal já está habilitado em desktop.nix.
  #
  # Aqui adicionamos somente funcionalidades extras.
  #

  # ------------------------------------------------------------
  # XFCONF
  # ------------------------------------------------------------
  #
  # Necessário para que configurações feitas pelo Thunar sejam
  # persistidas quando não usamos o XFCE completo.
  #

  programs.xfconf.enable = true;

  # ------------------------------------------------------------
  # THUNAR PLUGINS
  # ------------------------------------------------------------

  programs.thunar.plugins = with pkgs; [
    # Integração com compactadores.
    thunar-archive-plugin

    # Pendrives / mídia removível.
    thunar-volman
  ];

  # ============================================================
  # STORAGE / REMOVABLE MEDIA
  # ============================================================

  services.udisks2.enable = true;

  # ============================================================
  # DESKTOP APPLICATIONS
  # ============================================================

  environment.systemPackages = with pkgs; [
    # ----------------------------------------------------------
    # ARCHIVES
    # ----------------------------------------------------------
    #
    # ZIP
    # TAR
    # 7z
    # RAR etc.
    #

    file-roller

    # ----------------------------------------------------------
    # IMAGE VIEWER
    # ----------------------------------------------------------

    loupe

    # ----------------------------------------------------------
    # PDF
    # ----------------------------------------------------------

    papers

    # ----------------------------------------------------------
    # DISKS
    # ----------------------------------------------------------
    #
    # Interface gráfica para:
    #
    # - discos
    # - partições
    # - SMART
    # - formatação
    #

    gnome-disk-utility

    # ----------------------------------------------------------
    # CALCULATOR
    # ----------------------------------------------------------

    qalculate-gtk

    # ----------------------------------------------------------
    # VIDEO THUMBNAILS
    # ----------------------------------------------------------

    ffmpegthumbnailer

    # ----------------------------------------------------------
    # XDG UTILITIES
    # ----------------------------------------------------------
    #
    # Fornece ferramentas como:
    #
    # xdg-open
    # xdg-mime
    # xdg-settings
    #

    xdg-utils
  ];
}
