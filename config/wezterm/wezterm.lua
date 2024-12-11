local wezterm = require("wezterm") --[[@as Wezterm]]

local function scheme_for_appearance(appearance)
	if appearance:find("Dark") then
		return "Catppuccin Mocha"
	else
		return "Catppuccin Latte"
	end
end

local config = wezterm.config_builder()

config.audible_bell = "Disabled"

-- config.window_decorations = "RESIZE"
-- config.enable_tab_bar = false
config.hide_tab_bar_if_only_one_tab = true
config.native_macos_fullscreen_mode = true

config.enable_wayland = true
config.webgpu_power_preference = "HighPerformance"
-- config.animation_fps = 1
-- config.cursor_blink_ease_in = "Constant"
-- config.cursor_blink_ease_out = "Constant"

config.bypass_mouse_reporting_modifiers = "SHIFT"

config.color_scheme = scheme_for_appearance(wezterm.gui.get_appearance())

config.underline_thickness = 3
config.cursor_thickness = 4
config.underline_position = -6

config.font = wezterm.font("OperatorMonoLig Nerd Font", { weight = "Regular", italic = false })
config.font_size = 16.0
config.freetype_load_target = "Light"

-- config.font = wezterm.font({ family = "FiraCode Nerd Font" })
config.bold_brightens_ansi_colors = true
config.font_rules = {
	{
		intensity = "Bold",
		italic = true,
		font = wezterm.font({ family = "OperatorMonoLig Nerd Font", weight = "Bold", style = "Italic" }),
	},
	{
		italic = true,
		intensity = "Half",
		font = wezterm.font({ family = "OperatorMonoLig Nerd Font", weight = "DemiBold", style = "Italic" }),
	},
	{
		italic = true,
		intensity = "Normal",
		font = wezterm.font({ family = "OperatorMonoLig Nerd Font", style = "Italic" }),
	},
}

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
