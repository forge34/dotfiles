local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
local wibox = require("wibox")
local beautiful = require("beautiful")
local logout_menu_widget = require("awesome-wm-widgets.logout-menu-widget.logout-menu")
local mytextclock = wibox.widget.textclock()
local mykeyboardlayout = awful.widget.keyboardlayout()
-- local mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon, menu = mymainmenu })
local volume_widget = require("awesome-wm-widgets.pactl-widget.volume")

local margin = 20
local function create_clock_widget(s)
	local time_text = wibox.widget.textclock('<span font="Inter Bold 54" foreground="#c0caf5">%H:%M:%S</span>', 1)
	local date_text = wibox.widget.textclock('<span font="Inter Medium 14" foreground="#7aa2f7">%A, %B %d</span>', 60)

	local width = 400
	local height = 180

	local third_width = s.geometry.width / 3
	local target_x = s.geometry.x + (third_width / 2) - (width / 2) + margin
	local clock_container = wibox({
		screen = s,
		x = target_x,
		y = 100,
		width = width,
		height = height,
		bg = "#222436AA",
		ontop = false,
		visible = true,
		border_width = 2,
		border_color = "#3d59a1", -- Bluloco Blue border
		type = "dock",
	})

	clock_container.shape = function(cr, w, h)
		gears.shape.rounded_rect(cr, w, h, 16)
	end

	clock_container:setup({
		{
			{
				time_text,
				date_text,
				layout = wibox.layout.fixed.vertical,
				spacing = margin,
			},
			valign = "center",
			halign = "center",
			widget = wibox.container.place,
		},
		widget = wibox.container.background,
	})
end
local function create_fetch_widget(s)
	local width = 380
	local height = 280
	local third_width = s.geometry.width / 3
	local target_x = s.geometry.x + (third_width * 2) + (third_width / 2) - (width / 2)
	local fetch_container = wibox({
		screen = s,
		x = target_x,
		y = 100,
		width = width,
		height = height,
		bg = "#222436AA",
		border_width = 2,
		border_color = "#3d59a1", -- Bluloco Blue border
		ontop = false,
		visible = true,
		type = "dock",
	})

	-- Shape the box with slight rounding to match your windows
	fetch_container.shape = function(cr, w, h)
		gears.shape.rounded_rect(cr, w, h, 8)
	end

	fetch_container:setup({
		{
			{
				-- HEADER
				{
					markup = "<span font='0xProto Nerd Font Bold 16' foreground='#3d59a1'>󰣇 Mohamd Abdeltawab</span>",
					widget = wibox.widget.textbox,
				},
				{
					markup = "<span font='0xProto Nerd Font Bold 10' foreground='#3d59a1'>@forge</span>",
					widget = wibox.widget.textbox,
				},

				{
					markup = "<span foreground='#444b6a'>--------------------------</span>",
					widget = wibox.widget.textbox,
				},
				-- OS & KERNEL
				{
					markup = "<span foreground='#3d59a1'>OS:     </span><span foreground='#c8d3f5'>Ubuntu 24.04</span>",
					widget = wibox.widget.textbox,
				},
				-- CPU LOAD
				awful.widget.watch(
					"bash -c \"uptime | awk '{print $(NF-2)}' | sed 's/,//'\"",
					5,
					function(widget, stdout)
						widget:set_markup(
							"<span foreground='#3d59a1'>CPU:    </span><span foreground='#c8d3f5'>"
								.. stdout:gsub("\n", "")
								.. "%</span>"
						)
					end
				),
				-- RAM
				awful.widget.watch("bash -c \"free -m | grep Mem | awk '{print $3}'\"", 10, function(widget, stdout)
					widget:set_markup(
						"<span foreground='#3d59a1'>RAM:    </span><span foreground='#c8d3f5'>"
							.. stdout:gsub("\n", "")
							.. "MB</span>"
					)
				end),
				awful.widget.watch("bash -c \"df -h / | tail -1 | awk '{print $5}'\"", 60, function(widget, stdout)
					widget:set_markup(
						"<span foreground='#3d59a1'>DISK:   </span><span foreground='#c8d3f5'>"
							.. stdout:gsub("\n", "")
							.. " used</span>"
					)
				end),
				-- UPTIME
				awful.widget.watch("uptime -p", 60, function(widget, stdout)
					local uptime = stdout:gsub("\n", ""):gsub("up ", "")
					widget:set_markup(
						"<span foreground='#3d59a1'>UP:     </span><span foreground='#c8d3f5'>" .. uptime .. "</span>"
					)
				end),
				{
					markup = "<span  font='0xProto Nerd Font Bold 12' foreground='#3d59a1'>Welcome to this awesome pc screen!</span>",
					widget = wibox.widget.textbox,
				},

				layout = wibox.layout.fixed.vertical,
				spacing = 8,
			},
			margins = 25,
			widget = wibox.container.margin,
		},
		widget = wibox.container.background,
	})
