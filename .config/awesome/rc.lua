-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")

-- Widget and layout library
local wibox = require("wibox")

-- Theme handling library
local beautiful = require("beautiful")

-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup").widget

-- Expanded layouts library (GAPS!!)
-- local lain = require("lain")

-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")

-- Custom Awesome WM Widgets
local volume_widget = require('widgets/volume')
local volumebar_widget = require('widgets/volumebar')
 local battery_widget  = require('widgets/battery') -- FLAG
local brightness_widget  = require('widgets/brightness')
local mic_widget  = require('widgets/mic')
local micbar_widget  = require('widgets/micbar')
require('widgets/spotify')

awful.spawn.with_shell(". ~/.config/awesome/autorun.sh")
-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
-- FLAG > Check where the fallback config is and update it to something more managable...
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = tostring(err) })
        in_error = false
    end)
end
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
--beautiful.init("~/.config/awesome/themes/solarized/theme.lua")
beautiful.init("~/.config/awesome/themes/papyrus/theme.lua")
--beautiful.init(gears.filesystem.get_themes_dir() .. "default/theme.lua")

-- This is used later as the default terminal and editor to run.
--terminal = "mate-terminal"
terminal = "/home/artur/.terminal.sh"
editor = os.getenv("EDITOR") or "vim"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
    awful.layout.suit.floating,
--    awful.layout.suit.tile,
--    awful.layout.suit.tile.left,
--    awful.layout.suit.tile.bottom,
--    awful.layout.suit.tile.top,
    awful.layout.suit.fair,             -- Great for 2-4 windows
    awful.layout.suit.fair.horizontal,  -- Great for 6 windows
--    awful.layout.suit.spiral,
--    awful.layout.suit.spiral.dwindle,
    awful.layout.suit.max,
--    awful.layout.suit.max.fullscreen,   -- Great for 1 window, eg. google-chrome
--    awful.layout.suit.magnifier,
--    awful.layout.suit.corner.nw,
--    awful.layout.suit.corner.ne,
--    awful.layout.suit.corner.sw,
--    awful.layout.suit.corner.se,
}
-- }}}

-- {{{ Helper functions
local function client_menu_toggle_fn()
    local instance = nil

    return function ()
        if instance and instance.wibox.visible then
            instance:hide()
            instance = nil
        else
            instance = awful.menu.clients({ theme = { width = 250 } })
        end
    end
end
-- }}}

-- {{{ Menu
-- Create a launcher widget and a main menu
myawesomemenu = {
   { "hotkeys", function() return false, hotkeys_popup.show_help end},
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awesome.conffile },
   { "restart", awesome.restart },
   { "quit", function() awesome.quit() end}
}

-- Don't need a mouse, don't need a menu!
mymainmenu = awful.menu({ items = { --{ "awesome", myawesomemenu, beautiful.awesome_icon },
                                    --{ "mate-terminal", terminal },
                                    --{ "chrome", "google-chrome-stable", beautiful.google}
                                  --  { "chrome", "google-chrome-stable"}
                                  }
                        })

mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                     menu = mymainmenu })

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- Keyboard map indicator and switcher
kbdcfg = {}
kbdcfg.cmd = "setxkbmap"
kbdcfg.layout = { { "us", "" }, { "gb", "" } }
kbdcfg.current = 2  -- de is our default layout
kbdcfg.widget = wibox.widget.textbox()
kbdcfg.widget:set_text(" " .. kbdcfg.layout[kbdcfg.current][1] .. " ")
kbdcfg.switch = function ()
  kbdcfg.current = kbdcfg.current % #(kbdcfg.layout) + 1
  local t = kbdcfg.layout[kbdcfg.current]
  kbdcfg.widget:set_text(" " .. t[1] .. " ")
  os.execute( kbdcfg.cmd .. " " .. t[1] .. " " .. t[2] )
end


-- {{{ Wibar
-- Create a textclock widget
mytextclock = wibox.widget.textclock()

-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
                    awful.button({ }, 1, function(t) t:view_only() end),
                    awful.button({ modkey }, 1, function(t)
                                              if client.focus then
                                                  client.focus:move_to_tag(t)
                                              end
                                          end),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, function(t)
                                              if client.focus then
                                                  client.focus:toggle_tag(t)
                                              end
                                          end),
                    awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
                    awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
                )

local tasklist_buttons = gears.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  -- Without this, the following
                                                  -- :isvisible() makes no sense
                                                  c.minimized = false
                                                  if not c:isvisible() and c.first_tag then
                                                      c.first_tag:view_only()
                                                  end
                                                  -- This will also un-minimize
                                                  -- the client, if needed
                                                  client.focus = c
                                                  c:raise()
                                              end
                                          end),
                     awful.button({ }, 3, client_menu_toggle_fn()),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                          end))

