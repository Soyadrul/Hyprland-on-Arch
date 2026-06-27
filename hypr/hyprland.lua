--[[
  Hyprland Lua config (Hyprland >= 0.55)
  See https://wiki.hypr.land/Configuring/Start/
]]

-- Variables
local out_margin = 10
local cursor_theme = "Bibata-Modern-Classic"
local cursor_size = 24
local terminal = "kitty"
local fileManager = "nautilus"
local menu = "wofi --conf $HOME/.config/wofi/config --style $HOME/.config/wofi/style.css"
local mainMod = "SUPER"

-- Monitor
hl.monitor({ output = "", mode = "2560x1440@120", position = "auto", scale = 1.33 })

-- Workspace rules
hl.workspace_rule({ workspace = 1, persistent = true, monitor = "", default = true })
hl.workspace_rule({ workspace = 2, persistent = true, monitor = "" })
hl.workspace_rule({ workspace = 3, persistent = true, monitor = "" })
hl.workspace_rule({ workspace = 4, persistent = true, monitor = "" })
hl.workspace_rule({ workspace = 5, persistent = true, monitor = "" })

-- Environment variables
hl.env("XCURSOR_SIZE", tostring(cursor_size))
hl.env("XCURSOR_THEME", cursor_theme)
hl.env("HYPRCURSOR_SIZE", tostring(cursor_size))
hl.env("HYPRCURSOR_THEME", cursor_theme)
hl.env("QT_QPA_PLATFORM", "wayland")
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")

-- Autostart apps
hl.on("hyprland.start", function()
    hl.exec_cmd("waybar --config $HOME/.config/waybar/config --style $HOME/.config/waybar/style.css")
    hl.exec_cmd("hyprpaper")
    hl.exec_cmd("nwg-dock-hyprland -d -c \"wofi --show drun\" -i 36 -lp start -mb $out_margin -p bottom -s \"style.css\"")
    hl.exec_cmd("systemctl --user start hyprpolkitagent")
    hl.exec_cmd("wl-paste --type text --watch cliphist store") -- Stores only text data
    hl.exec_cmd("wl-paste --type image --watch cliphist store") -- Stores only image data
    hl.exec_cmd("dunst -conf $HOME/.config/dunst/dunstrc")
    hl.exec_cmd("nm-applet")
    hl.exec_cmd("blueman-applet")
    hl.exec_cmd("hypridle")
    -- hl.exec_cmd("systemctl --user restart xdg-desktop-portal-hyprland")
    hl.exec_cmd("gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita-dark'")
    hl.exec_cmd("gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'")
    hl.exec_cmd("gsettings set org.gnome.desktop.interface icon-theme 'Adwaita'")
    hl.exec_cmd("gsettings set org.gnome.desktop.interface cursor-theme '" .. cursor_theme .. "'")
    hl.exec_cmd("gsettings set org.gnome.desktop.interface cursor-size " .. cursor_size)
    hl.exec_cmd("hyprsunset")
    hl.exec_cmd("source $HOME/.config/hypr/scripts/blue-light/blue-light-filter-manager.sh")
    hl.exec_cmd("[workspace special:magic silent] thunderbird")
end)

-- Config sections
hl.config({
    input = {
        kb_layout = "it",
        follow_mouse = 1,
        touchpad = {
            natural_scroll = true,
            scroll_factor = 0.3,
        },
        sensitivity = 0,
        numlock_by_default = true,
    },
    general = {
        gaps_in = 5,
        gaps_out = out_margin,
        border_size = 3,
        --["col.active_border"] = "rgba(33ccffee) rgba(00ff99ee) 45deg",
        ["col.active_border"] = "rgba(33ccffee)",
        ["col.inactive_border"] = "rgba(595959aa)",
        layout = "dwindle",
        allow_tearing = false,
        resize_on_border = false,
    },
    decoration = {
        rounding = 7,
        blur = {
            enabled = true,
            size = 8,
            passes = 1,
            ignore_opacity = true,
            new_optimizations = true,
            xray = true,
        },
        shadow = {
            enabled = false,
            range = 5,
            render_power = 3,
            color = "rgba(1a1a1aee)",
        },
        active_opacity = 1.0,
        inactive_opacity = 0.7,
    },
    dwindle = {
        preserve_split = true,
        force_split = 0
    },
    master = {},
    misc = {
        disable_hyprland_logo = true,
        force_default_wallpaper = 0,
    },
    cursor = {
        no_hardware_cursors = 0,
    },
    xwayland = {
        force_zero_scaling = true,
    },
})

