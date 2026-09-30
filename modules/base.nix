{pkgs, ...}: {
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  networking.hostName = "nixos";

  time.timeZone = "America/Sao_Paulo";

  i18n.defaultLocale = "pt_BR.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "pt_BR.UTF-8";
    LC_IDENTIFICATION = "pt_BR.UTF-8";
    LC_MEASUREMENT = "pt_BR.UTF-8";
    LC_MONETARY = "pt_BR.UTF-8";
    LC_NAME = "pt_BR.UTF-8";
    LC_NUMERIC = "pt_BR.UTF-8";
    LC_PAPER = "pt_BR.UTF-8";
    LC_TELEPHONE = "pt_BR.UTF-8";
    LC_TIME = "pt_BR.UTF-8";
  };

  console.keyMap = "br-abnt2";

  programs = {
    zsh.enable =
      true;
    firefox.enable =
      true;
    git.enable =
      true;
  };

  # Permite completion de programas do sistema.
  environment.pathsToLink = [
    "/share/zsh"
  ];

  users.users.z30n = {
    isNormalUser =
      true;

    description = "Z30N";

    shell =
      pkgs.zsh;

    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
    ];
  };

  system.stateVersion = "26.05";
}