local function set_wallpaper(s)
    -- Wallpaper
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

local function powerline_add(self, ...)
    local colors,new_widgets, dir, count = self.colors or {
      "#3e2d1e",
      "#412900",
    }, {...}, self.direction or "right", #self.children/2
    local ridx    = (dir=="right" and 1 or -1)

    if self.children[count] then self.children[count]:emit_signal("widget::redraw_needed") end

    for i=1, #new_widgets do
        local color = gears.color(colors[(count%#colors) + 1])
        local nextc = gears.color(colors[((count+ridx)%#colors) + 1])

        local separator = wibox.widget {
            fit = function(self,c,w,h) return h/2,h end,
            draw = function(sep, context, cr, w,h)
                local children = self:get_children()
                local is_edge = (ridx==1 and children[#children] == sep) or
                    (ridx==-1 and sep==children[1])

                if not is_edge then
                    cr:set_source(nextc)
                    cr:paint()
                end
                local begx = dir == "right" and 0 or w
                cr:move_to(begx,0)
                cr:line_to(begx==0 and w or 0,h/2)
                cr:line_to(begx, h)
                cr:close_path()
                cr:set_source(color)
                cr:fill()
            end,
            widget = wibox.widget.base.make_widget
        }

        if dir == "left"  then self:real_add(separator) end
        self:real_add(wibox.container.background(new_widgets[i],color))
        if dir == "right" then self:real_add(separator) end
        count = count + 1
    end
end

local function powerline_layout()
    local l = wibox.layout.fixed.horizontal()
    rawset(l, "real_add", l.add        )
    rawset(l, "add"     , powerline_add)
    return l
end

awful.screen.connect_for_each_screen(function(s)
    -- Wallpaper
    set_wallpaper(s)

    -- Each screen has its own tag table.
    local l = awful.layout.suit -- Just to save us some typing, use an alias

--    awful.tag.add("home",{  -- one 一
--      --icon      = beautiful.home,
--      init      = true,
--      layout    = l.fair,
--      selected  = true,
--      screen=s})
--    awful.tag.add("internet",{-- 二
--      --icon=beautiful.www,
--      layout = l.max.fullscreen,
--      exec_once = {"mate-terminal"},
--      screen=s})
--    awful.tag.add("mail",{-- 三
--      --icon=beautiful.mail,
--      layout = l.fair,
--      screen=s})
--    awful.tag.add("chat",{-- 四
--      --icon=beautiful.chat,
--      layout = l.fair,
--      screen=s})
--    awful.tag.add("media",{-- 五
--      --icon=beautiful.media,
--      layout = l.fair,
--      screen=s})
--    awful.tag.add("work",{-- 六
--      --icon=beautiful.term,
--      layout = l.fair,
--      screen=s})
--    awful.tag.add("work",{-- 七
--      --icon=beautiful.term,
--      layout = l.fair,
--      screen=s})
--    awful.tag.add("work",{ -- 九
--      --icon=beautiful.term,
--      layout = l.fair,
--      screen=s})
--    awful.tag.add("spotify",{ -- 九
--      --icon=beautiful.spotify,
--      layout = l.fair,
--      screen=s})

--    awful.tag.add("一",{  -- one 一
--      --icon      = beautiful.home,
--      init      = true,
--      layout    = l.fair,
--      selected  = true,
--      screen=s})
--    awful.tag.add("二",{-- 二
--      --icon=beautiful.www,
--      layout = l.max.fullscreen,
--      exec_once = {"mate-terminal"},
--      screen=s})
--    awful.tag.add("三",{-- 三
--      --icon=beautiful.mail,
--      layout = l.fair,
--      screen=s})
--    awful.tag.add("四",{-- 四
--      --icon=beautiful.chat,
--      layout = l.fair,
--      screen=s})
--    awful.tag.add("五",{-- 五
--      --icon=beautiful.media,
--      layout = l.fair,
--      screen=s})
--    awful.tag.add("六",{-- 六
--      --icon=beautiful.term,
--      layout = l.fair,
--      screen=s})
--    awful.tag.add("七",{-- 七
--      --icon=beautiful.term,
--      layout = l.fair,
--      screen=s})
--    awful.tag.add("八",{ -- 九
--      --icon=beautiful.term,
--      layout = l.fair,
--      screen=s})
--    awful.tag.add("九",{ -- 九
--      --icon=beautiful.spotify,
--      layout = l.fair,
--      screen=s})



    awful.tag.add("",{  -- one 一
      icon      = beautiful.kanji1,
      init      = true,
      layout    = l.fair,
      selected  = true,
      screen=s})
    awful.tag.add("",{-- 二
      icon      = beautiful.kanji2,
      layout = l.max.fullscreen,
      exec_once = {"mate-terminal"},
      screen=s})
    awful.tag.add("",{-- 三
      icon      = beautiful.kanji3,
      layout = l.fair,
      screen=s})
    awful.tag.add("",{-- 四
      icon      = beautiful.kanji4,
      layout = l.fair,
      screen=s})
    awful.tag.add("",{-- 五
      icon      = beautiful.kanji5,
      layout = l.fair,
      screen=s})
    awful.tag.add("",{-- 六
      icon      = beautiful.kanji6,
      layout = l.fair,
      screen=s})
    awful.tag.add("",{-- 七
      icon      = beautiful.kanji7,
      layout = l.fair,
      screen=s})
    awful.tag.add("",{ -- 九
      icon      = beautiful.kanji8,
      layout = l.fair,
      screen=s})
    awful.tag.add("",{ -- 九
      icon      = beautiful.kanji9,
      layout = l.fair,
      screen=s})

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
    -- Create an imagebox widget which will contain an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(gears.table.join(
                           awful.button({ }, 1, function () awful.layout.inc( 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(-1) end),
                           awful.button({ }, 4, function () awful.layout.inc( 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(-1) end)))
    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist(s, awful.widget.taglist.filter.all, taglist_buttons)
--    s.mytaglist = awful.widget.taglist(s, awful.widget.taglist.filter.all, taglist_buttons, nil, nil, powerline_layout())
    --  spacing = 15,
    --  shape function(cr, width, height)
    --    gears.shape.powerline (cr, width, height, -10)
    --  end
    --})
--    s.mytaglist = awful.widget.taglist(s, awful.widget.taglist.filter.all, awful.util.taglist_buttons, {
--      spacing = 0,
--      shape = function(cr, width, height)
--        gears.shape.powerline (cr, width, height, -4)
--      end
--    })

    -- Create a tasklist widget
 --   s.mytasklist = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, tasklist_buttons)
    s.mytasklist = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, tasklist_buttons)
--    s.mytasklist = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, awful.util.tasklist_buttons, {
--      spacing = 0,
--      shape = function(cr, width, height)
--        --gears.shape.powerline (cr, width, height, -10)
--        gears.shape.powerline (cr, width, height, -4)
--      end
--    })


    -- Create the wibox
    s.mywibox = awful.wibar({ position = "top", screen = s ,height=22, ontop=false}
    )

    -- Separators and gaps to put into wibox (separate widgets)
    sprtr = wibox.widget.textbox()
    sprtr:set_text(" : ")
    sprtr2 = wibox.widget.textbox()
    sprtr2:set_text(" || ")

    gapp = wibox.widget.textbox()
    gapp:set_text(" ")

    -- Add widgets to the wibox
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
      --      mylauncher,
      --      sprtr2,
            s.mytaglist,
            sprtr2,
            s.mypromptbox,
        },
        s.mytasklist, -- Middle widget
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            --layout = wibox.layout.flex.horizontal,
--            sprtr,
--            spotify_widget,
--            sprtr,
--            mic_widget, gapp, gapp,
--            micbar_widget,
--            sprtr,
--            volume_widget, gapp, gapp,
--            volumebar_widget,
--            sprtr,
--            brightness_widget,
--            sprtr,
--            gapp,
--            battery_widget, gapp, --gapp, -- FLAG 
--            sprtr,
--            wibox.widget.systray(),
--            sprtr,
--            mytextclock,
--            sprtr,
--            s.mylayoutbox,
            spotify_widget,
            mic_widget,
            spacing_widget,
            micbar_widget,
            spacing_widget,
            volume_widget,
            spacing_widget,
            volumebar_widget,
            spacing_widget,
            brightness_widget,
            spacing_widget,
            battery_widget,
            spacing_widget,
            wibox.widget.systray(),
            spacing_widget,
            mytextclock,
            spacing_widget,
            s.mylayoutbox,
        },
--    },
--    bottom = 4, -- don't forget to increase wibar height
--    color = "#80aa80",
--    widget = wibox.container.margin,
  }
end)
-- }}}