-- Bezier curves
hl.curve("myBezier", { type = "bezier", points = {{ 0.05, 0.9 }, { 0.1, 1.05 }} })
hl.curve("easeInOutBack", { type = "bezier", points = {{ 0.68, -0.6 }, { 0.32, 1.6 }} })
hl.curve("easeOutQuad", { type = "bezier", points = {{ 0.5, 1 }, { 0.89, 1 }} })
hl.curve("easeOutCubic", { type = "bezier", points = {{ 0.33, 1 }, { 0.68, 1 }} })
hl.curve("easeOutQuart", { type = "bezier", points = {{ 0.25, 1 }, { 0.5, 1 }} })
hl.curve("easeInCirc", { type = "bezier", points = {{ 0.55, 0 }, { 1, 0.45 }} })
hl.curve("easeInSine", { type = "bezier", points = {{ 0.12, 0 }, { 0.39, 0 }} })
hl.curve("easeOutSine", { type = "bezier", points = {{ 0.61, 1 }, { 0.88, 1 }} })
hl.curve("easeInOutSine", { type = "bezier", points = {{ 0.37, 0 }, { 0.63, 1 }} })
hl.curve("overshot", { type = "bezier", points = {{ 0.05, 0.9 }, { 0.1, 1.1 }} })
hl.curve("linear", { type = "bezier", points = {{ 0, 0 }, { 1, 1 }} })
hl.curve("easeOut", { type = "bezier", points = {{ 0, 0 }, { 0.58, 1.0 }} })

-- Animations
hl.animation({ leaf = "windows", enabled = true, speed = 7, bezier = "easeOutCubic", style = "slide" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 7, bezier = "easeOutCubic", style = "slide" })
hl.animation({ leaf = "border", enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "borderangle", enabled = true, speed = 8, bezier = "default" })
hl.animation({ leaf = "fade", enabled = true, speed = 7, bezier = "default" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 6, bezier = "default" })

-- Gestures
hl.gesture({
    fingers = 3,
    direction = "horizontal",
    action = "workspace",
    workspace_swipe_create_new = false
})

-- Device config (example)
--hl.device({ name = "", sensitivity = -0.5 })

-- Per-device config placeholder
-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Devices/
--hl.device({ name = "device-name-from-hyprctl-devices", sensitivity = -0.5 })

-- Window rules (all commented, kept as reference)
--hl.window_rule({ match = { class = "^(firefox)$", title = "^(Removing Cookies and Site Data)$" }, size = { w = "26.0416666666%", h = "25%" } })
--hl.window_rule({ match = { class = "^(zen)$", title = "^(Removing Cookies and Site Data)$" }, size = { w = "26.0416666666%", h = "25%" } })
--hl.window_rule({ match = { class = "^(org.nickvision.tubeconverter)$", title = "^(org.nickvision.tubeconverter)$" }, size = { w = 420, h = 641 } })

-- Keybinds

