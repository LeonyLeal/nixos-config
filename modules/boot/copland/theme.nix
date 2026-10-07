{pkgs}:
pkgs.runCommand "copland-plymouth-theme" {nativeBuildInputs = [pkgs.librsvg];} ''
  themeDir="$out/share/plymouth/themes/copland"
  mkdir -p "$themeDir"
  rsvg-convert ${./logo.svg} -o "$themeDir/logo.png"
  rsvg-convert ${./orb.svg} -o "$themeDir/orb.png"
  rsvg-convert ${./ripple.svg} -o "$themeDir/ripple.png"
  rsvg-convert ${./scanlines.svg} -o "$themeDir/scanlines.png"
  cp ${./copland.script} "$themeDir/copland.script"
  cat > "$themeDir/copland.plymouth" <<EOF
  [Plymouth Theme]
  Name=Copland OS Enterprise
  Description=Navi inspired splash with a single live status line
  ModuleName=script

  [script]
  ImageDir=$themeDir
  ScriptFile=$themeDir/copland.script
  EOF
''
