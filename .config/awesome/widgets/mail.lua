-------------------------------------------------
-- Battery Widget for Awesome Window Manager
-- Shows the battery status using the ACPI tool
-- More details could be found here:
-- https://github.com/streetturtle/awesome-wm-widgets/tree/master/battery-widget

-- @author Pavel Makhov
-- @copyright 2017 Pavel Makhov
-------------------------------------------------

local awful = require("awful")
local naughty = require("naughty")
local beautiful = require("beautiful")
local watch = require("awful.widget.watch")
local wibox = require("wibox")

-- acpi sample outputs
-- Battery 0: Discharging, 75%, 01:51:38 remaining
-- Battery 0: Charging, 53%, 00:57:43 until charged

--local PATH_TO_ICONS = "/usr/share/icons/Arc/status/symbolic/"
local PATH_TO_ICONS = "/usr/share/icons/Adwaita/24x24/legacy/"
--local PATH_TO_ICONS = "/usr/share/icons/Arc/status/symbolic"
-- local HOME = os.getenv("HOME")
--

local didnotify = false

--local battery_text = wibox.widget.textbox() 
--battery_text:set_font("Play 9")
--
--local battery_icon = wibox.widget.imagebox()

local mail_widget = wibox.widget {
  {
    id = "icon",
    widget = wibox.widget.imagebox,
  },
  {
    id = "txt",
    widget = wibox.widget.textbox,
  },
  layout = wibox.layout.fixed.horizontal,
}
mail_widget.txt:set_font("Play 9")

-- Popup with battery info
-- One way of creating a pop-up notification - naughty.notify
local notification
local function show_battery_status()
    awful.spawn.easy_async([[bash -c 'mailstatus']],
        function(stdout, _, _, _)
          naughty.destroy(notification)
            notification = naughty.notify{
                text =  stdout,
                title = "Mail status",
                timeout = 5, hover_timeout = 0.5,
                width = 500,
            }
        end
    )
end

-- Alternative to naughty.notify - tooltip. You can compare both and choose the preferred one
--battery_popup = awful.tooltip({objects = {mail_widget}})

-- To use colors from beautiful theme put
-- following lines in rc.lua before require("battery"):
-- beautiful.tooltip_fg = beautiful.fg_normal
-- beautiful.tooltip_bg = beautiful.bg_normal

local function show_mail_warning()
    naughty.notify{
        icon = "/home/artur/.config/awesome/icons/scream.png",
        icon_size=100,
        text = "Ground Control to Major Tom...",
        title = "You have a new email",
        timeout = 20, hover_timeout = 0.5,
        position = "bottom_left",
        bg = beautiful.color_yellow,
        fg = beautiful.color_magneta,
        width = 300,
    }
end

watch("checkmail", 10,
    function(widget, stdout)
        local batteryType

--        local charge_str = string.match(stdout, '(.+): (%a+), (%d?%d%d)%%,? ?.*')
        local charge = tonumber(stdout)
        local chargestr = tonumber(string.format("%.0f", stdout))
        mail_widget.txt:set_text(" " .. chargestr)
        if (charge == 0) then
            batteryType = "mail-read"
            didnotify = false
        elseif (charge > 0) then 
          batteryType = "mail-unread"
          if( didnotify == false ) then
            show_mail_warning()
            didnotify = true
          end
        end
        mail_widget.icon:set_image(PATH_TO_ICONS .. batteryType .. ".png")

      end,
    mail_widget
  )


mail_widget:connect_signal("mouse::enter", function() show_battery_status() end)
mail_widget:connect_signal("mouse::leave", function() naughty.destroy(notification) end)

return mail_widget