-- {{{ Mouse bindings
root.buttons(gears.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = gears.table.join(
    awful.key({ modkey,           }, "s",      hotkeys_popup.show_help,
              {description="show help", group="awesome"}),
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev,
              {description = "view previous", group = "tag"}),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext,
              {description = "view next", group = "tag"}),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore,
              {description = "go back", group = "tag"}),

    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
        end,
        {description = "focus next by index", group = "client"}
    ),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
        end,
        {description = "focus previous by index", group = "client"}
    ),
--    awful.key({ modkey,           }, "w", function () mymainmenu:show() end,
--              {description = "show main menu", group = "awesome"}),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end,
              {description = "swap with next client by index", group = "client"}),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end,
              {description = "swap with previous client by index", group = "client"}),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end,
              {description = "focus the next screen", group = "screen"}),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end,
              {description = "focus the previous screen", group = "screen"}),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto,
              {description = "jump to urgent client", group = "client"}),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end,
        {description = "go back", group = "client"}),

    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.spawn(terminal) end,
              {description = "open a terminal", group = "launcher"}),
    awful.key({ modkey, "Control" }, "r", awesome.restart,
              {description = "reload awesome", group = "awesome"}),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit,
              {description = "quit awesome", group = "awesome"}),

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)          end,
              {description = "increase master width factor", group = "layout"}),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)          end,
              {description = "decrease master width factor", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1, nil, true) end,
              {description = "increase the number of master clients", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1, nil, true) end,
              {description = "decrease the number of master clients", group = "layout"}),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1, nil, true)    end,
              {description = "increase the number of columns", group = "layout"}),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1, nil, true)    end,
              {description = "decrease the number of columns", group = "layout"}),
    awful.key({ modkey,           }, "space", function () awful.layout.inc( 1)                end,
              {description = "select next", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(-1)                end,
              {description = "select previous", group = "layout"}),

    awful.key({ modkey, "Control" }, "n",
              function ()
                  local c = awful.client.restore()
                  -- Focus restored client
                  if c then
                      client.focus = c
                      c:raise()
                  end
              end,
              {description = "restore minimized", group = "client"}),

    -- Prompt
    awful.key({ modkey },            "r",     function () awful.screen.focused().mypromptbox:run() end,
              {description = "run prompt", group = "launcher"}),

    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run {
                    prompt       = "Run Lua code: ",
                    textbox      = awful.screen.focused().mypromptbox.widget,
                    exe_callback = awful.util.eval,
                    history_path = awful.util.get_cache_dir() .. "/history_eval"
                  }
              end,
              {description = "lua execute prompt", group = "awesome"}),
    -- Menubar
    awful.key({ modkey }, "p", function() menubar.show() end,
              {description = "show the menubar", group = "launcher"}),

    -- Custom key bindings
    --    Lock screen
    awful.key({ modkey,        }, "l",
        function () awful.spawn("xscreensaver-command -lock") end,
        {description = "lock awesome session", group = "custom"}),

    --    Up the volume
    awful.key({}, "XF86AudioLowerVolume", function ()
      awful.util.spawn("amixer -q -D pulse sset Master 5%-", false) end,
      {description = "increase the volume", group = "custom"}),

    --    Down the volume
    awful.key({}, "XF86AudioRaiseVolume", function ()
      awful.util.spawn("amixer -q -D pulse sset Master 5%+", false) end,
      {description = "decrease the volume", group = "custom"}),

    --    Mute  FLAG : not working yet, either issue with spawn or with key itself?
    awful.key({}, "XF86AudioMute", function ()
      awful.util.spawn("amixer -D pulse set Master 1+ toggle", false)
      awful.util.spawn("amixer -D pulse sset Mater toggle", false) 
    end),

    --    Play song  FLAG : Not working yet, 
    --    I don't actually have this button on my laptop :(
    --    Need different key binding.
