{pkgs, ...}: {
  # ============================================================
  # NH
  # ============================================================

  programs.nh = {
    enable = true;

    # Permite:
    #
    # nh os switch
    # nh os build
    # nh os test

    flake = "/etc/nixos";

    # ----------------------------------------------------------
    # AUTOMATIC CLEANUP
    # ----------------------------------------------------------

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

  # ============================================================
  # STORE OPTIMISATION
  # ============================================================

  nix.optimise = {
    automatic = true;

    dates = [
      "weekly"
    ];
  };

  # ============================================================
  # JOURNALD
  # ============================================================

  services.journald.extraConfig = ''
    SystemMaxUse=1G
    RuntimeMaxUse=256M
    MaxRetentionSec=1month
  '';

  # ============================================================
  # SMART
  # ============================================================

  services.smartd.enable =
    true;

  # ============================================================
  # RESTIC
  # ============================================================
  #
  # Backup LOCAL apenas do /etc/nixos.
  #
  # Isso protege contra:
  #
  # - alteração errada
  # - exclusão acidental
  # - corrupção lógica da configuração
  #
  # NÃO protege contra falha física do SSD.
  #

  services.restic.backups.nixos = {
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

  # ============================================================
  # SYSTEM TOOLS
  # ============================================================

  environment.systemPackages = with pkgs; [
    # ----------------------------------------------------------
    # NIX DEVELOPMENT
    # ----------------------------------------------------------

    alejandra

    statix

    deadnix

    # ----------------------------------------------------------
    # DOCKER
    # ----------------------------------------------------------

    lazydocker

    dive

    ctop

    # ----------------------------------------------------------
    # MONITORING
    # ----------------------------------------------------------

    btop

    nvtopPackages.nvidia

    iotop

    lsof

    strace

    sysstat

    lnav

    duf

    # ----------------------------------------------------------
    # HARDWARE
    # ----------------------------------------------------------

    smartmontools

    lm_sensors

    # ----------------------------------------------------------
    # BACKUP
    # ----------------------------------------------------------

    restic
  ];
}
