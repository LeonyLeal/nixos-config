# Única fonte de cores para DMS, GTK, Kitty, Starship, Zsh e Hyprland.
rec {
  background = "#07080A";
  backgroundText = "#E6E2DE";
  surface = "#0D1014";
  text = "#D8D6D1";
  surfaceVariant = "#171A20";
  secondaryText = "#A9ADB3";
  red = "#C3263E";
  onRed = "#FFF7F8";
  redContainer = "#5A1824";
  blue = "#718DA8";
  outline = "#454A52";
  surfaceContainer = "#101318";
  surfaceContainerHigh = "#171B21";
  surfaceContainerHighest = "#20252C";
  error = "#FF405B";
  amber = "#C89B5B";
  green = "#72F58A";
  violet = "#8A6680";
  cyan = "#6CA7A0";
  brightGreen = "#9AF5A8";
  brightAmber = "#E1B978";
  brightBlue = "#91ABC3";
  brightViolet = "#B58AA8";
  brightCyan = "#8BC7BF";
  muted = "#777C84";
  terminalBackground = "#050706";
  inactiveBorder = "#393D43";
  shadow = "#3B0A12";

  ansi = [
    background
    red
    green
    amber
    blue
    violet
    cyan
    text
    outline
    error
    brightGreen
    brightAmber
    brightBlue
    brightViolet
    brightCyan
    onRed
  ];

  starship = {
    inherit text blue cyan;
    muted = secondaryText;
    accent = red;
    yellow = amber;
    red = error;
    purple = violet;
  };

  dms = {
    name = "Lain // Wired";
    primary = red;
    primaryText = onRed;
    primaryContainer = redContainer;
    secondary = blue;
    inherit
      surface
      surfaceVariant
      background
      backgroundText
      outline
      surfaceContainer
      surfaceContainerHigh
      surfaceContainerHighest
      error
      ;
    surfaceText = text;
    surfaceVariantText = secondaryText;
    surfaceTint = red;
    warning = amber;
    info = green;
    matugen_type = "scheme-neutral";
  };
}
