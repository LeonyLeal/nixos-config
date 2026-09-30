{ ... }:

{
  # ============================================================
  # DMS - ÍNDICE DE ATALHOS
  # ============================================================

  home.file.".config/hypr/dms/binds.conf".text = ''
    # Aplicativos

    bindd = SUPER, RETURN, Abrir terminal, exec, kitty
    bindd = SUPER, E, Abrir Thunar, exec, thunar
    bindd = SUPER, SPACE, Abrir launcher DMS, exec, dms ipc call spotlight toggle
    bindd = ALT, SPACE, Abrir launcher compacto, exec, dms ipc call spotlight-bar toggle


    # Teclado

    bindd = SUPER SHIFT, SPACE, Alternar teclado BR / US, exec, hyprctl switchxkblayout all next


    # Janelas

    bindd = SUPER, Q, Fechar janela, killactive
    bindd = SUPER, F, Maximizar janela, fullscreen, 1
    bindd = SUPER SHIFT, F, Tela cheia, fullscreen, 0
    bindd = SUPER SHIFT, T, Alternar janela flutuante, togglefloating

    bindd = ALT, TAB, Próxima janela, cyclenext, hist
    bindd = ALT SHIFT, TAB, Janela anterior, cyclenext, prev hist


    # Workspaces

    bindd = SUPER, left, Workspace anterior, workspace, e-1
    bindd = SUPER, right, Próximo workspace, workspace, e+1

    bindd = SUPER SHIFT, left, Mover janela para workspace anterior, movetoworkspace, e-1
    bindd = SUPER SHIFT, right, Mover janela para próximo workspace, movetoworkspace, e+1

    bindd = SUPER, TAB, Overview de workspaces, exec, dms ipc call hypr toggleOverview


    # Foco entre janelas

    bindd = SUPER, H, Foco esquerda, movefocus, l
    bindd = SUPER, J, Foco baixo, movefocus, d
    bindd = SUPER, K, Foco cima, movefocus, u
    bindd = SUPER, L, Foco direita, movefocus, r


    # Resize

    bindd = SUPER CTRL, H, Diminuir largura, resizeactive, -80 0
    bindd = SUPER CTRL, L, Aumentar largura, resizeactive, 80 0
    bindd = SUPER CTRL, K, Diminuir altura, resizeactive, 0 -80
    bindd = SUPER CTRL, J, Aumentar altura, resizeactive, 0 80


    # DMS

    bindd = SUPER, comma, Configurações DMS, exec, dms ipc call settings focusOrToggle
    bindd = SUPER, N, Notificações, exec, dms ipc call notifications toggle
    bindd = SUPER SHIFT, N, Bloco de notas, exec, dms ipc call notepad toggle
    bindd = SUPER, V, Clipboard, exec, dms ipc call clipboard toggle
    bindd = SUPER, M, Processos, exec, dms ipc call processlist focusOrToggle
    bindd = SUPER, X, Menu de energia, exec, dms ipc call powermenu toggle
    bindd = SUPER ALT, L, Bloquear sessão, exec, dms ipc call lock lock
    bindd = SUPER, Y, Wallpapers, exec, dms ipc call dash toggle wallpaper

    bindd = SUPER SHIFT, Slash, Lista de atalhos, exec, dms ipc call keybinds toggle z30n


    # Screenshot

    bindd = , Print, Capturar região, exec, dms screenshot
    bindd = SUPER SHIFT, S, Capturar região, exec, dms screenshot
    bindd = CTRL, Print, Capturar tela inteira, exec, dms screenshot full
    bindd = ALT, Print, Capturar janela, exec, dms screenshot window
  '';


  # ============================================================
  # DMS - CHEAT SHEET
  # ============================================================

  home.file.".config/DankMaterialShell/cheatsheets/z30n.json".text =
    builtins.toJSON {
      title = "Z30N Hyprland";

      provider = "z30n";

      binds = {

        "Aplicativos" = [
          {
            key = "Super + Enter";
            desc = "Abrir Kitty";
          }
          {
            key = "Super + E";
            desc = "Abrir Thunar";
          }
          {
            key = "Super + Space";
            desc = "Launcher";
          }
          {
            key = "Alt + Space";
            desc = "Launcher compacto";
          }
        ];


        "Teclado" = [
          {
            key = "Super + Shift + Space";
            desc = "Alternar entre Português BR e Inglês US";
          }
        ];


        "Janelas" = [
          {
            key = "Alt + Tab";
            desc = "Próxima janela";
          }
          {
            key = "Alt + Shift + Tab";
            desc = "Janela anterior";
          }
          {
            key = "Super + Q";
            desc = "Fechar janela";
          }
          {
            key = "Super + F";
            desc = "Maximizar";
          }
          {
            key = "Super + Shift + F";
            desc = "Fullscreen";
          }
          {
            key = "Super + Shift + T";
            desc = "Floating";
          }
          {
            key = "Super + mouse esquerdo";
            desc = "Mover janela";
          }
          {
            key = "Super + mouse direito";
            desc = "Redimensionar janela";
          }
        ];


        "Workspaces" = [
          {
            key = "Super + ←";
            desc = "Workspace anterior";
          }
          {
            key = "Super + →";
            desc = "Próximo workspace";
          }
          {
            key = "Super + Shift + ←";
            desc = "Mover janela para workspace anterior";
          }
          {
            key = "Super + Shift + →";
            desc = "Mover janela para próximo workspace";
          }
          {
            key = "Super + Tab";
            desc = "Overview";
          }
          {
            key = "Super + 1..0";
            desc = "Ir para workspace";
          }
          {
            key = "Super + Shift + 1..0";
            desc = "Mover janela para workspace";
          }
        ];


        "Foco" = [
          {
            key = "Super + H";
            desc = "Foco esquerda";
          }
          {
            key = "Super + J";
            desc = "Foco baixo";
          }
          {
            key = "Super + K";
            desc = "Foco cima";
          }
          {
            key = "Super + L";
            desc = "Foco direita";
          }
        ];


        "Redimensionamento" = [
          {
            key = "Super + Ctrl + H";
            desc = "Diminuir largura";
          }
          {
            key = "Super + Ctrl + L";
            desc = "Aumentar largura";
          }
          {
            key = "Super + Ctrl + K";
            desc = "Diminuir altura";
          }
          {
            key = "Super + Ctrl + J";
            desc = "Aumentar altura";
          }
        ];


        "DMS" = [
          {
            key = "Super + ,";
            desc = "Configurações";
          }
          {
            key = "Super + N";
            desc = "Notificações";
          }
          {
            key = "Super + Shift + N";
            desc = "Bloco de notas";
          }
          {
            key = "Super + V";
            desc = "Clipboard";
          }
          {
            key = "Super + M";
            desc = "Processos";
          }
          {
            key = "Super + X";
            desc = "Menu de energia";
          }
          {
            key = "Super + Alt + L";
            desc = "Bloquear";
          }
          {
            key = "Super + Y";
            desc = "Wallpapers";
          }
          {
            key = "Super + Shift + /";
            desc = "Mostrar atalhos";
          }
        ];


        "Screenshots" = [
          {
            key = "Print";
            desc = "Capturar região";
          }
          {
            key = "Super + Shift + S";
            desc = "Capturar região estilo Windows";
          }
          {
            key = "Ctrl + Print";
            desc = "Tela inteira";
          }
          {
            key = "Alt + Print";
            desc = "Janela atual";
          }
        ];


        "Sistema" = [
          {
            key = "Super + Shift + E";
            desc = "Sair do Hyprland";
          }
          {
            key = "Super + P";
            desc = "Trocar perfil de monitor";
          }
          {
            key = "Super + Shift + P";
            desc = "Liga/desliga monitores";
          }
        ];
      };
    };


}
