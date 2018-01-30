#!/usr/bin/envautorun.sh

function run {
  if ! pgrep $1 ;
  then
    $@&
  fi
}

run setxkbmap gb
run xscreensaver -no-splash &
run ibus-daemon -xdr