-- General
hl.bind(mainMod .. " + Q", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + C", hl.dsp.window.close())
hl.bind(mainMod .. " + M", hl.dsp.exit())
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + V", hl.dsp.window.float())
hl.bind(mainMod .. " + R", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())

-- Move focus with arrow keys
hl.bind(mainMod .. " + left", hl.dsp.focus({ direction = "l" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "r" }))
hl.bind(mainMod .. " + up", hl.dsp.focus({ direction = "u" }))
hl.bind(mainMod .. " + down", hl.dsp.focus({ direction = "d" }))

-- Switch workspaces with mainMod + [0-9]
hl.bind(mainMod .. " + 1", hl.dsp.focus({ workspace = 1 }))
hl.bind(mainMod .. " + 2", hl.dsp.focus({ workspace = 2 }))
hl.bind(mainMod .. " + 3", hl.dsp.focus({ workspace = 3 }))
hl.bind(mainMod .. " + 4", hl.dsp.focus({ workspace = 4 }))
hl.bind(mainMod .. " + 5", hl.dsp.focus({ workspace = 5 }))
--hl.bind(mainMod .. " + 6", hl.dsp.focus({ workspace = 6 }))
--hl.bind(mainMod .. " + 7", hl.dsp.focus({ workspace = 7 }))
--hl.bind(mainMod .. " + 8", hl.dsp.focus({ workspace = 8 }))
--hl.bind(mainMod .. " + 9", hl.dsp.focus({ workspace = 9 }))
--hl.bind(mainMod .. " + 0", hl.dsp.focus({ workspace = 10 }))

-- Move active window to a workspace with mainMod + SHIFT + [0-9]
hl.bind(mainMod .. " + SHIFT + 1", hl.dsp.window.move({ workspace = 1 }))
hl.bind(mainMod .. " + SHIFT + 2", hl.dsp.window.move({ workspace = 2 }))
hl.bind(mainMod .. " + SHIFT + 3", hl.dsp.window.move({ workspace = 3 }))
hl.bind(mainMod .. " + SHIFT + 4", hl.dsp.window.move({ workspace = 4 }))
hl.bind(mainMod .. " + SHIFT + 5", hl.dsp.window.move({ workspace = 5 }))
--hl.bind(mainMod .. " + SHIFT + 6", hl.dsp.window.move({ workspace = 6 }))
--hl.bind(mainMod .. " + SHIFT + 7", hl.dsp.window.move({ workspace = 7 }))
--hl.bind(mainMod .. " + SHIFT + 8", hl.dsp.window.move({ workspace = 8 }))
--hl.bind(mainMod .. " + SHIFT + 9", hl.dsp.window.move({ workspace = 9 }))
--hl.bind(mainMod .. " + SHIFT + 0", hl.dsp.window.move({ workspace = 10 }))

-- Special workspace (scratchpad)
hl.bind(mainMod .. " + S", hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

-- Scroll through existing workspaces with mainMod + scroll
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- Scroll through existing workspaces with mainMod + ALT
hl.bind(mainMod .. " + ALT + right", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + ALT + left", hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })    -- Move a window
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })  -- Resize a window

-- Brightness
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl set 2%+ ; notify-send --icon=/usr/share/icons/Adwaita/symbolic/status/display-brightness-symbolic.svg --replace-id=999999 \"Brightness\" \"Current brightness: $(brightnessctl -m | awk -F',' '{print $3}') ($(brightnessctl -m | awk -F',' '{print $4}'))\""), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl set 2%- ; notify-send --icon=/usr/share/icons/Adwaita/symbolic/status/weather-clear-symbolic.svg --replace-id=999999 \"Brightness\" \"Current brightness: $(brightnessctl -m | awk -F',' '{print $3}') ($(brightnessctl -m | awk -F',' '{print $4}'))\""), { locked = true, repeating = true })

-- Blue light (TO-DO)
hl.bind(mainMod .. " + XF86MonBrightnessUp", hl.dsp.exec_cmd("source $HOME/.config/hypr/scripts/blue-light/increase-blue-light.sh"), { locked = true, repeating = true })
hl.bind(mainMod .. " + XF86MonBrightnessDown", hl.dsp.exec_cmd("source $HOME/.config/hypr/scripts/blue-light/decrease-blue-light.sh"), { locked = true, repeating = true })

-- Speaker volume
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("pamixer -i 2 ; notify-send --icon=/usr/share/icons/Adwaita/symbolic/status/audio-volume-high-symbolic.svg --replace-id=999998 \"Speaker volume\" \"$(pamixer --get-volume-human)\""), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("pamixer -d 2 ; notify-send --icon=/usr/share/icons/Adwaita/symbolic/status/audio-volume-medium-symbolic.svg --replace-id=999998 \"Speaker volume\" \"$(pamixer --get-volume-human)\""), { locked = true, repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("pamixer --toggle-mute ; notify-send --icon=/usr/share/icons/Adwaita/symbolic/status/audio-volume-muted-symbolic.svg --replace-id=999998 \"Speaker volume\" \"Muted\""), { locked = true })