end
-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
	awful.button({}, 1, function(t)
		t:view_only()
	end),
	awful.button({ modkey }, 1, function(t)
		if client.focus then
			client.focus:move_to_tag(t)
		end
	end),
	awful.button({}, 3, awful.tag.viewtoggle),
	awful.button({ modkey }, 3, function(t)
		if client.focus then
			client.focus:toggle_tag(t)
		end
	end),
	awful.button({}, 4, function(t)
		awful.tag.viewnext(t.screen)
	end),
	awful.button({}, 5, function(t)
		awful.tag.viewprev(t.screen)
	end)
)

local tasklist_buttons = gears.table.join(
	awful.button({}, 1, function(c)
		if c == client.focus then
			c.minimized = true
		else
			c:emit_signal("request::activate", "tasklist", { raise = true })
		end
	end),
	awful.button({}, 3, function()
		awful.menu.client_list({ theme = { width = 250 } })
	end),
	awful.button({}, 4, function()
		awful.client.focus.byidx(1)
	end),
	awful.button({}, 5, function()
		awful.client.focus.byidx(-1)
	end)
)

local function set_wallpaper(s)
	if beautiful.wallpaper then
		local wallpaper = beautiful.wallpaper
		if type(wallpaper) == "function" then
			wallpaper = wallpaper(s)
		end
		gears.wallpaper.maximized(wallpaper, s, true)
	end
end

screen.connect_signal("property::geometry", set_wallpaper)
local tags = require("core.variables").tag_names
awful.screen.connect_for_each_screen(function(s)
	-- Wallpaper
	set_wallpaper(s)
	create_fetch_widget(s)
	create_clock_widget(s)
	local names = { tags.terminal, tags.browser, tags.editor, tags.website_preview, tags.kde_connect, tags.scratch }
	local l = awful.layout.suit
	local layouts = { l.tile, l.max, l.tile.bottom, l.max, l.tile, l.tile }
	awful.tag(names, s, layouts)
	-- Create a promptbox for each screen
	s.mypromptbox = awful.widget.prompt()
	-- Create an imagebox widget which will contain an icon indicating which layout we're using.
	-- We need one layoutbox per screen.
	s.mylayoutbox = awful.widget.layoutbox(s)
	s.mylayoutbox:buttons(gears.table.join(
		awful.button({}, 1, function()
			awful.layout.inc(1)
		end),
		awful.button({}, 3, function()
			awful.layout.inc(-1)
		end),
		awful.button({}, 4, function()
			awful.layout.inc(1)
		end),
		awful.button({}, 5, function()
			awful.layout.inc(-1)
		end)
	))
	-- Create a taglist widget
	s.mytaglist = awful.widget.taglist({
		screen = s,
		filter = awful.widget.taglist.filter.all,
		buttons = taglist_buttons,
		style = {
			shape = gears.shape.rounded_rect,
		},
		layout = {
			spacing = 5,
			layout = wibox.layout.fixed.horizontal,
		},
		widget_template = {
			{
				{
					id = "text_role",
					widget = wibox.widget.textbox,
				},
				left = 10,
				right = 10,
				widget = wibox.container.margin,
			},
			id = "background_role",
			widget = wibox.container.background,
		},
	})
	-- Create a tasklist widget
	s.mytasklist = awful.widget.tasklist({
		screen = s,
		filter = awful.widget.tasklist.filter.currenttags,
		buttons = tasklist_buttons,
	})

	-- Create the wibox
	s.mywibox = awful.wibar({ position = "top", screen = s, bg = "#222436", fg = "#f4f2ff", height = 30 })

	-- Add widgets to the wibox
	s.mywibox:setup({
		{
			{ -- Your existing layout starts here
				layout = wibox.layout.align.horizontal,
				expand = "none",
				{ -- Left
					layout = wibox.layout.fixed.horizontal,
					mykeyboardlayout,
					s.mypromptbox,
				},
				{ -- Middle
					s.mytaglist,
					layout = wibox.layout.fixed.horizontal,
				},
				{ -- Right
					layout = wibox.layout.fixed.horizontal,
					spacing = 15, -- Space between right-side widgets
					volume_widget({
						widget_type = "arc",
					}),
					mytextclock,
					logout_menu_widget({

						onlock = function()
							awful.spawn.with_shell("i3lock-fancy")
						end,
					}),
					s.mylayoutbox,
				},
			},
			-- This adds padding INSIDE the bar
			left = 10,
			right = 10,
			top = 4,
			bottom = 4,
			widget = wibox.container.margin,
		},
		bg = "#222436",
		widget = wibox.container.background,
	})
end)
-- }}}
