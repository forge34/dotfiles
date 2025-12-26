local awful = require("awful")
local gears = require("gears")
local config_dir = gears.filesystem.get_configuration_dir()

local function run_once(cmd)
	-- This checks if the process is already running before starting it
	awful.spawn.with_shell(string.format("pgrep -u $USER -fx '%s' > /dev/null || (%s &)", cmd, cmd))
end

local function spawn_once_on_tag(cmd, tag_index)
	-- check if the app is already running (to avoid duplicates on reload)
	awful.spawn.easy_async(string.format("pgrep -u $USER -fx '%s'", cmd), function(stdout)
		if stdout == "" or stdout == nil then
			awful.spawn(cmd, {
				tag = screen[1].tags[tag_index],
				switch_to_tags = false, -- Set to true if you want to jump there immediately
			})
		end
	end)
end

-- spawn_once_on_tag("wezterm", 1)
-- spawn_once_on_tag("firefox", 2)
run_once("picom --config " .. config_dir .. "picom.conf -b")
run_once("flameshot")

awful.spawn.with_shell("feh --bg-scale /home/forge/Pictures/wp.png")
awful.spawn.with_shell("sleep 1 && setxkbmap -layout 'us,ara' -option 'grp:alt_shift_toggle'")
