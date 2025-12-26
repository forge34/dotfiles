local wezterm = require("wezterm")
local act = wezterm.action
local config = wezterm.config_builder()

local is_wayland = os.getenv("XDG_SESSION_TYPE") == "wayland"

config.default_prog = { "/usr/bin/zsh" }
config.exit_behavior = "Hold"
config.enable_wayland = is_wayland -- True in GNOME, False in AwesomeWM

config.font = wezterm.font("0xProto Nerd Font")
config.font_size = 10.3
config.window_decorations = "RESIZE"
config.color_scheme = "BlulocoDark"
config.window_padding = {
	top = is_wayland and "0.5cell" or "0.8cell",
	bottom = 0,
	left = "1.5cell",
	right = "1.5cell",
}
config.colors = {
	background = "#222436",
	selection_bg = "#444a73",
}
config.window_background_opacity = 0.75
config.keys = {
	{ key = "F11", action = act.ToggleFullScreen },
	{ key = "'", mods = "CTRL", action = act.ActivateTabRelative(1) },
	{ key = ";", mods = "CTRL", action = act.ActivateTabRelative(-1) },
	{ key = "\\", mods = "CTRL", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
	{ key = "\\", mods = "SHIFT|CTRL", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
	{ key = "k", mods = "CTRL", action = act.ClearScrollback("ScrollbackAndViewport") },
	{
		key = "k",
		mods = "SHIFT|CTRL",
		action = act.Multiple({
			act.ClearScrollback("ScrollbackAndViewport"),
			act.SendKey({ key = "L", mods = "CTRL" }),
		}),
	},
}

config.hide_tab_bar_if_only_one_tab = true
config.default_cursor_style = "BlinkingBar"

return config