--    awful.key({modkey, "Alt"}, "n<", function()
--      awful.util.spawn("playerctl play-pause", false)
--    end),

    --    Next song
    awful.key({modkey, "Control"}, "#", function()
      awful.util.spawn("playerctl next", false)
    end),

    --    Previous song
    awful.key({modkey, "Control"}, ";", function()
      awful.util.spawn("playerctl previous", false)
    end),

    --    Scroll song forward
    awful.key({modkey, "Control"}, "]", function()
      awful.util.spawn("playerctl position 5 +", false)
    end),

    --    Scroll song backwards
    awful.key({modkey, "Control"}, "[", function()
      awful.util.spawn("playerctl position 5 -", false)
    end),

    --    Pause/Start song
    awful.key({modkey, "Control"}, "'", function()
      awful.util.spawn("playerctl play-pause", false)
    end),

    --    Icrease & Decrease the screen brightness (requires xbacklight)
    awful.key({}, "XF86MonBrightnessUp", function () awful.spawn("xbacklight -inc 5") end, {description = "increase brightness", group = "custom"}),
    awful.key({}, "XF86MonBrightnessDown", function () awful.spawn("xbacklight -dec 5") end, {description = "decrease brightness", group = "custom"}),
    
    awful.key({modkey}, "w", function()
      for s in screen do
        s.mywibox.visible = not s.mywibox.visible
      end
    end,
    {description = "toggle wibox", group = "custom"})
        
)

