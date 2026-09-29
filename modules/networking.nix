{ pkgs, ... }:

{
  # ============================================================
  # NETWORK MANAGER
  # ============================================================

  networking.networkmanager = {
    enable = true;


    plugins = [
      pkgs.networkmanager-openconnect
    ];
  };


  # ============================================================
  # GLOBALPROTECT
  # ============================================================

  programs.globalprotect-openconnect.enable =
    true;


  # ============================================================
  # NETWORK / DIAGNOSTIC TOOLS
  # ============================================================

  environment.systemPackages = with pkgs; [

    # VPN

    wireguard-tools

    openconnect

    networkmanager-openconnect


    # Diagnostics

    tcpdump

    nmap

    mtr

    iperf3

    bind

    socat

    netcat-openbsd

    whois

    ethtool

    traceroute


    # Hardware

    pciutils

    usbutils


    # Existing tools

    thc-hydra

    unixtools.arp
  ];
}