# Cores extraídas de allacritty.toml e Waybar.style.css.
# As aplicações consomem esta paleta, sem depender dos programas de referência.
rec {
  background = "#1F1F28";
  text = "#DCD7BA";
  surface = "#16161D";
  surfaceVariant = "#2A2A37";
  secondaryText = "#C8C093";
  blue = "#7E9CD8";
  selection = "#2D4F67";
  lilac = "#938AA9";
  red = "#C34043";
  green = "#76946A";
  orange = "#FFA066";
  amber = "#E6C384";
  violet = "#957FB8";
  cyan = "#6A9589";
  muted = "#727169";
  error = "#FF5D62";
  outline = "#54546D";

  ansi = [
    "#090618"
    red
    green
    orange
    blue
    violet
    cyan
    secondaryText
    muted
    "#E82424"
    "#98BB6C"
    amber
    "#7FB4CA"
    "#938AA9"
    "#7AA89F"
    text
  ];

  starship = {
    inherit text blue cyan;
    muted = lilac;
    accent = blue;
    yellow = amber;
    red = error;
    purple = violet;
  };

  dms = {
    name = "CoplandOS";
    primary = blue;
    primaryText = surface;
    primaryContainer = selection;
    secondary = lilac;
    inherit surface surfaceVariant background outline error;
    backgroundText = text;
    surfaceText = text;
    surfaceVariantText = secondaryText;
    surfaceTint = blue;
    surfaceContainer = surface;
    surfaceContainerHigh = surfaceVariant;
    surfaceContainerHighest = "#363646";
    warning = amber;
    info = "#7FB4CA";
    matugen_type = "scheme-neutral";
  };
}
