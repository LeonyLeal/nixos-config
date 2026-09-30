{lib, ...}: let
  colors = import ./palette.nix;
in {
  programs.kitty.settings =
    {
      custom_shaders = "lain-crt";
      background = colors.terminalBackground;
      foreground = colors.text;
      url_color = colors.brightBlue;
      cursor = colors.red;
      cursor_text_color = colors.background;
      selection_background = colors.redContainer;
      selection_foreground = colors.onRed;
      background_opacity = 0.92;
      active_border_color = colors.red;
      inactive_border_color = colors.inactiveBorder;
      active_tab_background = colors.redContainer;
      active_tab_foreground = colors.onRed;
      inactive_tab_background = colors.surface;
      inactive_tab_foreground = colors.muted;
      tab_bar_background = colors.background;
    }
    // builtins.listToAttrs (lib.imap0 (index: value: {
        name = "color${toString index}";
        inherit value;
      })
      colors.ansi);

  # Tint neutro mantém as cores ANSI e os destaques vermelhos no shader CRT.
  xdg.configFile."kitty/shaders/lain-crt.pipeline".text = ''
    startgroup
        var float4 TINT = float4(1.0, 1.0, 1.0, 1.0)
        shaders crt
    endgroup
  '';
}
