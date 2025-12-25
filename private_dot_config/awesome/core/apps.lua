-- ~/.config/awesome/core/apps.lua
local apps = {
	-- Default modkey (Mod4 is Windows/Super, Mod1 is Alt)
	modkey = "Mod4",

	-- Applications
	terminal = "x-terminal-emulator",
	editor = os.getenv("EDITOR") or "nvim",

	-- Commands
	launcher = "rofi -show drun -show-icons",
	screenshot = "flameshot gui",
}

-- You can also add derived variables
apps.editor_cmd = apps.terminal .. " -e " .. apps.editor

return apps
