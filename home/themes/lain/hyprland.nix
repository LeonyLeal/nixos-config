{lib, ...}: let
  colors = import ./palette.nix;
  rgb = color: lib.toLower (lib.removePrefix "#" color);
in {
  xdg.configFile."hypr/hyprland.lua".text = lib.mkAfter ''
    hl.config({
      general = {
        col = {
          active_border = "rgba(${rgb colors.red}ff)",
          inactive_border = "rgba(${rgb colors.inactiveBorder}aa)",
        },
      },
      decoration = { shadow = { color = "rgba(${rgb colors.shadow}4d)" } },
    })
  '';
}
