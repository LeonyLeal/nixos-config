{pkgsUnstable, ...}: {
  # Kitty com shaders vem de nixpkgs-unstable. A aparência fica em themes/lain/.
  programs.kitty = {
    enable = true;
    package = pkgsUnstable.kitty;

    settings = {
      font_family = "JetBrainsMono Nerd Font";
      bold_font = "auto";
      italic_font = "auto";
      bold_italic_font = "auto";
      font_size = 12.5;
      window_padding_width = 10;
      hide_window_decorations = true;
      remember_window_size = true;
      cursor_shape = "block";
      cursor_blink_interval = 0.5;
      scrollback_lines = 20000;
      wheel_scroll_multiplier = 4.0;
      url_style = "curly";
      open_url_with = "default";
      enable_audio_bell = false;
      tab_bar_style = "powerline";
      tab_powerline_style = "slanted";
    };
  };
}
