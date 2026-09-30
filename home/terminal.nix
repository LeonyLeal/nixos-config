{ ... }:

{
  # ============================================================
  # KITTY - PIP-BOY CRT
  # ============================================================

  home.file.".config/kitty/kitty.conf".text = ''
    # ==========================================================
    # FONT
    # ==========================================================

    font_family JetBrainsMono Nerd Font
    bold_font auto
    italic_font auto
    bold_italic_font auto

    font_size 12.5


    # ==========================================================
    # PIP-BOY / PHOSPHOR COLORS
    # ==========================================================

    background #050B05

    foreground #8AFF80

    cursor #B7FF96

    cursor_text_color #050B05

    selection_foreground #050B05

    selection_background #71FF6A


    # ==========================================================
    # ANSI PALETTE
    # ==========================================================

    color0  #071007
    color1  #FF6B6B
    color2  #7CFF7C
    color3  #E8FF6A
    color4  #63B8FF
    color5  #C792EA
    color6  #57FFF1
    color7  #C7FFC7

    color8  #386038
    color9  #FF8A80
    color10 #ADFF8A
    color11 #F4FF91
    color12 #82CFFF
    color13 #D7A7FF
    color14 #8FFFF7
    color15 #E7FFE7


    # ==========================================================
    # WINDOW
    # ==========================================================

    background_opacity 0.97

    window_padding_width 10

    hide_window_decorations yes

    remember_window_size yes


    # ==========================================================
    # CURSOR
    # ==========================================================

    cursor_shape block

    cursor_blink_interval 0.5


    # ==========================================================
    # SCROLLBACK
    # ==========================================================

    scrollback_lines 20000

    wheel_scroll_multiplier 4.0


    # ==========================================================
    # MOUSE
    # ==========================================================

    url_color #ADFF8A

    url_style curly

    open_url_with default


    # ==========================================================
    # AUDIO
    # ==========================================================

    enable_audio_bell no


    # ==========================================================
    # TABS
    # ==========================================================

    tab_bar_style powerline

    tab_powerline_style slanted

    active_tab_foreground #050B05

    active_tab_background #8AFF80

    inactive_tab_foreground #8AFF80

    inactive_tab_background #0B1A0B


    # ==========================================================
    # SHELL INTEGRATION
    # ==========================================================

    shell_integration enabled


    # ==========================================================
    # CRT SHADER
    # ==========================================================

    custom_shaders pipboy-crt
  '';


  # ============================================================
  # CRT PIPELINE
  # ============================================================
  #
  # Usa o shader CRT que já vem no Kitty.
  #
  # O TINT aplica um leve phosphor verde sobre o efeito.
  #

  home.file.".config/kitty/shaders/pipboy-crt.pipeline".text = ''
    startgroup
        var float4 TINT = float4(0.08, 1.0, 0.20, 1.0)
        shaders crt
    endgroup
  '';
}