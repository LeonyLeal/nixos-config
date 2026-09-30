_: {
  programs.ssh = {
    enable = true;

    # Evita defaults implícitos do HM.
    enableDefaultConfig =
      false;

    settings."*" = {
      ForwardAgent =
        false;

      AddKeysToAgent = "yes";

      HashKnownHosts =
        true;

      UserKnownHostsFile = "~/.ssh/known_hosts";

      Compression =
        true;

      ServerAliveInterval =
        60;

      ServerAliveCountMax =
        3;

      ControlMaster = "auto";

      ControlPath = "~/.ssh/master-%C";

      ControlPersist = "10m";
    };
  };
}
