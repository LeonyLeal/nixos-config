{...}: {
  imports = [
    ./home/shell
    ./home/tools.nix
    ./home/terminal/kitty.nix
    ./home/desktop
    ./home/themes/lain
    ./home/ssh.nix
    ./home/hyprland
  ];

  home = {
    username = "z30n";
    homeDirectory = "/home/z30n";
    stateVersion = "26.05";
  };

  programs.home-manager.enable =
    true;
}
