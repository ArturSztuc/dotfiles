-- STANDARD AWESOME LIBRARY
local gears             = require("gears")
local awful             = require("awful")
require("awful.autofocus")

-- WIDGET AND LAYOUT LIBRARY
local wibox             = require("wibox")

-- THEME HANDLING LIBRARY
local beautiful         = require("beautiful")

-- NOTIFICATION LIBRARY
local naughty           = require("naughty")
local menubar           = require("menubar")
local hotkeys_popup     = require("awful.hotkeys_popup").widget

local myseparators = require("myseparator")
local bottombar = require("bottomwibar")

-- EXPANDED LAYOUTS LIBRARY (GAPS!!)
local lain = require("lain")

-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")

-- CUSTOM AWESOME WM WIDGETS
local volume_widget     = require('widgets/volume')
local volumebar_widget  = require('widgets/volumebar')
local battery_widget    = require('widgets/battery') -- FLAG
local brightness_widget = require('widgets/brightness')
local mic_widget        = require('widgets/mic')
local micbar_widget     = require('widgets/micbar')
--local gentoo_widget     = require('widgets/gentoo/gentoo')

local mail_widget       = require('widgets/mail')

require('widgets/spotify')

-- CUSTOM PACKAGES TO RUN AT START
-- This is not a good practice, I should attach this to X11 init instead!
awful.spawn.with_shell(". ~/.config/awesome/autorun.sh")

-- ERROR HANDLING
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
-- FLAG > Check where the fallback config is and update it to something more managable...
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title  = "Oops, there were errors during startup!",
                     text   = awesome.startup_errors })
end

-- HANDLE RUNTIME ERRORS AFTER STARTUP
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

-- VARIABLE DEFINITIONS
-- Themes define colours, icons, font and wallpapers.
beautiful.init("~/.config/awesome/themes/papyrus/theme.lua")

-- This is used later as the default terminal and editor to run.
-- The script opens mate-terminal in either light or dark colourscheme depending
-- on the current time.
--terminal = "/home/artur/.terminal.sh"
--terminal = "st"
terminal = "/home/artur/software/st/st"
editor = os.getenv("EDITOR") or "vim"
editor_cmd = terminal .. " -e " .. editor

-- DEFAULT MODKEY.
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

-- HELPER FUNCTIONS
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

-- MENUBAR CONFIGURATION
menubar.utils.terminal = terminal -- Set the terminal for applications that require it


-- WIBAR
-- Create a textclock widget

mytextclock = wibox.widget.textclock()

local mycal = lain.widget.cal{
  attach_to = {mytextclock},
  notification_preset = {
    font = "Monospace 10",
    fg   = beautiful.fg_normal,
    bg   = beautiful.bg_normal
  }
}

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


-- SET A WALLPAPER ON EACH SCREEN, USING THE ONE DEFINED IN THEME.LUA
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

local cpu = lain.widget.cpu {
    settings = function()
        widget:set_markup("CPU1: " .. cpu_now[1].usage .. " CPU2: " .. cpu_now[2].usage .. " CPU: " .. cpu_now.usage )
    end
}


-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)


-- THIS WILL BE USED FOR THE POWERBAR-LIKE WIBAR
local markup = lain.util.markup
--local separators = lain.util.separators
local separators = lain.util.separators

