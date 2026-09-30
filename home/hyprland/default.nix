{lib, ...}: let
  bindings = import ./keybindings.nix {inherit lib;};
  render = binding: let
    options = {inherit (binding) description;} // binding.flags;
    fields = lib.mapAttrsToList (name: value: "${name} = ${builtins.toJSON value}") options;
  in ''
    hl.bind(${builtins.toJSON binding.key}, ${binding.action}, { ${lib.concatStringsSep ", " fields} })
  '';
in {
  xdg.configFile."hypr/hyprland.lua".text =
    builtins.readFile ./hyprland.lua + "\n" + lib.concatMapStringsSep "\n" render bindings;
}
