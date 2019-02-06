#!/usr/bin/envautorun.sh

#function run {
#  if ! pgrep $1 ;
#  then
#    $@&
#  fi
#}

#run
( speaker-test -t sine -f 600 )& pid=$! ; sleep 0.32s ; kill -9 $pid