-- SET EACH SCREEN
awful.screen.connect_for_each_screen(function(s)
    -- Wallpaper
    set_wallpaper(s)

    -- Each screen has its own tag table.
    local l = awful.layout.suit -- Just to save us some typing, use an alias

--    -- Tags with normal names
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

    -- Tags with japanese numbers
    awful.tag.add("",{  -- one 一
      icon      = beautiful.kanji1,
      init      = true,
      layout    = l.fair,
      selected  = true,
      screen=s})
    awful.tag.add("",{-- 二 
      icon      = beautiful.kanji2,
      layout = l.max.fullscreen,
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

    -- Generate a local prompt with user-defined args and make it my default
    -- prompt wiget
    local localprompt = awful.widget.prompt {
      prompt = '<b>Run: </b>',    -- Bold "Run: "
      bg = beautiful.color_red,   -- Red background "box"
    }

    -- Make this local prompt a default prompt widget
    s.mypromptbox = localprompt

    -- Create an imagebox widget which will contain an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(gears.table.join(
                           awful.button({ }, 1, function () awful.layout.inc( 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(-1) end),
                           awful.button({ }, 4, function () awful.layout.inc( 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(-1) end)))

    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist(s, awful.widget.taglist.filter.noempty, taglist_buttons)
--    s.mytaglist = awful.widget.taglist{
--      screen = s, 
--      filter = awful.widget.taglist.filter.noempty,
--    widget_template = {
--        {
--            {
--                {
--                    {
--                        id     = 'icon_role',
--                        widget = wibox.widget.imagebox,
--                    },
----                    margins = 2,
--                    widget  = wibox.container.margin,
--                },
--                {
--                  id = 'taskbar_role',
--                  widget =awful.widget.tasklist{
--                            screen = s, 
--                            --filter = awful.widget.tasklist.filter.currenttags, 
--                            filter = awful.widget.tasklist.filter.currenttags, 
--                            buttons = awful.util.tasklist_buttons,
--                            layout = {
--                              spacing = 5,
--                              forced_num_cols=2,
--                              forced_num_rows=2,
--                              min_cols_size=7,
--                              min_rows_size=7,
--                            --  expand=true,
--                              layout = wibox.layout.grid.horizontal},
--                              widget_template = {
--                                  {
--                                      margins = 1,
--                                      widget  = wibox.container.margin,
--                                  },
--                                  id              = 'background_role',
--                                  widget          = wibox.container.background,
--                              },
--                            }
--                },
--
--                layout = wibox.layout.fixed.horizontal,
--            },
----            left  = 10,
----            right = 10,
--           widget = wibox.container.margin
--        },
--       id     = 'background_role',
--       widget = wibox.container.background,
--    },
--
--      buttons = taglist_buttons}

--s.mytaglist = awful.widget.taglist{
--  screen = s, 
--  filter = awful.widget.taglist.filter.noempty,
--  widget_template = {
--    {
--      widget = separators.arrow_right("alpha", beautiful.color_lbrown),
--    },
--    {
--      {
--        {
--          id     = 'icon_role',
--          widget = wibox.widget.imagebox,
--        },
--        id = 'background_role',
--        widget = wibox.container.background,
--      },
--      --      id = 'background_role',
--      bg = beautiful.color_lbrown,
--      widget = wibox.container.background,
--    },
--    {
--      --      widget = separators.arrow_right(beautiful.color_red,"alpha"),
--      widget = separators.arrow_right(beautiful.color_lbrown,"alpha"),
--    },
--    layout = wibox.layout.fixed.horizontal,
--  },
--  buttons = taglist_buttons
--}


--    s.mytasklist = 
--    awful.widget.tasklist{
--      screen = s, 
--      --filter = awful.widget.tasklist.filter.currenttags, 
--      filter = awful.widget.tasklist.filter.currenttags, 
--      buttons = awful.util.tasklist_buttons,
--      layout = {
--        spacing = 5,
--        forced_num_cols=2,
--        forced_num_rows=2,
--        min_cols_size=7,
--        min_rows_size=7,
--      --  expand=true,
--        layout = wibox.layout.grid.horizontal},
--        widget_template = {
--            {
--                margins = 1,
--                widget  = wibox.container.margin,
--            },
--            id              = 'background_role',
--            widget          = wibox.container.background,
--        },
--  }


    -- Contain the taglist in a box/rectangle background
   mytaglistcont = wibox.container.background(s.mytaglist, beautiful.color_lbrown, gears.shape.rectangle)
   -- mytaglistcont = wibox.container.background(s.mytaglist, "alpha", gears.shape.rectangle)
    -- Margin so it's central in y direction on the wibar
    s.mytag = wibox.container.margin(mytaglistcont, 0,0,0,6)

    -- Create a tasklist widget
--    s.mytasklist = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, tasklist_buttons)
    -- Not perfect, but this generates a powerline-like box.
    s.mytasklist = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, awful.util.tasklist_buttons, {
      spacing = 0,
      shape = function(cr, width, height)
        arrow_depth = height/2
        local offset = 0
        
        -- Avoid going out of the (potential) clip area
        if arrow_depth < 0 then
          width  =  width + 2*arrow_depth
          offset = -arrow_depth
       end
        
        cr:move_to(offset                       , 0        )
        cr:line_to(offset + width  ,              0        )
        cr:line_to(offset + width - arrow_depth , height   )
        cr:line_to(offset + arrow_depth         , height)
        
        cr:close_path()
      end,
    })

--    s.mytasklist = awful.widget.tasklist{
--      screen = s, 
--      --filter = awful.widget.tasklist.filter.currenttags, 
--      filter = awful.widget.tasklist.filter.currenttags, 
--      buttons = awful.util.tasklist_buttons,
--      layout = {
--        spacing = 5,
--        forced_num_cols=2,
--        forced_num_rows=2,
--        min_cols_size=7,
--        min_rows_size=7,
--      --  expand=true,
--        layout = wibox.layout.grid.horizontal},
--        widget_template = {
--            {
--                margins = 1,
--                widget  = wibox.container.margin,
--            },
--            id              = 'background_role',
--            widget          = wibox.container.background,
--        },
--  }


    -- Create the wibox
    s.mywibox = awful.wibar({ position = "top", screen = s ,height=25, ontop=false , visible=false}
    )
    -- Create the wibox
--    s.mywibox_bottom = awful.wibar({ position = "bottom", screen = s ,height=25, ontop=false , visible=true}
--    )

    bottombar.setBar(s)
    
    -- Need this to make a box around systray - basically sets background colour
    beautiful.bg_systray = beautiful.color_magneta,

    -- Add widgets to the wibox
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,

            -- Arrows to make powerline-like effect, with mrgins.
            --wibox.container.margin(separators.arrow_right("alpha", beautiful.color_lbrown),0,0,3,3),
            -- Taglist has a set background so no need for box around it
            s.mytag,
--            wibox.container.margin(separators.arrow_right(beautiful.color_lbrown,"alpha"), 0,0,3,3),
            wibox.container.margin(myseparators.arrow_left(beautiful.color_lbrown,"alpha"), 0,0,0,6),

            -- Promptbox
            wibox.container.margin(myseparators.arrow_left("alpha", beautiful.color_red),0,0,6,0),
            wibox.container.margin(s.mypromptbox, 0,0,6,0),
            wibox.container.margin(myseparators.arrow_right(beautiful.color_red,"alpha"),0,0,6,0),
        },
        wibox.container.margin(s.mytasklist,0,0,0,6), -- Middle widget
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,

--            -- Spotify widget - Will still have a small empty "powerline" arrow
--            -- if spotify is not on
--            wibox.container.margin(separators.arrow_left("alpha", beautiful.color_violet),0,0,3,3),
--            wibox.container.margin(wibox.container.background(spotify_widget,beautiful.color_violet),0,0,3,3),
--            wibox.container.margin(separators.arrow_left(beautiful.color_violet, "alpha"),0,0,3,3),
--
--            -- Microphone widget (Try lain one?)
--            wibox.container.margin(separators.arrow_left("alpha", beautiful.color_cyan),0,0,3,3),
--            wibox.container.margin(wibox.container.background(mic_widget, beautiful.color_cyan),0,0,3,3),
--            wibox.container.margin(wibox.container.background(micbar_widget, beautiful.color_cyan),0,0,3,3),
--            wibox.container.margin(separators.arrow_left(beautiful.color_cyan, "alpha"),0,0,3,3),
--
--            -- Volume widget (Try lain one?)
--            wibox.container.margin(separators.arrow_left("alpha", beautiful.color_blue),0,0,3,3),
--            wibox.container.margin(wibox.container.background(volume_widget, beautiful.color_blue),0,0,3,3),
--            wibox.container.margin(wibox.container.background(volumebar_widget, beautiful.color_blue),0,0,3,3),
--            wibox.container.margin(separators.arrow_left(beautiful.color_blue, "alpha"),0,0,3,3),
--
--            -- Brightness widget (Try lain one?)
--            wibox.container.margin(separators.arrow_left("alpha", beautiful.color_green),0,0,3,3),
--            wibox.container.margin(wibox.container.background(brightness_widget, beautiful.color_green),0,0,3,3),
--            wibox.container.margin(separators.arrow_left(beautiful.color_green, "alpha"),0,0,3,3),
--
--            -- Battery widget (Not working properly - doesn't update
--            -- automatically, or often enough)
--            wibox.container.margin(separators.arrow_left("alpha", beautiful.color_yellow),0,0,3,3),
--            wibox.container.margin(wibox.container.background(battery_widget, beautiful.color_yellow),0,0,3,3),
--            wibox.container.margin(separators.arrow_left(beautiful.color_yellow, "alpha"),0,0,3,3),
--
--            -- Date/Clock widget, maybe update it to full callendar...
--            wibox.container.margin(separators.arrow_left("alpha", beautiful.color_orange),0,0,3,3),
--            wibox.container.margin(wibox.container.background(mytextclock, beautiful.color_orange),0,0,3,3),
--            wibox.container.margin(separators.arrow_left(beautiful.color_orange, "alpha"),0,0,3,3),
--
--            -- Systray widget! 
--            wibox.container.margin(separators.arrow_left("alpha", beautiful.color_red),0,0,3,3),
--            wibox.container.margin(wibox.container.background(mail_widget, beautiful.color_red),0,0,3,3),
--            wibox.container.margin(separators.arrow_left(beautiful.color_red, "alpha"),0,0,3,3),
--
--            -- Layout-box widget, displays current WM layout on current tag
--            wibox.container.margin(separators.arrow_left("alpha", beautiful.color_magneta),0,0,3,3),
--            wibox.container.margin(wibox.widget.systray(), 0,0,3,3),
--            wibox.container.margin(wibox.container.background(s.mylayoutbox, beautiful.color_magneta),0,0,3,3),


            -- Hopefully-working gentoo updates widget :) 
--            wibox.container.margin(myseparators.arrow_right("alpha", beautiful.color_violet),0,0,0,6),
--            wibox.container.margin(wibox.container.background(gentoo_widget,beautiful.color_violet),0,0,0,6),
--            wibox.container.margin(myseparators.arrow_left(beautiful.color_violet, "alpha"),0,0,0,6),

            -- Spotify widget - Will still have a small empty "powerline" arrow
            -- if spotify is not on
            wibox.container.margin(myseparators.arrow_right("alpha", beautiful.color_violet),0,0,0,6),
            wibox.container.margin(wibox.container.background(spotify_widget,beautiful.color_violet),0,0,0,6),
            wibox.container.margin(myseparators.arrow_left(beautiful.color_violet, "alpha"),0,0,0,6),

            -- Microphone widget (Try lain one?)
            wibox.container.margin(myseparators.arrow_left("alpha", beautiful.color_cyan),0,0,6,0),
            wibox.container.margin(wibox.container.background(mic_widget, beautiful.color_cyan),0,0,6,0),
            wibox.container.margin(wibox.container.background(micbar_widget, beautiful.color_cyan),0,0,6,0),
            wibox.container.margin(myseparators.arrow_right(beautiful.color_cyan, "alpha"),0,0,6,0),

            -- Volume widget (Try lain one?)
            wibox.container.margin(myseparators.arrow_right("alpha", beautiful.color_blue),0,0,0,6),
            wibox.container.margin(wibox.container.background(volume_widget, beautiful.color_blue),0,0,0,6),
            wibox.container.margin(wibox.container.background(volumebar_widget, beautiful.color_blue),0,0,0,6),
            wibox.container.margin(myseparators.arrow_left(beautiful.color_blue, "alpha"),0,0,0,6),

            -- Brightness widget (Try lain one?)
            wibox.container.margin(myseparators.arrow_left("alpha", beautiful.color_green),0,0,6,0),
            wibox.container.margin(wibox.container.background(brightness_widget, beautiful.color_green),0,0,6,0),
            wibox.container.margin(myseparators.arrow_right(beautiful.color_green, "alpha"),0,0,6,0),

            -- Battery widget (Not working properly - doesn't update
            -- automatically, or often enough)
            wibox.container.margin(myseparators.arrow_right("alpha", beautiful.color_yellow),0,0,0,6),
            wibox.container.margin(wibox.container.background(battery_widget, beautiful.color_yellow),0,0,0,6),
            wibox.container.margin(myseparators.arrow_left(beautiful.color_yellow, "alpha"),0,0,0,6),

            -- Date/Clock widget, maybe update it to full callendar...
            wibox.container.margin(myseparators.arrow_left("alpha", beautiful.color_orange),0,0,6,0),
            wibox.container.margin(wibox.container.background(mytextclock, beautiful.color_orange),0,0,6,0),
            wibox.container.margin(myseparators.arrow_right(beautiful.color_orange, "alpha"),0,0,6,0),

            -- Systray widget! 
            wibox.container.margin(myseparators.arrow_right("alpha", beautiful.color_red),0,0,0,6),
            wibox.container.margin(wibox.container.background(mail_widget, beautiful.color_red),0,0,0,6),
            wibox.container.margin(myseparators.arrow_left(beautiful.color_red, "alpha"),0,0,0,6),

            -- Layout-box widget, displays current WM layout on current tag
            wibox.container.margin(myseparators.arrow_left("alpha", beautiful.color_magneta),0,0,6,0),
            wibox.container.margin(wibox.widget.systray(), 0,0,6,0),
            wibox.container.margin(wibox.container.background(s.mylayoutbox, beautiful.color_magneta),0,0,6,0),
        },
  }
