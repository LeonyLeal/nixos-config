{...}: {
  imports = [
    ./hardware-configuration.nix

    ./modules/base.nix
    ./modules/boot.nix
    ./modules/desktop.nix
    ./modules/desktop-extras.nix
    ./modules/development.nix
    ./modules/gaming.nix
    ./modules/networking.nix
    ./modules/security.nix
    ./modules/maintenance.nix
    ./modules/memory.nix
  ];
}
