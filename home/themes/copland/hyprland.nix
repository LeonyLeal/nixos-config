{lib, ...}: let
  colors = import ./palette.nix;
  rgb = color: lib.toLower (lib.removePrefix "#" color);
in {
  xdg.configFile."hypr/hyprland.lua".text = lib.mkAfter ''
    hl.config({
      general = {
        col = {
          active_border = {
            colors = { "rgba(${rgb colors.blue}ff)", "rgba(${rgb colors.lilac}ff)" },
            angle = 45,
          },
          inactive_border = "rgba(${rgb colors.outline}aa)",
        },
      },
      decoration = {
        rounding = 12,
        shadow = { color = "rgba(${rgb colors.surface}66)" },
      },
    })
  '';
}
