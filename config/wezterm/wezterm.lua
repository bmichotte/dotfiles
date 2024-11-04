local wezterm = require("wezterm")

local function scheme_for_appearance(appearance)
    if appearance:find("Dark") then
        return "Catppuccin Mocha"
    else
        return "Catppuccin Latte"
    end
end

local config = wezterm.config_builder()

-- config.window_decorations = "RESIZE"
-- config.enable_tab_bar = false
config.native_macos_fullscreen_mode = true

config.color_scheme = scheme_for_appearance(wezterm.gui.get_appearance())

config.font = wezterm.font("OperatorMonoLig Nerd Font", { weight = "Regular", italic = false })
config.font_size = 16.0
config.freetype_load_target = "Light"

config.keys = {
    {
        key = "RightArrow",
        mods = "CMD",
        action = wezterm.action.ActivateTabRelative(1),
    },
    {
        key = "LeftArrow",
        mods = "CMD",
        action = wezterm.action.ActivateTabRelative(-1),
    },
    {
        key = "RightArrow",
        mods = "CTRL|SHIFT",
        action = wezterm.action.DisableDefaultAssignment,
    },
    {
        key = "LeftArrow",
        mods = "CTRL|SHIFT",
        action = wezterm.action.DisableDefaultAssignment,
    },
    {
        key = "Enter",
        mods = "CMD",
        action = wezterm.action.ToggleFullScreen,
    },
}

return config