-- Microphone volume
hl.bind(mainMod .. " + XF86AudioRaiseVolume", hl.dsp.exec_cmd("pamixer --default-source -i 2 ; notify-send --icon=/usr/share/icons/Adwaita/symbolic/status/microphone-sensitivity-high-symbolic.svg --replace-id=999997 \"Microphone volume\" \"$(pamixer --default-source --get-volume-human)\""), { locked = true, repeating = true })
hl.bind(mainMod .. " + XF86AudioLowerVolume", hl.dsp.exec_cmd("pamixer --default-source -d 2 ; notify-send --icon=/usr/share/icons/Adwaita/symbolic/status/microphone-sensitivity-medium-symbolic.svg --replace-id=999997 \"Microphone volume\" \"$(pamixer --default-source --get-volume-human)\""), { locked = true, repeating = true })
hl.bind(mainMod .. " + XF86AudioMute", hl.dsp.exec_cmd("pamixer --default-source --toggle-mute ; notify-send --icon=/usr/share/icons/Adwaita/symbolic/status/microphone-sensitivity-muted-symbolic.svg --replace-id=999997 \"Microphone volume\" \"Muted\""), { locked = true })

-- Touchpad toggle
hl.bind("XF86TouchpadOff", hl.dsp.exec_cmd("notify-send --icon=/usr/share/icons/Adwaita/symbolic/status/touchpad-disabled-symbolic.svg --replace-id=1000001 \"Touchpad\" \"The touchpad has been disabled\""))
hl.bind("XF86TouchpadOn", hl.dsp.exec_cmd("notify-send --icon=/usr/share/icons/Adwaita/symbolic/devices/input-touchpad-symbolic.svg --replace-id=1000001 \"Touchpad\" \"The touchpad has been enabled\""))

-- Player keys
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind(mainMod .. " + XF86AudioPlay", hl.dsp.exec_cmd("playerctl --all-players play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioStop", hl.dsp.exec_cmd("playerctl stop"), { locked = true })
hl.bind(mainMod .. " + XF86AudioStop", hl.dsp.exec_cmd("playerctl --all-players stop"), { locked = true })

-- Fullscreen
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen())

-- Wallpaper (reload)
hl.bind(mainMod .. " + W", hl.dsp.exec_cmd("RANDOM_FILE=$(find $HOME/.config/wallpapers/*/ -type f -not -name \"*.txt\" | shuf -n 1) ; hyprctl hyprpaper preload $RANDOM_FILE ; hyprctl hyprpaper wallpaper \" ,$RANDOM_FILE\" ; hyprctl hyprpaper unload unused"))

-- Lock screen
hl.bind(mainMod .. " + L", hl.dsp.exec_cmd("loginctl lock-session"), { locked = true })
hl.bind(mainMod .. " + SHIFT + L", hl.dsp.exec_cmd("systemctl suspend"), { locked = true })

-- Clipboard manager (cliphist)
hl.bind("ALT + SHIFT + C", hl.dsp.exec_cmd("cliphist list | wofi -S dmenu | cliphist decode | wl-copy"))
hl.bind("ALT + SHIFT + D", hl.dsp.exec_cmd("cliphist wipe  ; notify-send --urgency=critical \"Erased clipboard history\" \"All the clipboard history has been erased\""))
--hl.bind("ALT + SHIFT + D", hl.dsp.exec_cmd("cliphist list | wofi -S dmenu | cliphist delete"))

-- Lid switch (suspend)
hl.bind("switch:on:Lid Switch", hl.dsp.exec_cmd("systemctl suspend"), { locked = true })
--hl.bind("switch:Lid Switch", hl.dsp.exec_cmd("loginctl lock-session"), { locked = true })
--hl.bind("switch:on:Lid Switch", hl.dsp.exec_cmd("hyprctl keyword monitor \"eDP-1, disable\""))
--hl.bind("switch:off:Lid Switch", hl.dsp.exec_cmd("hyprctl keyword monitor \"eDP-1, 1920x1080, 0x0, 1\""))

