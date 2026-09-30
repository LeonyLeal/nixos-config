{pkgs, ...}: {
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

        theme =
          pkgs.nixos-grub2-theme;
      };
      timeout =
        5;
    };
  };
}
