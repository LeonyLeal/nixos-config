{...}: {
  imports = [
    ./hardware-configuration.nix

    ./modules/base.nix
    ./modules/boot.nix
    ./modules/hardware/nvidia.nix
    ./modules/desktop
    ./modules/development.nix
    ./modules/gaming.nix
    ./modules/networking.nix
    ./modules/security.nix
    ./modules/maintenance.nix
    ./modules/hardware/memory.nix
  ];
}
