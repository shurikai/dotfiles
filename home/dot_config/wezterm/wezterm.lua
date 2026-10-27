local wezterm = require("wezterm")

local config = {}
if wezterm.config_builder then
	config = wezterm.config_builder()
end

local act = wezterm.action

config.automatically_reload_config = true

config.color_scheme = "Kanagawa (Gogh)"

config.colors = {
	tab_bar = {
		active_tab = {
			bg_color = "#938AA9",
			fg_color = "#DCD7BA",
		},
		-- inactive_tab = {},
		inactive_tab_hover = {
			bg_color = "#16161D",
			fg_color = "#54546D",
			italic = false,
		},
		-- new_tab = {},
		-- new_tab_hover = {},
	},
}

-- config.font = wezterm.font("ZedMono Nerd Font", { weight = "Light" })
config.font = wezterm.font("IosevkaTerm Nerd Font", { weight = "Light" })
-- config.font = wezterm.font("IosevkaTermSlab Nerd Font", { weight = "Light" })
config.font_size = 18
-- config.font = wezterm.font("M+CodeLat50 Nerd Font", { weight = "Regular" })
-- config.enable_tab_bar = false
config.window_decorations = "RESIZE"
config.window_close_confirmation = "NeverPrompt"
config.default_cursor_style = "BlinkingBar"

config.use_fancy_tab_bar = false

config.scrollback_lines = 3000

config.inactive_pane_hsb = {
	-- saturation = 0.5,
	brightness = 0.5,
}

config.leader = { key = "b", mods = "CTRL", timeout_milliseconds = 1000 }
config.keys = {
	-- Ctrl-b Ctrl-b sends a real Ctrl-b through, so tmux on a remote box
	-- (same prefix, same bindings) still works from inside WezTerm.
	{ key = "b", mods = "LEADER|CTRL", action = act.SendKey({ key = "b", mods = "CTRL" }) },
	{ key = "phys:Space", mods = "LEADER", action = act.ActivateCommandPalette },

	-- Pane-related bindings
	{ key = "s", mods = "LEADER", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
	{ key = "v", mods = "LEADER", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
	{ key = "h", mods = "LEADER", action = act.ActivatePaneDirection("Left") },
	{ key = "j", mods = "LEADER", action = act.ActivatePaneDirection("Down") },
	{ key = "k", mods = "LEADER", action = act.ActivatePaneDirection("Up") },
	{ key = "l", mods = "LEADER", action = act.ActivatePaneDirection("Right") },
	{ key = "z", mods = "LEADER", action = act.TogglePaneZoomState },
	{ key = "q", mods = "LEADER", action = act.CloseCurrentPane({ confirm = true }) },
	-- Set up a special set of keybindings to handle resizing of panes.
	{
		key = "r",
		mods = "LEADER",
		action = act.ActivateKeyTable({ name = "resize_pane", one_shot = false }),
	},

	-- Tab-related bindings
	{ key = "t", mods = "LEADER", action = act.SpawnTab("CurrentPaneDomain") },
	{ key = "[", mods = "LEADER", action = act.ActivateTabRelative(-1) },
	{ key = "]", mods = "LEADER", action = act.ActivateTabRelative(1) },
	{ key = "n", mods = "LEADER", action = act.ShowTabNavigator },

	{ key = "w", mods = "LEADER", action = act.ShowLauncherArgs({ flags = "FUZZY|WORKSPACES" }) },
}

config.key_tables = {
	resize_pane = {
		{ key = "h", action = act.AdjustPaneSize({ "Left", 1 }) },
		{ key = "j", action = act.AdjustPaneSize({ "Down", 1 }) },
		{ key = "k", action = act.AdjustPaneSize({ "Up", 1 }) },
		{ key = "l", action = act.AdjustPaneSize({ "Right", 1 }) },
		{ key = "Escape", action = "PopKeyTable" },
		{ key = "Enter", action = "PopKeyTable" },
	},
}

wezterm.on("update-status", function(window, pane)
	local stat = window:active_workspace()
	local scheme = wezterm.color.get_builtin_schemes()[config.color_scheme]

	if window:active_key_table() then
		stat = window:active_key_table()
	end
	if window:leader_is_active() then
		stat = "LEADER"
	end

	local basename = function(s)
		return string.gsub(s, "(.*[/\\])(.*)", "%2")
	end

	-- Current command
	local cmd = pane:get_foreground_process_name()
	-- CMD could be nil (e.g. viewing log using Ctrl-Alt-l)
	cmd = cmd and basename(cmd) or ""

	window:set_left_status(wezterm.format({
		{ Foreground = { Color = "#B98D7B" } },
		{ Text = "  " .. wezterm.nerdfonts.oct_table .. "  " .. stat },
		{ Text = " " },
	}))

	local time = wezterm.strftime("%l:%M%P")

	window:set_right_status(wezterm.format({
		{ Foreground = { Color = "#D27E99" } },
		{ Text = cmd .. " " .. wezterm.nerdfonts.cod_terminal .. " " },
		{ Foreground = { Color = "#727169" } },
		{ Text = " | " },
		{ Foreground = { Color = "#7E9CD8" } },
		{ Text = time .. " " .. wezterm.nerdfonts.md_clock },
		{ Text = " " },
	}))
end)

config.ssh_domains = {
	{
		name = "yolen",
		remote_address = "172.23.0.81",
		username = "jason",
	},
}

return config
