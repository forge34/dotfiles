-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
local beautiful = require("beautiful")
local menubar = require("menubar")
require("core.error_handling")

beautiful.init("~/.config/awesome/theme.lua")
local apps = require("core.apps")

modkey = apps.modkey
terminal = apps.terminal
editor_cmd = apps.editor

awful.layout.layouts = {
	awful.layout.suit.floating,
	awful.layout.suit.tile,
	awful.layout.suit.tile.left,
	awful.layout.suit.tile.bottom,
	awful.layout.suit.tile.top,
	awful.layout.suit.fair,
	awful.layout.suit.fair.horizontal,
	awful.layout.suit.max,
	awful.layout.suit.max.fullscreen,
}

local menu = require("ui.menu")
mymainmenu = menu.mainmenu

menubar.utils.terminal = terminal

root.buttons(gears.table.join(
	awful.button({}, 3, function()
		mymainmenu:toggle()
	end),
	awful.button({}, 4, awful.tag.viewnext),
	awful.button({}, 5, awful.tag.viewprev)
))

awful.rules.rules = require("rules")
require("binding")
require("signals")
require("ui")
require("core.autostart")
