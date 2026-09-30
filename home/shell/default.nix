{lib, ...}: let
  nvmInit = ''
    export NVM_DIR="$HOME/.nvm"

    if [ -s "$NVM_DIR/nvm.sh" ]; then
      . "$NVM_DIR/nvm.sh"
    fi

    if [ -s "$NVM_DIR/bash_completion" ]; then
      . "$NVM_DIR/bash_completion"
    fi

    # .NET GLOBAL TOOLS

    export PATH="$HOME/.dotnet/tools:$PATH"
  '';
in {
  imports = [./starship.nix];

  home.sessionPath = [
    "$HOME/.local/bin"

    "$HOME/.dotnet/tools"
  ];

  home.shellAliases = {
    # Files

    ll = "eza -lah --group-directories-first --icons=auto";

    la = "eza -la --group-directories-first --icons=auto";

    tree = "eza --tree --icons=auto";

    cat = "bat --paging=never";

    # Git

    gs = "git status";

    ga = "git add";

    gc = "git commit";

    gp = "git push";

    gl = "git log --oneline --graph --decorate";

    lg = "lazygit";

    # Docker

    dc = "docker compose";

    dps = "docker ps";

    dcu = "docker compose up -d";

    dcd = "docker compose down";

    lzd = "lazydocker";

    # .NET

    dotnets = "dotnet --list-sdks";

    # Python

    py = "python";

    venv = "python -m venv .venv";

    # NixOS

    nrs = "nh os switch";

    nrb = "nh os build";

    nrt = "nh os test";

    # Nix lint

    nixfmtall = "alejandra /etc/nixos";

    nixlint = "statix check /etc/nixos && deadnix /etc/nixos";

    # Journal

    jerr = "journalctl -p err -b";

    jboot = "journalctl -b";

    jfollow = "journalctl -f";

    # Restic

    backup-now = "sudo systemctl start restic-backups-nixos.service";

    backup-status = "systemctl status restic-backups-nixos.service --no-pager";
  };

  programs = {
    # Continua disponível para scripts e compatibilidade.
    bash = {
      enable =
        true;

      enableCompletion =
        true;

      initExtra =
        nvmInit;
    };
    zsh = {
      enable =
        true;

      enableCompletion =
        true;

      autocd =
        true;

      defaultKeymap = "emacs";

      autosuggestion = {
        enable =
          true;

        strategy = [
          "history"
          "completion"
        ];
      };

      syntaxHighlighting = {
        enable =
          true;

        highlighters = [
          "main"
          "brackets"
        ];
      };

      history = {
        size =
          100000;

        save =
          100000;

        share =
          true;

        append =
          true;

        extended =
          true;

        ignoreDups =
          true;

        ignoreAllDups =
          true;

        expireDuplicatesFirst =
          true;

        findNoDups =
          true;

        saveNoDups =
          true;
      };

      historySubstringSearch = {
        enable =
          true;

        searchUpKey = "^[[A";

        searchDownKey = "^[[B";
      };

      initContent = lib.mkOrder 1000 ''
        ${nvmInit}

        zstyle ':completion:*' menu select

        zstyle ':completion:*' group-name ""

        zstyle ':completion:*' verbose yes

        zstyle ':completion:*' matcher-list \
          'm:{a-zA-Z}={A-Za-z}' \
          'r:|[._-]=* r:|=*'

        bindkey '^[[1;5C' forward-word

        bindkey '^[[1;5D' backward-word

        # Ctrl + Delete

        bindkey '^[[3;5~' kill-word

        # Ctrl + Backspace

        bindkey '^H' backward-kill-word
      '';
    };
    direnv = {
      enable =
        true;

      enableBashIntegration =
        true;

      enableZshIntegration =
        true;

      nix-direnv.enable =
        true;
    };
  };
}
