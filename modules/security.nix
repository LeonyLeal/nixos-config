{pkgs, ...}: {
  services.gnome.gnome-keyring.enable =
    true;

  security.pam.services.greetd.enableGnomeKeyring =
    true;

  sops.age = {
    keyFile = "/var/lib/sops-nix/key.txt";

    generateKey =
      true;
  };

  environment.systemPackages = with pkgs; [
    age

    sops

    ssh-to-age
  ];
}
