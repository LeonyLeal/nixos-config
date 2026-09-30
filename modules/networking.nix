{pkgs, ...}: {
  networking.networkmanager = {
    enable = true;

    plugins = [
      pkgs.networkmanager-openconnect
    ];
  };

  programs.globalprotect-openconnect.enable =
    true;

  environment.systemPackages = with pkgs; [
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
