{lib, ...}: let
  colors = import ./palette.nix;
in {
  programs.zsh = {
    autosuggestion.highlight = "fg=${colors.muted}";
    syntaxHighlighting.styles = {
      command = "fg=${colors.text}";
      builtin = "fg=${colors.text}";
      function = "fg=${colors.text}";
      alias = "fg=${colors.text}";
      suffix-alias = "fg=${colors.text}";
      global-alias = "fg=${colors.text}";
      precommand = "fg=${colors.blue}";
      arg0 = "fg=${colors.text}";
      unknown-token = "fg=${colors.error}";
    };
    initContent = lib.mkAfter ''
      zstyle ':completion:*:descriptions' \
        format '%F{${colors.blue}}-- %d --%f'
    '';
  };
  programs.starship.settings = {
    palette = "copland";
    palettes.copland = colors.starship;
    os.style = "bold accent";
    directory.style = "bold text";
    git_branch.style = "bold blue";
    git_status.style = "bold yellow";
    dotnet.style = "bold purple";
    nodejs.style = "bold text";
    python.style = "bold yellow";
    java.style = "bold red";
    docker_context.style = "bold blue";
    cmd_duration.format = " [$duration](muted)";
    character = {
      success_symbol = "[❯](bold accent)";
      error_symbol = "[❯](bold red)";
      vimcmd_symbol = "[❮](bold text)";
    };
  };
}
