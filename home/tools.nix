{ lib, pkgs, ... }:

{
  # ============================================================
  # STARSHIP
  # ============================================================

  programs.starship = {
    enable =
      true;


    enableBashIntegration =
      true;


    enableZshIntegration =
      true;


    presets = [
      "nerd-font-symbols"
    ];


    settings = {
      add_newline =
        true;


      palette =
        "pipboy";


      palettes.pipboy = {
        green =
          "#7CFF7C";

        light_green =
          "#B7FF96";

        dark_green =
          "#3F6F3F";

        yellow =
          "#E8FF6A";

        red =
          "#FF6B6B";

        blue =
          "#63B8FF";

        cyan =
          "#57FFF1";

        purple =
          "#C792EA";
      };


      format =
        lib.concatStrings [
          "$os"
          "$username"
          "$hostname"
          "$directory"
          "$git_branch"
          "$git_status"
          "$dotnet"
          "$nodejs"
          "$python"
          "$java"
          "$docker_context"
          "$cmd_duration"
          "$line_break"
          "$character"
        ];


      # --------------------------------------------------------
      # OS
      # --------------------------------------------------------

      os = {
        disabled =
          false;

        style =
          "bold green";
      };


      # --------------------------------------------------------
      # DIRECTORY
      # --------------------------------------------------------

      directory = {
        style =
          "bold green";

        truncation_length =
          4;

        truncate_to_repo =
          false;

        read_only =
          " 󰌾";
      };


      # --------------------------------------------------------
      # GIT
      # --------------------------------------------------------

      git_branch = {
        symbol =
          " ";

        style =
          "bold light_green";
      };


      git_status = {
        style =
          "bold yellow";
      };


      # --------------------------------------------------------
      # .NET
      # --------------------------------------------------------

      dotnet = {
        symbol =
          "󰪮 ";

        style =
          "bold purple";
      };


      # --------------------------------------------------------
      # NODE
      # --------------------------------------------------------

      nodejs = {
        symbol =
          " ";

        style =
          "bold green";
      };


      # --------------------------------------------------------
      # PYTHON
      # --------------------------------------------------------

      python = {
        symbol =
          " ";

        style =
          "bold yellow";
      };


      # --------------------------------------------------------
      # JAVA
      # --------------------------------------------------------

      java = {
        symbol =
          " ";

        style =
          "bold red";
      };


      # --------------------------------------------------------
      # DOCKER
      # --------------------------------------------------------

      docker_context = {
        symbol =
          " ";

        style =
          "bold blue";
      };


      # --------------------------------------------------------
      # COMMAND DURATION
      # --------------------------------------------------------

      cmd_duration = {
        min_time =
          1500;

        format =
          " [$duration](bold dark_green)";
      };


      # --------------------------------------------------------
      # PROMPT
      # --------------------------------------------------------

      character = {
        success_symbol =
          "[❯](bold green)";

        error_symbol =
          "[❯](bold red)";
      };
    };
  };


  # ============================================================
  # FZF
  # ============================================================

  programs.fzf = {
    enable =
      true;

    enableBashIntegration =
      true;

    enableZshIntegration =
      true;
  };


  # ============================================================
  # ZOXIDE
  # ============================================================

  programs.zoxide = {
    enable =
      true;

    enableBashIntegration =
      true;

    enableZshIntegration =
      true;
  };


  # ============================================================
  # BAT
  # ============================================================

  programs.bat.enable =
    true;


  # ============================================================
  # EZA
  # ============================================================

  programs.eza = {
    enable =
      true;

    enableBashIntegration =
      true;

    enableZshIntegration =
      true;

    icons =
      "auto";

    git =
      true;
  };


  # ============================================================
  # LAZYGIT
  # ============================================================

  programs.lazygit.enable =
    true;


  # ============================================================
  # CARAPACE
  # ============================================================
  #
  # Completion inteligente para CLIs.
  #

  programs.carapace = {
    enable =
      true;

    enableBashIntegration =
      true;

    enableZshIntegration =
      true;
  };


  # ============================================================
  # NAVI
  # ============================================================
  #
  # Cheatsheets interativas no terminal.
  #

  programs.navi = {
    enable =
      true;

    enableBashIntegration =
      true;

    enableZshIntegration =
      true;
  };


  # ============================================================
  # NIX INDEX
  # ============================================================

  programs.command-not-found.enable =
    false;


  programs.nix-index = {
    enable =
      true;

    enableBashIntegration =
      true;

    enableZshIntegration =
      true;
  };


  programs.nix-index-database.comma.enable =
    true;


  # ============================================================
  # MANGOHUD
  # ============================================================

  programs.mangohud = {
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


      position =
        "top-right";


      toggle_hud =
        "Shift_R+F12";
    };
  };


  # ============================================================
  # EXTRA TERMINAL TOOLS
  # ============================================================

  home.packages = with pkgs; [
    fastfetch

    glow
  ];
}