{ ... }:

{
  # ============================================================
  # HYPRLAND
  # ============================================================

  home.file.".config/hypr/hyprland.lua".text = ''
    ------------------------------------------------------------
    -- MONITOR
    ------------------------------------------------------------

    hl.monitor({
        output = "",
        mode = "preferred",
        position = "auto",
        scale = "auto",
    })


    ------------------------------------------------------------
    -- PROGRAMAS
    ------------------------------------------------------------

    local terminal =
        "kitty"

    local fileManager =
        "thunar"

    local mainMod =
        "SUPER"


    ------------------------------------------------------------
    -- CURSOR
    ------------------------------------------------------------

    hl.env(
        "XCURSOR_SIZE",
        "24"
    )

    hl.env(
        "HYPRCURSOR_SIZE",
        "24"
    )


    ------------------------------------------------------------
    -- TECLADO
    ------------------------------------------------------------
    --
    -- Layout 0:
    -- Português Brasil ABNT2
    --
    -- Layout 1:
    -- Inglês US
    --

    hl.config({
        input = {
            kb_layout =
                "br,us",

            kb_variant =
                ",",

            kb_model =
                "",

            kb_options =
                "",

            kb_rules =
                "",

            follow_mouse =
                1,

            sensitivity =
                0,
        },
    })


    ------------------------------------------------------------
    -- VISUAL / LAYOUT
    ------------------------------------------------------------

    hl.config({
        general = {
            gaps_in = 5,

            gaps_out = 10,

            border_size = 2,

            layout = "dwindle",

            resize_on_border = true,

            allow_tearing = false,


            snap = {
                enabled = true,

                border_overlap = false,

                respect_gaps = true,

                monitor_gap = 10,

                window_gap = 10,
            },


            col = {
                active_border =
                    "rgba(89b4faff)",

                inactive_border =
                    "rgba(45475aaa)",
            },
        },


        decoration = {
            rounding = 10,

            rounding_power = 2,

            active_opacity = 1.0,

            inactive_opacity = 0.97,


            shadow = {
                enabled = true,

                range = 8,

                render_power = 3,

                color =
                    "rgba(00000088)",
            },


            blur = {
                enabled = true,

                size = 5,

                passes = 2,

                vibrancy = 0.17,
            },
        },


        animations = {
            enabled = true,
        },


        misc = {
            disable_hyprland_logo = true,

            force_default_wallpaper = 0,
        },
    })


    ------------------------------------------------------------
    -- DWINDLE
    ------------------------------------------------------------

    hl.config({
        dwindle = {
            preserve_split = true,
        },
    })


    ------------------------------------------------------------
    -- DMS
    ------------------------------------------------------------

    hl.on(
        "hyprland.start",

        function()
            hl.exec_cmd(
                "dms run"
            )
        end
    )


    ------------------------------------------------------------
    -- TECLADO BR / US
    --
    -- SUPER + SHIFT + SPACE
    ------------------------------------------------------------

    hl.bind(
        mainMod .. " + SHIFT + SPACE",

        hl.dsp.exec_cmd(
            "hyprctl switchxkblayout all next"
        ),

        {
            description =
                "Alternar teclado BR / US"
        }
    )


    ------------------------------------------------------------
    -- APLICATIVOS
    ------------------------------------------------------------

    hl.bind(
        mainMod .. " + RETURN",

        hl.dsp.exec_cmd(
            terminal
        ),

        {
            description =
                "Abrir terminal"
        }
    )


    hl.bind(
        mainMod .. " + E",

        hl.dsp.exec_cmd(
            fileManager
        ),

        {
            description =
                "Abrir Thunar"
        }
    )


    ------------------------------------------------------------
    -- LAUNCHER
    ------------------------------------------------------------

    hl.bind(
        mainMod .. " + SPACE",

        hl.dsp.exec_cmd(
            "dms ipc call spotlight toggle"
        ),

        {
            description =
                "Abrir launcher"
        }
    )


    hl.bind(
        "ALT + SPACE",

        hl.dsp.exec_cmd(
            "dms ipc call spotlight-bar toggle"
        ),

        {
            description =
                "Abrir launcher compacto"
        }
    )


    ------------------------------------------------------------
    -- JANELAS
    ------------------------------------------------------------

    hl.bind(
        mainMod .. " + Q",

        hl.dsp.window.close(),

        {
            description =
                "Fechar janela"
        }
    )


    hl.bind(
        mainMod .. " + F",

        hl.dsp.window.fullscreen({
            mode = "maximized",
            action = "toggle"
        }),

        {
            description =
                "Maximizar janela"
        }
    )


    hl.bind(
        mainMod .. " + SHIFT + F",

        hl.dsp.window.fullscreen({
            mode = "fullscreen",
            action = "toggle"
        }),

        {
            description =
                "Tela cheia"
        }
    )


    hl.bind(
        mainMod .. " + SHIFT + T",

        hl.dsp.window.float({
            action = "toggle"
        }),

        {
            description =
                "Alternar janela flutuante"
        }
    )


    ------------------------------------------------------------
    -- ALT TAB
    ------------------------------------------------------------

    hl.bind(
        "ALT + TAB",

        hl.dsp.exec_cmd(
            "hyprctl dispatch cyclenext hist"
        ),

        {
            description =
                "Próxima janela"
        }
    )


    hl.bind(
        "ALT + SHIFT + TAB",

        hl.dsp.exec_cmd(
            "hyprctl dispatch cyclenext 'prev hist'"
        ),

        {
            description =
                "Janela anterior"
        }
    )


    ------------------------------------------------------------
    -- WORKSPACES
    --
    -- SUPER + LEFT / RIGHT
    ------------------------------------------------------------

    hl.bind(
        mainMod .. " + LEFT",

        hl.dsp.focus({
            workspace = "e-1"
        }),

        {
            description =
                "Workspace anterior"
        }
    )


    hl.bind(
        mainMod .. " + RIGHT",

        hl.dsp.focus({
            workspace = "e+1"
        }),

        {
            description =
                "Próximo workspace"
        }
    )


    ------------------------------------------------------------
    -- MOVER JANELA ENTRE WORKSPACES
    ------------------------------------------------------------

    hl.bind(
        mainMod .. " + SHIFT + LEFT",

        hl.dsp.window.move({
            workspace = "e-1"
        }),

        {
            description =
                "Mover para workspace anterior"
        }
    )


    hl.bind(
        mainMod .. " + SHIFT + RIGHT",

        hl.dsp.window.move({
            workspace = "e+1"
        }),

        {
            description =
                "Mover para próximo workspace"
        }
    )


    ------------------------------------------------------------
    -- OVERVIEW
    ------------------------------------------------------------

    hl.bind(
        mainMod .. " + TAB",

        hl.dsp.exec_cmd(
            "dms ipc call hypr toggleOverview"
        ),

        {
            description =
                "Overview"
        }
    )


    ------------------------------------------------------------
    -- FOCO ENTRE JANELAS
    --
    -- SUPER + H J K L
    ------------------------------------------------------------

    hl.bind(
        mainMod .. " + H",

        hl.dsp.focus({
            direction = "l"
        }),

        {
            description =
                "Foco esquerda"
        }
    )


    hl.bind(
        mainMod .. " + J",

        hl.dsp.focus({
            direction = "d"
        }),

        {
            description =
                "Foco baixo"
        }
    )


    hl.bind(
        mainMod .. " + K",

        hl.dsp.focus({
            direction = "u"
        }),

        {
            description =
                "Foco cima"
        }
    )


    hl.bind(
        mainMod .. " + L",

        hl.dsp.focus({
            direction = "r"
        }),

        {
            description =
                "Foco direita"
        }
    )


    ------------------------------------------------------------
    -- RESIZE
    --
    -- SUPER + CTRL + H J K L
    ------------------------------------------------------------

    hl.bind(
        mainMod .. " + CTRL + H",

        hl.dsp.window.resize({
            x = -80,
            y = 0,
            relative = true
        }),

        {
            repeating = true,

            description =
                "Diminuir largura"
        }
    )


    hl.bind(
        mainMod .. " + CTRL + L",

        hl.dsp.window.resize({
            x = 80,
            y = 0,
            relative = true
        }),

        {
            repeating = true,

            description =
                "Aumentar largura"
        }
    )


    hl.bind(
        mainMod .. " + CTRL + K",

        hl.dsp.window.resize({
            x = 0,
            y = -80,
            relative = true
        }),

        {
            repeating = true,

            description =
                "Diminuir altura"
        }
    )


    hl.bind(
        mainMod .. " + CTRL + J",

        hl.dsp.window.resize({
            x = 0,
            y = 80,
            relative = true
        }),

        {
            repeating = true,

            description =
                "Aumentar altura"
        }
    )


    ------------------------------------------------------------
    -- MOUSE
    ------------------------------------------------------------

    hl.bind(
        mainMod .. " + mouse:272",

        hl.dsp.window.drag(),

        {
            mouse = true,

            description =
                "Mover janela"
        }
    )


    hl.bind(
        mainMod .. " + mouse:273",

        hl.dsp.window.resize(),

        {
            mouse = true,

            description =
                "Redimensionar janela"
        }
    )


    ------------------------------------------------------------
    -- WORKSPACES 1..10
    ------------------------------------------------------------

    for i = 1, 10 do

        local key =
            i % 10


        hl.bind(
            mainMod .. " + " .. key,

            hl.dsp.focus({
                workspace = i
            }),

            {
                description =
                    "Workspace " .. i
            }
        )


        hl.bind(
            mainMod ..
            " + SHIFT + " ..
            key,

            hl.dsp.window.move({
                workspace = i
            }),

            {
                description =
                    "Mover janela para workspace " .. i
            }
        )
    end


    ------------------------------------------------------------
    -- DMS
    ------------------------------------------------------------

    hl.bind(
        mainMod .. " + COMMA",

        hl.dsp.exec_cmd(
            "dms ipc call settings focusOrToggle"
        ),

        {
            description =
                "Configurações DMS"
        }
    )


    hl.bind(
        mainMod .. " + N",

        hl.dsp.exec_cmd(
            "dms ipc call notifications toggle"
        ),

        {
            description =
                "Notificações"
        }
    )


    hl.bind(
        mainMod .. " + SHIFT + N",

        hl.dsp.exec_cmd(
            "dms ipc call notepad toggle"
        ),

        {
            description =
                "Bloco de notas"
        }
    )


    hl.bind(
        mainMod .. " + V",

        hl.dsp.exec_cmd(
            "dms ipc call clipboard toggle"
        ),

        {
            description =
                "Clipboard"
        }
    )


    hl.bind(
        mainMod .. " + M",

        hl.dsp.exec_cmd(
            "dms ipc call processlist focusOrToggle"
        ),

        {
            description =
                "Processos"
        }
    )


    hl.bind(
        "CTRL + ALT + Delete",

        hl.dsp.exec_cmd(
            "dms ipc call processlist focusOrToggle"
        ),

        {
            description =
                "Processos"
        }
    )


    hl.bind(
        mainMod .. " + X",

        hl.dsp.exec_cmd(
            "dms ipc call powermenu toggle"
        ),

        {
            description =
                "Menu de energia"
        }
    )


    hl.bind(
        mainMod .. " + ALT + L",

        hl.dsp.exec_cmd(
            "dms ipc call lock lock"
        ),

        {
            description =
                "Bloquear sessão"
        }
    )


    hl.bind(
        mainMod .. " + Y",

        hl.dsp.exec_cmd(
            "dms ipc call dash toggle wallpaper"
        ),

        {
            description =
                "Wallpapers"
        }
    )


    ------------------------------------------------------------
    -- LISTA DE ATALHOS
    ------------------------------------------------------------

    hl.bind(
        mainMod .. " + SHIFT + Slash",

        hl.dsp.exec_cmd(
            "dms ipc call keybinds toggle z30n"
        ),

        {
            description =
                "Mostrar atalhos"
        }
    )


    ------------------------------------------------------------
    -- SCREENSHOTS
    ------------------------------------------------------------

    hl.bind(
        "Print",

        hl.dsp.exec_cmd(
            "dms screenshot"
        ),

        {
            description =
                "Capturar região"
        }
    )


    hl.bind(
        mainMod .. " + SHIFT + S",

        hl.dsp.exec_cmd(
            "dms screenshot"
        ),

        {
            description =
                "Capturar região"
        }
    )


    hl.bind(
        "CTRL + Print",

        hl.dsp.exec_cmd(
            "dms screenshot full"
        ),

        {
            description =
                "Capturar tela inteira"
        }
    )


    hl.bind(
        "ALT + Print",

        hl.dsp.exec_cmd(
            "dms screenshot window"
        ),

        {
            description =
                "Capturar janela"
        }
    )


    ------------------------------------------------------------
    -- MONITORES
    ------------------------------------------------------------

    hl.bind(
        mainMod .. " + P",

        hl.dsp.exec_cmd(
            "dms ipc call outputs cycleProfile"
        ),

        {
            description =
                "Trocar perfil de monitor"
        }
    )


    hl.bind(
        mainMod .. " + SHIFT + P",

        hl.dsp.dpms({
            action = "toggle"
        }),

        {
            description =
                "Liga/desliga monitores"
        }
    )


    ------------------------------------------------------------
    -- SAIR
    ------------------------------------------------------------

    hl.bind(
        mainMod .. " + SHIFT + E",

        hl.dsp.exit(),

        {
            description =
                "Sair do Hyprland"
        }
    )


    ------------------------------------------------------------
    -- ÁUDIO
    ------------------------------------------------------------

    hl.bind(
        "XF86AudioRaiseVolume",

        hl.dsp.exec_cmd(
            "dms ipc call audio increment 3"
        ),

        {
            locked = true,
            repeating = true,

            description =
                "Aumentar volume"
        }
    )


    hl.bind(
        "XF86AudioLowerVolume",

        hl.dsp.exec_cmd(
            "dms ipc call audio decrement 3"
        ),

        {
            locked = true,
            repeating = true,

            description =
                "Diminuir volume"
        }
    )


    hl.bind(
        "XF86AudioMute",

        hl.dsp.exec_cmd(
            "dms ipc call audio mute"
        ),

        {
            locked = true,

            description =
                "Silenciar áudio"
        }
    )


    ------------------------------------------------------------
    -- MÍDIA
    ------------------------------------------------------------

    hl.bind(
        "XF86AudioNext",

        hl.dsp.exec_cmd(
            "dms ipc call mpris next"
        ),

        {
            locked = true,

            description =
                "Próxima música"
        }
    )


    hl.bind(
        "XF86AudioPlay",

        hl.dsp.exec_cmd(
            "dms ipc call mpris playPause"
        ),

        {
            locked = true,

            description =
                "Play/Pause"
        }
    )


    hl.bind(
        "XF86AudioPause",

        hl.dsp.exec_cmd(
            "dms ipc call mpris playPause"
        ),

        {
            locked = true,

            description =
                "Play/Pause"
        }
    )


    hl.bind(
        "XF86AudioPrev",

        hl.dsp.exec_cmd(
            "dms ipc call mpris previous"
        ),

        {
            locked = true,

            description =
                "Música anterior"
        }
    )


    ------------------------------------------------------------
    -- BRILHO
    ------------------------------------------------------------

    hl.bind(
        "XF86MonBrightnessUp",

        hl.dsp.exec_cmd(
            "dms ipc call brightness increment 5"
        ),

        {
            locked = true,
            repeating = true,

            description =
                "Aumentar brilho"
        }
    )


    hl.bind(
        "XF86MonBrightnessDown",

        hl.dsp.exec_cmd(
            "dms ipc call brightness decrement 5"
        ),

        {
            locked = true,
            repeating = true,

            description =
                "Diminuir brilho"
        }
    )
  '';
}
