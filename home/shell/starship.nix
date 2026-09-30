{lib, ...}: {
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

      format = lib.concatStrings [
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

      os = {
        disabled =
          false;
      };

      directory = {
        truncation_length =
          4;

        truncate_to_repo =
          false;

        read_only = " 󰌾";
      };

      git_branch = {
        symbol = " ";
      };

      # .NET

      dotnet = {
        symbol = "󰪮 ";
      };

      nodejs = {
        symbol = " ";
      };

      python = {
        symbol = " ";
      };

      java = {
        symbol = " ";
      };

      docker_context = {
        symbol = " ";
      };

      cmd_duration = {
        min_time =
          1500;
      };
    };
  };
}
