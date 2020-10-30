-- My bottom wibar with CPU, RAM etc. info

-- Requirements
local awful = require("awful")
local wibox = require("wibox")
local lain = require("lain")
local beautiful = require("beautiful")
local gears = require("gears")

-- My custom separator
local separators = require("myseparator")

--local separators = lain.util.separators

local bottomwibar = {}

-- Lain widgets
local cpu = lain.widget.cpu {
  settings = function()
    widget:set_markup(" CPU: " .. cpu_now.usage .. "% " )
  end
}

local cpu1 = lain.widget.cpu {
  settings = function()
    widget:set_markup("CPU1: " .. cpu_now[1].usage .. "%")
  end
}

local cpu2 = lain.widget.cpu {
  settings = function()
    widget:set_markup("CPU2: " .. cpu_now[2].usage .. "%" )
  end
}

local ram = lain.widget.mem {
  settings = function()
    widget:set_markup("RAM: " .. mem_now.perc .. "%")
  end
}



-- TODO
-- * Add battery status
-- * Add wifi status
-- * Add some disk status with drop-down status
-- * Add drop-down status with CPU breakdown to CPU-all and remove CPU-1 and CPU-2
-- * Add drop-down status with memory breakdown to RAM
-- * Modify the bar so the theme is similar/same as the topbar
-- * Maybe do `mybars` instead of mybottombar and insert all here?

function bottomwibar.setBar(s)
  s.mywibox_bottom = awful.wibar({ position = "bottom", screen = s, height=19, ontop=false, visible=false, bg = beautiful.bg_normal .. "0"})

  s.mywibox_bottom:setup {
    layout = wibox.layout.align.horizontal,
    { -- Left widgets
      layout = wibox.layout.fixed.horizontal,
      nil,
    },
    nil,
    {
      -- Right widgets
      layout = wibox.layout.fixed.horizontal,
      separators.arrow_right("alpha", beautiful.color_cyan),
      wibox.container.background(ram.widget, beautiful.color_cyan),
      separators.arrow_left(beautiful.color_cyan,"alpha"),

      separators.arrow_left("alpha", beautiful.color_red),
      wibox.container.background(cpu.widget, beautiful.color_red),
      separators.arrow_right(beautiful.color_red,"alpha"),

      separators.arrow_right("alpha", beautiful.color_red),
      wibox.container.background(cpu1.widget, beautiful.color_red),
      separators.arrow_left(beautiful.color_red,"alpha"),

      separators.arrow_left("alpha", beautiful.color_red),
      wibox.container.background(cpu2.widget, beautiful.color_red),
--      separators.arrow_left(beautiful.color_red,"alpha"),
    },
  }

end

return bottomwibar

