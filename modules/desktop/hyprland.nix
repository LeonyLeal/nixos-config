{pkgs, ...}: {
  programs.hyprland = {
    enable = true;
    withUWSM = true;
    xwayland.enable = true;
  };
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # O UWSM usa hyprland- como prefixo; forneça o menu XDG correspondente.
  environment.etc."xdg/menus/hyprland-applications.menu".source = "${pkgs.garcon}/etc/xdg/menus/xfce-applications.menu";
}
