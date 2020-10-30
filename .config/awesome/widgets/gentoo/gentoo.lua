local awful = require("awful")
local wibox = require("wibox")
local naughty = require("naughty")
local watch = require("awful.widget.watch")

--local socket = require("socket")

-- local GET_SPOTIFY_STATUS_CMD = os.getenv("HOME") .. '/.config/awesome/awesome-wm-widgets/spotify-widget/spotify_stat'
-- local GET_SPOTIFY_STATUS_CMD = 'sp status'
-- local GET_CURRENT_SONG_CMD = 'sp current-oneline'
-- local PATH_TO_ICONS = "/usr/share/icons/Arc"

local CMD_PACKAGE_UPDATE = '/home/artur/GENTOO/scripts/updatePackageInfo'
local CMD_LIST_UPDATES  = '/home/artur/GENTOO/scripts/updatePackageInfo -o ld'
-- Checks for package updates and shout if we see one
local CMD_NUMBER_UPDATES = '/home/artur/GENTOO/scripts/updatePackageInfo -s c'
local PATH_TO_ICONS = "/home/artur/.config/awesome/icons/"


--local function networkConnection()
--    local test = socket.tcp()
--    test:settimeout(1)  -- Set timeout to 1 second
--    local netConn = test:connect("www.google.com", 80)
--    if netConn == nil then
--        return false
--    end
--    netConn:close()
--    return true
--end

local gentoo_widget = wibox.widget {
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

-- Popup with GENTOO status
local notification
local function show_gentoo_status()
    awful.spawn.easy_async(CMD_LIST_UPDATES,
      function(stdout, _, _, _)
        local txt = tonumber(stdout)
        if (txt == -1) then
          txt = "No internet connection!"
        else 
          txt = stdout
        end
        naughty.destroy(notification)
        notification = naughty.notify{
          text = txt,
          title = "Gentoo status",
          timeout = 5, hover_timeout = 0.5,
          width = 500,
        }
      end
    )
end

local function show_gentoo_warning()
  naughty.notify{
    icon = "/home/artur/.config/awesome/icons/scream.png",
    icon_size = 100,
    text = "We have some package updates!",
    title= "Ho ho ho!",
    timeout = 5, hover_timeout = 0.5,
    position = "top_left",
    bg = "#F06060",
    fg = "#EEE9EF",
    width = 300,
  }
end

watch(CMD_NUMBER_UPDATES, 10,
  function(widget, stdout)
    local updateStatus
    local nUpdates = tonumber(stdout)
    if ( nUpdates == 0 ) then
      updateStatus = "no-updates"
    elseif (nUpdates > 0) then
      updateStatus = "new-updates"
      show_gentoo_warning()
    elseif (nUpdates == -1) then 
      updateStatus = "no-updates"
    end
    gentoo_widget.icon:set_image(PATH_TO_ICONS .. "gentoo_" .. updateStatus .. ".png")
  end,
  gentoo_widget
  )

gentoo_widget:connect_signal("mouse::enter", function() show_gentoo_status() end)
gentoo_widget:connect_signal("mouse::leave", function() naughty.destroy(notification) end)

return gentoo_widget
