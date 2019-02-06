---------------------------
-- Default awesome theme --
---------------------------

local theme_assets = require("beautiful.theme_assets")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

local gfs = require("gears.filesystem")
local themes_path = gfs.get_themes_dir()

local theme = {}

theme.font          = "sans 9"

-- Theme's default background colours
--theme.bg_normal     = "#352918"
--theme.bg_focus      = "#4C453D"
theme.bg_normal     = "#372717"
theme.bg_focus      = "#9f8f71"
--theme.bg_focus      = "#efe0a7"
--theme.bg_focus      = "#fff8be"
theme.bg_urgent     = "#ff0000"
theme.bg_minimize   = "#444444"
theme.bg_systray    = theme.bg_normal

theme.fg_normal     = "#aaaaaa"
theme.fg_focus      = "#ffffff"
theme.fg_urgent     = "#ffffff"
theme.fg_minimize   = "#ffffff"

-- Theme's default foreground colours
theme.useless_gap   = dpi(3)
theme.border_width  = dpi(1)
theme.border_normal = "#002b36"
theme.border_normal = "#002b36"
--theme.border_focus  = "#535d6c"
-- theme.border_focus  = "#999999"
theme.border_focus  = "#eee8d5"
--theme.border_marked = "#91231c"
theme.border_marked = "#999999"

-- There are other variable sets
-- overriding the default one when
-- defined, the sets are:
-- taglist_[bg|fg]_[focus|urgent|occupied|empty|volatile]
-- tasklist_[bg|fg]_[focus|urgent]
-- titlebar_[bg|fg]_[normal|focus]
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- mouse_finder_[color|timeout|animate_timeout|radius|factor]
-- prompt_[fg|bg|fg_cursor|bg_cursor|font]
-- hotkeys_[bg|fg|border_width|border_color|shape|opacity|modifiers_fg|label_bg|label_fg|group_margin|font|description_font]
-- Example:
--theme.taglist_bg_focus = "#ff0000"
--
--theme.tasklist_bg_normal="#403628"

-- Generate taglist squares:
--local taglist_square_size = dpi(1)
theme.taglist_squares_sel = "~/.config/awesome/icons/bar2.png"
--theme.taglist_bg_occupied="#281D0C"
----theme.taglist_bg_empty="#403628"
theme.aglist_shape_border_width_empty = 4
-- theme_assets.taglist_squares_sel(
--     taglist_square_size, theme.fg_normal
-- )
theme.taglist_squares_unsel = "~/.config/awesome/icons/bar2.png"
--theme_assets.taglist_squares_unsel(
 --   taglist_square_size, theme.fg_normal
--)

-- Variables set for theming notifications:
-- notification_font
-- notification_[bg|fg]
-- notification_[width|height|margin]
-- notification_[border_color|border_width|shape|opacity]

-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
theme.menu_submenu_icon = themes_path.."default/submenu.png"
theme.menu_height = dpi(15)
theme.menu_width  = dpi(100)

-- You can add as many variables as
-- you wish and access them by using
-- beautiful.variable in your rc.lua
--theme.bg_widget = "#cc0000"

-- Define the image to load
theme.titlebar_close_button_normal = themes_path.."default/titlebar/close_normal.png"
theme.titlebar_close_button_focus  = themes_path.."default/titlebar/close_focus.png"

theme.titlebar_minimize_button_normal = themes_path.."default/titlebar/minimize_normal.png"
theme.titlebar_minimize_button_focus  = themes_path.."default/titlebar/minimize_focus.png"

theme.titlebar_ontop_button_normal_inactive = themes_path.."default/titlebar/ontop_normal_inactive.png"
theme.titlebar_ontop_button_focus_inactive  = themes_path.."default/titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_active = themes_path.."default/titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_active  = themes_path.."default/titlebar/ontop_focus_active.png"

theme.titlebar_sticky_button_normal_inactive = themes_path.."default/titlebar/sticky_normal_inactive.png"
theme.titlebar_sticky_button_focus_inactive  = themes_path.."default/titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_active = themes_path.."default/titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_active  = themes_path.."default/titlebar/sticky_focus_active.png"

theme.titlebar_floating_button_normal_inactive = themes_path.."default/titlebar/floating_normal_inactive.png"
theme.titlebar_floating_button_focus_inactive  = themes_path.."default/titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_active = themes_path.."default/titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_active  = themes_path.."default/titlebar/floating_focus_active.png"

