{pkgs}:
pkgs.runCommand "copland-grub-theme" {nativeBuildInputs = [pkgs.librsvg];} ''
  mkdir -p "$out"
  cp -r ${pkgs.nixos-grub2-theme}/. "$out/"
  chmod -R u+w "$out"
  rsvg-convert ${./grub/background.svg} -o "$out/background.png"
  cp ${./grub/theme.txt} "$out/theme.txt"
''