end)

-- MOUSE BINDINGS
root.buttons(gears.table.join(
--    awful.button({ }, 3, function () mymainmenu:toggle() end), -- No menus,
--    this is WM not some DM...
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))

-- KEY BINDINGS
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

    -- LAYOUT MANIPULATION
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

    -- STANDARD PROGRAM
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

    -- PROMPT
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

    -- Menubar - Do we need this? What is it even for?
    awful.key({ modkey }, "p", function() menubar.show() end,
              {description = "show the menubar", group = "launcher"}),

    -- CUSTOM KEY BINDINGS
    --    Lock screen
    awful.key({ modkey,        }, "l",
        function () awful.spawn("xscreensaver-command -lock") end,
        {description = "lock awesome session", group = "custom"}),

    --    Up the volume
    awful.key({}, "XF86AudioLowerVolume", function ()
      --awful.util.spawn("amixer -q -D pulse sset Master 5%-", false) end,
      awful.util.spawn("amixer set Master 5%-", false) end,
      {description = "increase the volume", group = "custom"}),

    --    Down the volume
    awful.key({}, "XF86AudioRaiseVolume", function ()
      awful.util.spawn("amixer set Master 5%+", false) end,
      {description = "decrease the volume", group = "custom"}),

    --    Mute  FLAG : not working yet, either issue with spawn or with key itself?
    awful.key({}, "XF86AudioMute", function ()
      awful.util.spawn("amixer set Master toggle", false)
    end),

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
    
    -- Toggle top wibar
    awful.key({modkey}, "e", function()
      for s in screen do
        s.mywibox.visible = not s.mywibox.visible
      end
    end,
    {description = "toggle top wibox", group = "custom"}),

    -- Toggle bottom wibar
    awful.key({modkey}, "b", function()
      for s in screen do
        if s.mywibox_bottom then
          s.mywibox_bottom.visible = not s.mywibox_bottom.visible
        end
      end
    end,
    {description = "toggle bottom wibox", group = "custom"})
        
)

clientkeys = gears.table.join(
    awful.key({ modkey,           }, "f",
        function (c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        {description = "toggle fullscreen", group = "client"}),
    --awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end,
    --          {description = "close", group = "client"}),
    awful.key({ modkey}, "w",      function (c) c:kill()                         end,
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

-- SET KEYS
root.keys(globalkeys)

-- RULES TO APPLY TO NEW CLIENTS (THROUGH THE "MANAGE" SIGNAL).
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
    { rule = { instance = "google-chrome-stable"},
      properties = {tag = "internet"}
    },
}
-- }}}

--  SIGNALS
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

-- ADD A TITLEBAR IF TITLEBARS_ENABLED IS SET TO TRUE IN THE RULES.
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
