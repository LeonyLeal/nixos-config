{lib, ...}: let
  colors = import ./palette.nix;
in {
  programs.kitty.settings =
    {
      custom_shaders = "copland-crt";
      inherit (colors) background;
      foreground = colors.text;
      url_color = colors.blue;
      cursor = colors.text;
      cursor_text_color = colors.background;
      cursor_shape = lib.mkForce "beam";
      cursor_blink_interval = lib.mkForce 0.75;
      cursor_stop_blinking_after = 0;
      selection_background = colors.selection;
      selection_foreground = colors.secondaryText;
      background_opacity = 0.85;
      active_border_color = colors.blue;
      inactive_border_color = colors.outline;
      active_tab_background = colors.selection;
      active_tab_foreground = colors.text;
      inactive_tab_background = colors.surface;
      inactive_tab_foreground = colors.lilac;
      tab_bar_background = colors.background;
      color16 = colors.orange;
      color17 = colors.error;
    }
    // builtins.listToAttrs (lib.imap0 (index: value: {
        name = "color${toString index}";
        inherit value;
      })
      colors.ansi);

  # Mantém o efeito CRT com as cores Kanagawa, sem aplicar um tint verde.
  xdg.configFile."kitty/shaders/copland-crt.pipeline".text = ''
    startgroup
        var float4 TINT = float4(1.0, 1.0, 1.0, 1.0)
        shaders crt
    endgroup
  '';
}
