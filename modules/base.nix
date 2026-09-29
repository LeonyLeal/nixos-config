{ ... }:

{
  # ============================================================
  # NIX
  # ============================================================

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];


  # ============================================================
  # HOST
  # ============================================================

  networking.hostName =
    "nixos";


  # ============================================================
  # TIMEZONE
  # ============================================================

  time.timeZone =
    "America/Sao_Paulo";


  # ============================================================
  # LOCALE
  # ============================================================

  i18n.defaultLocale =
    "pt_BR.UTF-8";


  i18n.extraLocaleSettings = {
    LC_ADDRESS = "pt_BR.UTF-8";
    LC_IDENTIFICATION = "pt_BR.UTF-8";
    LC_MEASUREMENT = "pt_BR.UTF-8";
    LC_MONETARY = "pt_BR.UTF-8";
    LC_NAME = "pt_BR.UTF-8";
    LC_NUMERIC = "pt_BR.UTF-8";
    LC_PAPER = "pt_BR.UTF-8";
    LC_TELEPHONE = "pt_BR.UTF-8";
    LC_TIME = "pt_BR.UTF-8";
  };


  console.keyMap =
    "br-abnt2";


  # ============================================================
  # USER
  # ============================================================

  users.users.z30n = {
    isNormalUser = true;

    description =
      "Z30N";

    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
    ];
  };


  # ============================================================
  # BASE PROGRAMS
  # ============================================================

  programs.firefox.enable =
    true;


  programs.git.enable =
    true;


  # ============================================================
  # VERSION
  # ============================================================

  system.stateVersion =
    "26.05";
}