clientkeys = gears.table.join(
    awful.key({ modkey,           }, "f",
        function (c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        {description = "toggle fullscreen", group = "client"}),
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end,
              {description = "close", group = "client"}),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ,
              {description = "toggle floating", group = "client"}),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end,
              {description = "move to master", group = "client"}),
    awful.key({ modkey,           }, "o",      function (c) c:move_to_screen()               end,
              {description = "move to screen", group = "client"}),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end,
              {description = "toggle keep on top", group = "client"}),
    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end ,
        {description = "minimize", group = "client"}),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized = not c.maximized
            c:raise()
        end ,
        {description = "(un)maximize", group = "client"}),
    awful.key({ modkey, "Control" }, "m",
        function (c)
            c.maximized_vertical = not c.maximized_vertical
            c:raise()
        end ,
        {description = "(un)maximize vertically", group = "client"}),
    awful.key({ modkey, "Shift"   }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c:raise()
        end ,
        {description = "(un)maximize horizontally", group = "client"})
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = gears.table.join(globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = awful.screen.focused()
                        local tag = screen.tags[i]
                        if tag then
                           tag:view_only()
                        end
                  end,
                  {description = "view tag #"..i, group = "tag"}),
        -- Toggle tag display.
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = awful.screen.focused()
                      local tag = screen.tags[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end,
                  {description = "toggle tag #" .. i, group = "tag"}),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:move_to_tag(tag)
                          end
                     end
                  end,
                  {description = "move focused client to tag #"..i, group = "tag"}),
        -- Toggle tag on focused client.
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:toggle_tag(tag)
                          end
                      end
                  end,
                  {description = "toggle focused client on tag #" .. i, group = "tag"})
    )
end

clientbuttons = gears.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = {  border_width = beautiful.border_width,
                   --   border_width = 0,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     raise = true,
                     keys = clientkeys,
                     buttons = clientbuttons,
                     screen = awful.screen.preferred,
                     placement = awful.placement.no_overlap+awful.placement.no_offscreen
     }
    },

    -- Floating clients.
    { rule_any = {
        instance = {
          "DTA",  -- Firefox addon DownThemAll.
          "copyq",  -- Includes session name in class.
        },
        class = {
          "Arandr",
          "Gpick",
          "Kruler",
          "MessageWin",  -- kalarm.
          "Sxiv",
          "Wpa_gui",
          "pinentry",
          "veromix",
          "xtightvncviewer"},

        name = {
          "Event Tester",  -- xev.
        },
        role = {
          "AlarmWindow",  -- Thunderbird's calendar.
          "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
        }
      }, properties = { floating = true }},

    -- Add titlebars to normal clients and dialogs
    { rule_any = {type = { "normal", "dialog" }
      }, properties = { titlebars_enabled = false }
    },

    -- Set Firefox to always map on the tag named "2" on screen 1.
    -- { rule = { class = "Firefox" },
--    --   properties = { screen = 1, tag = "2" } },
    { rule = { instance = "google-chrome-stable"},
      properties = {tag = "internet"}
    },
--  { rule = { class = "gimp" },
--    properties = { floating = true } 
 -- },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup and
      not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
    
    -- buttons for the titlebar
    awful.titlebar(c) : setup {
        { -- Left
            layout  = wibox.layout.fixed.horizontal
        },
        { -- Middle
            { -- Title
                align  = "center",
                widget = awful.titlebar.widget.titlewidget(c)
            },
            layout  = wibox.layout.flex.horizontal
        },
        { -- Right
            layout = wibox.layout.fixed.horizontal()
        },
        layout = wibox.layout.align.horizontal
    }
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
        and awful.client.focus.filter(c) then
        client.focus = c
    end
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}
