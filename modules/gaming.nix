{pkgs, ...}: {
  # ============================================================
  # STEAM
  # ============================================================

  programs.steam.enable =
    true;

  # ============================================================
  # GAMESCOPE
  # ============================================================

  programs.gamescope = {
    enable = true;

    capSysNice = true;
  };

  # ============================================================
  # GAMEMODE
  # ============================================================

  programs.gamemode = {
    enable = true;

    # Mais conservador para nosso NixOS atual.
    enableRenice = false;
  };

  # ============================================================
  # GAMING PACKAGES
  # ============================================================

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
