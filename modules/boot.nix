{pkgs, ...}: let
  coplandGrubTheme = import ./boot/copland/grub-theme.nix {inherit pkgs;};
in {
  imports = [./boot/copland];

  boot = {
    loader = {
      systemd-boot.enable =
        false;
      efi.canTouchEfiVariables =
        true;
      grub = {
        enable = true;

        efiSupport = true;

        device = "nodev";

        useOSProber =
          true;

        configurationLimit =
          10;

        theme = coplandGrubTheme;
        splashImage = "${coplandGrubTheme}/background.png";
      };
      timeout =
        5;
    };
  };
}
