-- MONITOR

hl.monitor({
    output = "",
    mode = "preferred",
    position = "auto",
    scale = "auto",
})

-- TCL principal; identifica o monitor mesmo se mudar de porta.
hl.monitor({
    output = "desc:Technical Concepts Ltd 25G64 2A624AA011016",
    mode = "1920x1080@300",
    position = "0x0",
    scale = 1,
})

-- AOC à esquerda do TCL, alinhado pelo topo.
hl.monitor({
    output = "desc:AOC 2260WG5 0x000004F6",
    mode = "1920x1080@74.92",
    position = "1920x0",
    scale = 1,
})

-- PROGRAMAS

-- CURSOR

hl.env(
    "XCURSOR_SIZE",
    "24"
)

hl.env(
    "HYPRCURSOR_SIZE",
    "24"
)

-- TECLADO
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

-- VISUAL / LAYOUT

hl.config({
    general = {
        gaps_in = 5,

        gaps_out = 12,

        border_size = 2,

        layout = "dwindle",

        resize_on_border = true,

        allow_tearing = false,

        snap = {
            enabled = true,

            border_overlap = false,

            respect_gaps = true,

            monitor_gap = 12,

            window_gap = 6,
        },

    },

    decoration = {
        rounding = 6,

        rounding_power = 2,

        active_opacity = 0.98,

        inactive_opacity = 0.95,

        shadow = {
            enabled = true,

            range = 12,

            render_power = 3,

        },

        blur = {
            enabled = true,

            size = 6,

            passes = 2,

            brightness = 0.92,

            contrast = 1.05,

            vibrancy = 0.08,
        },
    },

    animations = {
        enabled = true,
    },

    misc = {
        disable_hyprland_logo = true,

        force_default_wallpaper = 0,

        -- Evita expor o fundo preto padrão enquanto a sessão gráfica inicia.
        background_color = "rgb(0b1423)",
    },
})

-- BLUR DO DMS

-- O Hyprland aplica o blur às layers; não oferece ext-background-effect-v1.
hl.layer_rule({
    name = "dms-blur",
    match = {
        namespace = "^dms:.*$",
    },
    blur = true,
    ignore_alpha = 0,
})

-- DWINDLE

hl.config({
    dwindle = {
        preserve_split = true,
    },
})

hl.window_rule({
    name = "picture-in-picture",

    match = {
        title = ".*[Pp]icture[- ]in[- ][Pp]icture.*",
    },

    float = true,
    pin = true,
    keep_aspect_ratio = true,

    size = {
        "monitor_w * 0.25",
        "monitor_h * 0.25",
    },

    move = {
        "monitor_w - window_w - 20",
        "monitor_h - window_h - 20",
    },
})
