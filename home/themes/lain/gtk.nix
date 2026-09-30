_: let
  colors = (import ./palette.nix).dms;
  sharedCss = ''
    @define-color accent_color ${colors.primary};
    @define-color accent_bg_color ${colors.primary};
    @define-color accent_fg_color ${colors.primaryText};
    @define-color window_bg_color ${colors.background};
    @define-color window_fg_color ${colors.backgroundText};
    @define-color view_bg_color ${colors.surface};
    @define-color view_fg_color ${colors.surfaceText};
    @define-color headerbar_bg_color ${colors.surfaceVariant};
    @define-color headerbar_fg_color ${colors.surfaceText};
    @define-color headerbar_backdrop_color ${colors.surface};
    @define-color sidebar_bg_color ${colors.surface};
    @define-color sidebar_fg_color ${colors.surfaceText};
    @define-color card_bg_color ${colors.surfaceContainerHigh};
    @define-color card_fg_color ${colors.surfaceText};
    @define-color popover_bg_color ${colors.surfaceContainer};
    @define-color popover_fg_color ${colors.surfaceText};
    @define-color dialog_bg_color ${colors.surfaceContainer};
    @define-color dialog_fg_color ${colors.surfaceText};
    @define-color borders ${colors.outline};
  '';
in {
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      # Força aplicações compatíveis a preferirem tema escuro.
      color-scheme = "prefer-dark";

      # Libadwaita possui accents pré-definidos.
      #
      # O vermelho nativo é aproximadamente #E62D42,
      # bastante próximo do nosso Lain Red #C3263E.
      accent-color = "red";
    };
  };

  gtk.gtk3.extraCss =
    sharedCss
    + ''
      @define-color theme_bg_color ${colors.background};
      @define-color theme_fg_color ${colors.backgroundText};
      @define-color theme_base_color ${colors.surface};
      @define-color theme_text_color ${colors.surfaceText};
      @define-color theme_selected_bg_color ${colors.primary};
      @define-color theme_selected_fg_color ${colors.primaryText};
      @define-color insensitive_bg_color ${colors.surfaceVariant};
      @define-color insensitive_fg_color ${colors.surfaceVariantText};

      headerbar, .titlebar { background-image: none; box-shadow: none; }
      selection { background-color: @theme_selected_bg_color; color: @theme_selected_fg_color; }
      button, entry { border-radius: 4px; }
    '';

  gtk.gtk4.extraCss =
    sharedCss
    + ''
      :root {
        --accent-color: ${colors.primary};
        --accent-bg-color: ${colors.primary};
        --accent-fg-color: ${colors.primaryText};
        --window-bg-color: ${colors.background};
        --window-fg-color: ${colors.backgroundText};
        --view-bg-color: ${colors.surface};
        --view-fg-color: ${colors.surfaceText};
        --headerbar-bg-color: ${colors.surfaceVariant};
        --headerbar-fg-color: ${colors.surfaceText};
        --headerbar-backdrop-color: ${colors.surface};
        --sidebar-bg-color: ${colors.surface};
        --sidebar-fg-color: ${colors.surfaceText};
        --card-bg-color: ${colors.surfaceContainerHigh};
        --card-fg-color: ${colors.surfaceText};
        --popover-bg-color: ${colors.surfaceContainer};
        --popover-fg-color: ${colors.surfaceText};
        --dialog-bg-color: ${colors.surfaceContainer};
        --dialog-fg-color: ${colors.surfaceText};
      }
    '';
}
