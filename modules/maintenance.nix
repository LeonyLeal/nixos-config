{pkgs, ...}: {
  programs.nh = {
    enable = true;

    # Permite:
    #
    # nh os switch
    # nh os build
    # nh os test

    flake = "/etc/nixos";

    clean = {
      enable = true;

      dates = "weekly";

      # Mantém:
      #
      # - pelo menos 5 gerações
      # - gerações com menos de 30 dias

      extraArgs = "--keep 5 --keep-since 30d";
    };
  };

  nix.optimise = {
    automatic = true;

    dates = [
      "weekly"
    ];
  };

  services = {
    journald.extraConfig = ''
      SystemMaxUse=1G
      RuntimeMaxUse=256M
      MaxRetentionSec=1month
    '';
    smartd.enable =
      true;
    # Backup local da configuração; não protege contra falha física do SSD.
    restic.backups.nixos = {
      initialize =
        true;

      repository = "/var/lib/restic/nixos";

      passwordFile = "/var/lib/restic/nixos-password";

      paths = [
        "/etc/nixos"
      ];

      backupPrepareCommand = ''
        install -d -m 0700 /var/lib/restic

        if [ ! -s /var/lib/restic/nixos-password ]; then
          umask 077

          ${pkgs.openssl}/bin/openssl rand -base64 48 \
            > /var/lib/restic/nixos-password
        fi

        chmod 0600 /var/lib/restic/nixos-password
      '';

      timerConfig = {
        OnCalendar = "daily";

        Persistent =
          true;

        RandomizedDelaySec = "30m";
      };

      pruneOpts = [
        "--keep-daily 7"
        "--keep-weekly 5"
        "--keep-monthly 6"
      ];
    };
  };

  environment.systemPackages = with pkgs; [
    alejandra

    statix

    deadnix

    lazydocker

    dive

    ctop

    btop

    nvtopPackages.nvidia

    iotop

    lsof

    strace

    sysstat

    lnav

    duf

    smartmontools

    lm_sensors

    restic
  ];
}
