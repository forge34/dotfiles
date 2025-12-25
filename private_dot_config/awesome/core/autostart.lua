local awful = require("awful")

local function run_once(cmd)
	-- This checks if the process is already running before starting it
	awful.spawn.with_shell(string.format("pgrep -u $USER -fx '%s' > /dev/null || (%s &)", cmd, cmd))
end

-- Apps you only want ONE of
run_once("flameshot")
run_once("nm-applet") -- if you use network manager

-- Settings you want to refresh on every reload
awful.spawn.with_shell("feh --bg-scale /home/forge/Pictures/wp.png")
awful.spawn.with_shell("sleep 1 && setxkbmap -layout 'us,ara' -option 'grp:alt_shift_toggle'")
