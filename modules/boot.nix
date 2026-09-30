{pkgs, ...}: {
  # ============================================================
  # GRUB / UEFI
  # ============================================================

  boot.loader.systemd-boot.enable =
    false;

  boot.loader.efi.canTouchEfiVariables =
    true;

  boot.loader.grub = {
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

  boot.loader.timeout =
    5;
}
