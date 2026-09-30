{pkgs, ...}: {
  # ============================================================
  # APPEARANCE
  # ============================================================
  #
  # Configuração visual consistente para aplicações GTK e Qt.
  #
  # Objetivo:
  #
  # - GTK 2/3 em modo escuro
  # - GTK 4 / Libadwaita preferindo dark mode
  # - Qt visualmente próximo do GTK
  # - Papirus Dark para ícones
  # - Bibata para cursor
  # - Inter para interface
  #

  # ============================================================
  # GTK
  # ============================================================

  gtk = {
    enable = true;

    # ----------------------------------------------------------
    # COLOR SCHEME
    # ----------------------------------------------------------
    #
    # Também influencia aplicações GTK4/Libadwaita que respeitam
    # a preferência dark do sistema.
    #

    colorScheme = "dark";

    # ----------------------------------------------------------
    # GTK 2 / GTK 3 THEME
    # ----------------------------------------------------------

    theme = {
      name = "Adwaita-dark";

      package =
        pkgs.gnome-themes-extra;
    };

    # ----------------------------------------------------------
    # ICONS
    # ----------------------------------------------------------

    iconTheme = {
      name = "Papirus-Dark";

      package =
        pkgs.papirus-icon-theme;
    };

    # ----------------------------------------------------------
    # CURSOR
    # ----------------------------------------------------------

    cursorTheme = {
      name = "Bibata-Modern-Ice";

      package =
        pkgs.bibata-cursors;

      size = 24;
    };

    # ----------------------------------------------------------
    # UI FONT
    # ----------------------------------------------------------

    font = {
      name = "Inter";

      package =
        pkgs.inter;

      size = 10;
    };

    # ----------------------------------------------------------
    # GTK 3
    # ----------------------------------------------------------

    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = true;

      gtk-button-images = true;

      gtk-menu-images = true;

      gtk-enable-event-sounds = false;

      gtk-enable-input-feedback-sounds = false;

      gtk-decoration-layout = "menu:";
    };

    # ----------------------------------------------------------
    # GTK 4
    # ----------------------------------------------------------
    #
    # Em Home Manager 26.05 não forçamos gtk.theme em GTK4.
    # Apenas declaramos dark mode e preferências compatíveis.
    #

    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = true;

      gtk-enable-event-sounds = false;

      gtk-enable-input-feedback-sounds = false;
    };
  };

  # ============================================================
  # QT
  # ============================================================
  #
  # Faz aplicações Qt seguirem uma aparência compatível
  # com o restante do desktop.
  #

  qt = {
    enable = true;

    # GTK3 é usado para integração de:
    #
    # - fontes
    # - dialogs
    # - aparência
    #
    # especialmente útil fora do Plasma.
    #

    platformTheme.name = "gtk3";

    style = {
      name = "adwaita-dark";

      package =
        pkgs.adwaita-qt;
    };
  };

  # ============================================================
  # CURSOR ENVIRONMENT
  # ============================================================
  #
  # Garante que aplicações Wayland/XWayland também encontrem
  # corretamente o cursor.
  #

  home.sessionVariables = {
    XCURSOR_THEME = "Bibata-Modern-Ice";

    XCURSOR_SIZE = "24";
  };

  # ============================================================
  # EXTRA PACKAGES
  # ============================================================

  home.packages = with pkgs; [
    # Font usada pela interface.
    inter

    # Ícones.
    papirus-icon-theme

    # Cursor.
    bibata-cursors
  ];
}