theme.titlebar_maximized_button_normal_inactive = themes_path.."default/titlebar/maximized_normal_inactive.png"
theme.titlebar_maximized_button_focus_inactive  = themes_path.."default/titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_active = themes_path.."default/titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_active  = themes_path.."default/titlebar/maximized_focus_active.png"

--theme.wallpaper = themes_path.."default/background.png"
--theme.wallpaper = "~/.config/awesome/wallpapers/iceland-high-definition-wallpaper_02051053_163.jpg"
--theme.wallpaper = "~/.config/awesome/wallpapers/rock-ocean-wallpaper-HD.jpg"
--theme.wallpaper = "~/.config/awesome/wallpapers/mountains_2.jpg"
--theme.wallpaper = "~/.config/awesome/wallpapers/solatized_03.jpg"
theme.wallpaper = "~/.config/awesome/wallpapers/arab_01.jpg"
--theme.wallpaper = "~/.config/awesome/wallpapers/winter-wallpaper.jpg"
--theme.wallpaper = "~/.config/awesome/wallpapers/atmosphere_NASA.jpg"
--theme.wallpaper = "~/.config/awesome/wallpapers/snow-mountain.jpg"

-- You can use your own layout icons like this:
theme.layout_fairh = themes_path.."default/layouts/fairhw.png"
theme.layout_fairv = themes_path.."default/layouts/fairvw.png"
theme.layout_floating  = themes_path.."default/layouts/floatingw.png"
theme.layout_magnifier = themes_path.."default/layouts/magnifierw.png"
theme.layout_max = themes_path.."default/layouts/maxw.png"
theme.layout_fullscreen = themes_path.."default/layouts/fullscreenw.png"
theme.layout_tilebottom = themes_path.."default/layouts/tilebottomw.png"
theme.layout_tileleft   = themes_path.."default/layouts/tileleftw.png"
theme.layout_tile = themes_path.."default/layouts/tilew.png"
theme.layout_tiletop = themes_path.."default/layouts/tiletopw.png"
theme.layout_spiral  = themes_path.."default/layouts/spiralw.png"
theme.layout_dwindle = themes_path.."default/layouts/dwindlew.png"
theme.layout_cornernw = themes_path.."default/layouts/cornernww.png"
theme.layout_cornerne = themes_path.."default/layouts/cornernew.png"
theme.layout_cornersw = themes_path.."default/layouts/cornersww.png"
theme.layout_cornerse = themes_path.."default/layouts/cornersew.png"

-- Custom list of icons corresponding to installed software etc.
theme.google="~/.config/awesome/icons/google-chrome.png"

theme.home="~/.config/awesome/icons/home_05.svg"
theme.www="~/.config/awesome/icons/www_2.svg"
--theme.www.layout=wibox.container.margin(_,0,0,3)

theme.mail="~/.config/awesome/icons/mail_03.svg"
theme.chat="~/.config/awesome/icons/chat_02.svg"
theme.media="~/.config/awesome/icons/media_02.svg"
theme.spare="~/.config/awesome/icons/spare_01.svg"
theme.physics="~/.config/awesome/icons/physics_4.svg"
theme.term="~/.config/awesome/icons/terminal_01.svg"
theme.spotify="~/.config/awesome/icons/music_02.svg"

theme.kanji1="~/.config/awesome/icons/kanji/kanji-00-00.png"
theme.kanji2="~/.config/awesome/icons/kanji/kanji-01-00.png"
theme.kanji3="~/.config/awesome/icons/kanji/kanji-02-00.png"
theme.kanji4="~/.config/awesome/icons/kanji/kanji-03-00.png"
theme.kanji5="~/.config/awesome/icons/kanji/kanji-04-00.png"
theme.kanji6="~/.config/awesome/icons/kanji/kanji-05-00.png"
theme.kanji7="~/.config/awesome/icons/kanji/kanji-06-00.png"
theme.kanji8="~/.config/awesome/icons/kanji/kanji-07-00.png"
theme.kanji9="~/.config/awesome/icons/kanji/kanji-08-00.png"
--theme.wibar_shape = gears.shape.powerline


-- Generate Awesome icon:
-- theme.awesome_icon = "~/.config/awesome/icons/gentoo_01.svg"
theme.awesome_icon = "~/.config/awesome/icons/gentoo03.png"
--theme.awesome_icon = theme_assets.awesome_icon(
--    theme.menu_height, theme.bg_focus, theme.fg_focus
--)

-- Define the icon theme for application icons. If not set then the icons
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
theme.icon_theme = nil

return theme

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
