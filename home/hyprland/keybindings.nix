{lib}: let
  bind = group: key: description: action: flags: {
    inherit group key description action flags;
  };
in
  [
    (bind "Teclado" "SUPER + SHIFT + SPACE" "Alternar teclado BR / US"
      ''hl.dsp.exec_cmd("hyprctl switchxkblayout all next")'' {})
    (bind "Aplicativos" "SUPER + RETURN" "Abrir terminal"
      ''hl.dsp.exec_cmd("kitty")'' {})
    (bind "Aplicativos" "SUPER + E" "Abrir Thunar"
      ''hl.dsp.exec_cmd("thunar")'' {})
    (bind "Aplicativos" "SUPER + SPACE" "Abrir launcher"
      ''hl.dsp.exec_cmd("dms ipc call spotlight toggle")'' {})
    (bind "Aplicativos" "ALT + SPACE" "Abrir launcher compacto"
      ''hl.dsp.exec_cmd("dms ipc call spotlight-bar toggle")'' {})
    (bind "Janelas" "SUPER + Q" "Fechar janela"
      ''hl.dsp.window.close()'' {})
    (bind "Janelas" "SUPER + F" "Maximizar janela"
      ''hl.dsp.window.fullscreen({ action = "toggle", mode = "maximized" })'' {})
    (bind "Janelas" "SUPER + SHIFT + F" "Tela cheia"
      ''hl.dsp.window.fullscreen({ action = "toggle", mode = "fullscreen" })'' {})
    (bind "Janelas" "SUPER + SHIFT + T" "Alternar janela flutuante"
      ''hl.dsp.window.float({ action = "toggle" })'' {})
    (bind "Janelas" "ALT + TAB" "Próxima janela"
      ''hl.dsp.exec_cmd("hyprctl dispatch cyclenext hist")'' {})
    (bind "Janelas" "ALT + SHIFT + TAB" "Janela anterior"
      ''hl.dsp.exec_cmd("hyprctl dispatch cyclenext 'prev hist'")'' {})
    (bind "Workspaces" "SUPER + LEFT" "Workspace anterior"
      ''hl.dsp.focus({ workspace = "e-1" })'' {})
    (bind "Workspaces" "SUPER + RIGHT" "Próximo workspace"
      ''hl.dsp.focus({ workspace = "e+1" })'' {})
    (bind "Workspaces" "SUPER + SHIFT + LEFT" "Mover para workspace anterior"
      ''hl.dsp.window.move({ workspace = "e-1" })'' {})
    (bind "Workspaces" "SUPER + SHIFT + RIGHT" "Mover para próximo workspace"
      ''hl.dsp.window.move({ workspace = "e+1" })'' {})
    (bind "Workspaces" "SUPER + TAB" "Overview"
      ''hl.dsp.exec_cmd("dms ipc call hypr toggleOverview")'' {})
    (bind "Foco" "SUPER + H" "Foco esquerda"
      ''hl.dsp.focus({ direction = "l" })'' {})
    (bind "Foco" "SUPER + J" "Foco baixo"
      ''hl.dsp.focus({ direction = "d" })'' {})
    (bind "Foco" "SUPER + K" "Foco cima"
      ''hl.dsp.focus({ direction = "u" })'' {})
    (bind "Foco" "SUPER + L" "Foco direita"
      ''hl.dsp.focus({ direction = "r" })'' {})
    (bind "Redimensionamento" "SUPER + CTRL + H" "Diminuir largura"
      ''hl.dsp.window.resize({ relative = true, x = -80, y = 0 })'' {repeating = true;})
    (bind "Redimensionamento" "SUPER + CTRL + L" "Aumentar largura"
      ''hl.dsp.window.resize({ relative = true, x = 80, y = 0 })'' {repeating = true;})
    (bind "Redimensionamento" "SUPER + CTRL + K" "Diminuir altura"
      ''hl.dsp.window.resize({ relative = true, x = 0, y = -80 })'' {repeating = true;})
    (bind "Redimensionamento" "SUPER + CTRL + J" "Aumentar altura"
      ''hl.dsp.window.resize({ relative = true, x = 0, y = 80 })'' {repeating = true;})
    (bind "Mouse" "SUPER + mouse:272" "Mover janela"
      ''hl.dsp.window.drag()'' {mouse = true;})
    (bind "Mouse" "SUPER + mouse:273" "Redimensionar janela"
      ''hl.dsp.window.resize()'' {mouse = true;})
    (bind "DMS" "SUPER + COMMA" "Configurações DMS"
      ''hl.dsp.exec_cmd("dms ipc call settings focusOrToggle")'' {})
    (bind "DMS" "SUPER + N" "Notificações"
      ''hl.dsp.exec_cmd("dms ipc call notifications toggle")'' {})
    (bind "DMS" "SUPER + SHIFT + N" "Bloco de notas"
      ''hl.dsp.exec_cmd("dms ipc call notepad toggle")'' {})
    (bind "DMS" "SUPER + V" "Clipboard"
      ''hl.dsp.exec_cmd("dms ipc call clipboard toggle")'' {})
    (bind "DMS" "SUPER + M" "Processos"
      ''hl.dsp.exec_cmd("dms ipc call processlist focusOrToggle")'' {})
    (bind "DMS" "CTRL + ALT + Delete" "Processos"
      ''hl.dsp.exec_cmd("dms ipc call processlist focusOrToggle")'' {})
    (bind "DMS" "SUPER + X" "Menu de energia"
      ''hl.dsp.exec_cmd("dms ipc call powermenu toggle")'' {})
    (bind "DMS" "SUPER + ALT + L" "Bloquear sessão"
      ''hl.dsp.exec_cmd("dms ipc call lock lock")'' {})
    (bind "DMS" "SUPER + Y" "Wallpapers"
      ''hl.dsp.exec_cmd("dms ipc call dash toggle wallpaper")'' {})
    (bind "DMS" "SUPER + SHIFT + Slash" "Mostrar atalhos"
      ''hl.dsp.exec_cmd("dms ipc call keybinds toggle z30n")'' {})
    (bind "Capturas de tela" "Print" "Capturar região"
      ''hl.dsp.exec_cmd("dms screenshot")'' {})
    (bind "Capturas de tela" "SUPER + SHIFT + S" "Capturar região"
      ''hl.dsp.exec_cmd("dms screenshot")'' {})
    (bind "Capturas de tela" "CTRL + Print" "Capturar tela inteira"
      ''hl.dsp.exec_cmd("dms screenshot full")'' {})
    (bind "Capturas de tela" "ALT + Print" "Capturar janela"
      ''hl.dsp.exec_cmd("dms screenshot window")'' {})
    (bind "Sistema" "SUPER + P" "Trocar perfil de monitor"
      ''hl.dsp.exec_cmd("dms ipc call outputs cycleProfile")'' {})
    (bind "Sistema" "SUPER + SHIFT + P" "Liga/desliga monitores"
      ''hl.dsp.dpms({ action = "toggle" })'' {})
    (bind "Sistema" "SUPER + SHIFT + E" "Sair do Hyprland"
      ''hl.dsp.exit()'' {})
    (bind "Áudio e mídia" "XF86AudioRaiseVolume" "Aumentar volume"
      ''hl.dsp.exec_cmd("dms ipc call audio increment 3")'' {
        locked = true;
        repeating = true;
      })
    (bind "Áudio e mídia" "XF86AudioLowerVolume" "Diminuir volume"
      ''hl.dsp.exec_cmd("dms ipc call audio decrement 3")'' {
        locked = true;
        repeating = true;
      })
    (bind "Áudio e mídia" "XF86AudioMute" "Silenciar áudio"
      ''hl.dsp.exec_cmd("dms ipc call audio mute")'' {locked = true;})
    (bind "Áudio e mídia" "XF86AudioNext" "Próxima música"
      ''hl.dsp.exec_cmd("dms ipc call mpris next")'' {locked = true;})
    (bind "Áudio e mídia" "XF86AudioPlay" "Play/Pause"
      ''hl.dsp.exec_cmd("dms ipc call mpris playPause")'' {locked = true;})
    (bind "Áudio e mídia" "XF86AudioPause" "Play/Pause"
      ''hl.dsp.exec_cmd("dms ipc call mpris playPause")'' {locked = true;})
    (bind "Áudio e mídia" "XF86AudioPrev" "Música anterior"
      ''hl.dsp.exec_cmd("dms ipc call mpris previous")'' {locked = true;})
    (bind "Brilho" "XF86MonBrightnessUp" "Aumentar brilho"
      ''hl.dsp.exec_cmd("dms ipc call brightness increment 5")'' {
        locked = true;
        repeating = true;
      })
    (bind "Brilho" "XF86MonBrightnessDown" "Diminuir brilho"
      ''hl.dsp.exec_cmd("dms ipc call brightness decrement 5")'' {
        locked = true;
        repeating = true;
      })
  ]
  ++ lib.concatMap (workspace: let
    key = toString (lib.mod workspace 10);
    number = toString workspace;
  in [
    (bind "Workspaces" "SUPER + ${key}" "Workspace ${number}"
      ''hl.dsp.focus({ workspace = ${number} })'' {})
    (bind "Workspaces" "SUPER + SHIFT + ${key}" "Mover janela para workspace ${number}"
      ''hl.dsp.window.move({ workspace = ${number} })'' {})
  ]) (lib.range 1 10)
