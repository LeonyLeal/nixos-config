{pkgs, ...}: {
  programs = {
    fzf = {
      enable =
        true;

      enableBashIntegration =
        true;

      enableZshIntegration =
        true;
    };
    zoxide = {
      enable =
        true;

      enableBashIntegration =
        true;

      enableZshIntegration =
        true;
    };
    bat.enable =
      true;
    eza = {
      enable =
        true;

      enableBashIntegration =
        true;

      enableZshIntegration =
        true;

      icons = "auto";

      git =
        true;
    };
    lazygit.enable =
      true;
    carapace = {
      enable =
        true;

      enableBashIntegration =
        true;

      enableZshIntegration =
        true;
    };
    navi = {
      enable =
        true;

      enableBashIntegration =
        true;

      enableZshIntegration =
        true;
    };
    command-not-found.enable =
      false;
    nix-index = {
      enable =
        true;

      enableBashIntegration =
        true;

      enableZshIntegration =
        true;
    };
    nix-index-database.comma.enable =
      true;
    mangohud = {
      enable =
        true;

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

        position = "top-right";

        toggle_hud = "Shift_R+F12";
      };
    };
  };

  #
  # Completion inteligente para CLIs.
  #

  #
  # Cheatsheets interativas no terminal.
  #

  home.packages = with pkgs; [
    fastfetch

    glow
  ];
}
