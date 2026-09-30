{pkgs, ...}: {
  # ============================================================
  # KEYRING
  # ============================================================

  services.gnome.gnome-keyring.enable =
    true;

  security.pam.services.greetd.enableGnomeKeyring =
    true;

  # ============================================================
  # SOPS-NIX / AGE
  # ============================================================

  sops.age = {
    keyFile = "/var/lib/sops-nix/key.txt";

    generateKey =
      true;
  };

  # ============================================================
  # SECURITY TOOLS
  # ============================================================

  environment.systemPackages = with pkgs; [
    age

    sops

    ssh-to-age
  ];
}
