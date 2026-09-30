{pkgs, ...}: {
  programs = {
    steam.enable =
      true;
    gamescope = {
      enable = true;

      capSysNice = true;
    };
    gamemode = {
      enable = true;

      # Mais conservador para nosso NixOS atual.
      enableRenice = false;
    };
  };

  environment.systemPackages = with pkgs; [
    # Epic / GOG / Amazon.
    (heroic.override {
      extraPkgs = pkgs':
        with pkgs'; [
          gamescope
          gamemode
        ];
    })

    # Gerencia Proton-GE.
    protonup-qt
  ];
}