-- Switch between windows in a floating workspace
hl.bind(mainMod .. " + TAB", function()
  hl.dispatch(hl.dsp.window.cycle_next())
  hl.dispatch(hl.dsp.window.alter_zorder({ mode = "top" })) -- TO-DO: when 1 window is in float mode and the other in "normal" mode the float window is always on top, but the correct window is selected
end)

-- Screenshot
hl.bind("Print", hl.dsp.exec_cmd("grim - | swappy -f -"), { locked = true })
hl.bind(mainMod .. " + Print", hl.dsp.exec_cmd("grim -g \"$(slurp)\" - | swappy -f -"))

-- Toggle nwg-dock-hyprland
hl.bind(mainMod .. " + Super_L", hl.dsp.exec_cmd("nwg-dock-hyprland"))

-- Resize windows (tiled + floating)
hl.bind(mainMod .. " + SHIFT + Right", hl.dsp.window.resize({ x = 20, y = 0, relative = true }), { repeating = true })
hl.bind(mainMod .. " + SHIFT + Left",  hl.dsp.window.resize({ x = -20, y = 0, relative = true }), { repeating = true })
hl.bind(mainMod .. " + SHIFT + Up",    hl.dsp.window.resize({ x = 0, y = -20, relative = true }), { repeating = true })
hl.bind(mainMod .. " + SHIFT + Down",  hl.dsp.window.resize({ x = 0, y = 20, relative = true }), { repeating = true })

-- Move windows (tiled)
hl.bind(mainMod .. " + CTRL + Left",  hl.dsp.window.swap({ direction = "l" }))
hl.bind(mainMod .. " + CTRL + Right", hl.dsp.window.swap({ direction = "r" }))
hl.bind(mainMod .. " + CTRL + Up",    hl.dsp.window.swap({ direction = "u" }))
hl.bind(mainMod .. " + CTRL + Down",  hl.dsp.window.swap({ direction = "d" }))

-- Move windows (floating) - TO-DO
--hl.bind(mainMod .. " + CTRL + Right", hl.dsp.moveactive("20", "0"), { repeating = true })
--hl.bind(mainMod .. " + CTRL + Left", hl.dsp.moveactive("-20", "0"), { repeating = true })
--hl.bind(mainMod .. " + CTRL + Up", hl.dsp.moveactive("0", "-20"), { repeating = true })
--hl.bind(mainMod .. " + CTRL + Down", hl.dsp.moveactive("0", "20"), { repeating = true })

-- Open system resources
hl.bind(mainMod .. " + Z", hl.dsp.exec_cmd("resources"))

-- Activate/deactivate greyscale mode - TO-DO
--hl.bind(mainMod .. " + G", hl.dsp.exec_cmd("if [[ \"$(hyprctl getoption decoration:screen_shader | grep \"set\")\" == \"set: false\" ]]; then hyprctl keyword decoration:screen_shader $HOME/.config/hypr/shaders/greyscale_50.glsl; elif [[ \"$(hyprctl getoption decoration:screen_shader | grep \"greyscale_50.glsl\")\" == \"str: $HOME/.config/hypr/shaders/greyscale_50.glsl\" ]]; then hyprctl keyword decoration:screen_shader $HOME/.config/hypr/shaders/greyscale_100.glsl; else hyprctl reload; fi"), { locked = true })

--hl.bind(mainMod .. " + SHIFT + G", hl.dsp.exec_cmd("case \"$(hyprctl getoption decoration:screen_shader | grep \"greyscale\")\" in \"str: /home/soyadrul/.config/hypr/shaders/greyscale_50.glsl\") hyprctl reload;; \"str: /home/soyadrul/.config/hypr/shaders/greyscale_100.glsl\") hyprctl keyword decoration:screen_shader $HOME/.config/hypr/shaders/greyscale_50.glsl;; *) hyprctl keyword decoration:screen_shader $HOME/.config/hypr/shaders/greyscale_100.glsl;; esac"), { locked = true })
