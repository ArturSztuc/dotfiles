#!/usr/bin/envautorun.sh

function run {
  if ! pgrep $1 ;
  then
    $@&
  fi
}

#run setxkbmap gb
#xscreensaver -no-splash &
#ibus-daemon -xdr
#fcitx -dr
offlineimap -c /home/artur/.offlineimaprc
