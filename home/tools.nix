{ ... }:

{
  # ============================================================
  # STARSHIP
  # ============================================================

  programs.starship = {
    enable = true;

    enableBashIntegration = true;
  };


  # ============================================================
  # FZF
  # ============================================================

  programs.fzf = {
    enable = true;

    enableBashIntegration = true;
  };


  # ============================================================
  # ZOXIDE
  # ============================================================

  programs.zoxide = {
    enable = true;

    enableBashIntegration = true;
  };


  # ============================================================
  # BAT
  # ============================================================

  programs.bat.enable =
    true;


  # ============================================================
  # EZA
  # ============================================================

  programs.eza.enable =
    true;


  # ============================================================
  # LAZYGIT
  # ============================================================

  programs.lazygit.enable =
    true;


  # ============================================================
  # NIX INDEX
  # ============================================================

  programs.command-not-found.enable =
    false;


  programs.nix-index = {
    enable = true;

    enableBashIntegration = true;
  };


  programs.nix-index-database.comma.enable =
    true;


  # ============================================================
  # MANGOHUD
  # ============================================================

  programs.mangohud = {
    enable = true;


    settings = {
      fps =
        true;

      frametime =
        true;

      frame_timing =
        true;


      cpu_stats =
        true;

      cpu_temp =
        true;


      gpu_stats =
        true;

      gpu_temp =
        true;


      ram =
        true;

      vram =
        true;


      position =
        "top-right";


      toggle_hud =
        "Shift_R+F12";
    };
  };
}