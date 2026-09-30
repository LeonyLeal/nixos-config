{pkgs, ...}: {
  home.packages = with pkgs; [
    spotify
    obsidian
    file-roller
    syncthing
    vlc
    discord
    stremio-linux-shell
    qbittorrent
    qutebrowser
    cmatrix
    pavucontrol
    loupe
    papers
    gnome-disk-utility
    qalculate-gtk
  ];
}
