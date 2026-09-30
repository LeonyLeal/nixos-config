{...}: {
  programs.ssh = {
    enable = true;

    # Evita defaults implícitos do HM.
    enableDefaultConfig =
      false;

    settings."*" = {
      # --------------------------------------------------------
      # SECURITY
      # --------------------------------------------------------

      ForwardAgent =
        false;

      AddKeysToAgent = "yes";

      HashKnownHosts =
        true;

      UserKnownHostsFile = "~/.ssh/known_hosts";

      # --------------------------------------------------------
      # CONNECTION
      # --------------------------------------------------------

      Compression =
        true;

      ServerAliveInterval =
        60;

      ServerAliveCountMax =
        3;

      # --------------------------------------------------------
      # CONNECTION REUSE
      # --------------------------------------------------------

      ControlMaster = "auto";

      ControlPath = "~/.ssh/master-%C";

      ControlPersist = "10m";
    };
  };
}
