{...}: {
  imports = [
    ./home/shell.nix

    ./home/tools.nix

    ./home/terminal.nix

    ./home/appearance.nix

    ./home/desktop.nix

    ./home/ssh.nix

    ./home/dms.nix

    ./home/hyprland.nix
  ];

  # ============================================================
  # HOME MANAGER
  # ============================================================

  home.username = "z30n";

  home.homeDirectory = "/home/z30n";

  home.stateVersion = "26.05";

  programs.home-manager.enable =
    true;
}
