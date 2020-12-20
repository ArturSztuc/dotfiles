#!/bin/bash
# Will check emails twice a minute if set up with cronjob correctly
killall mbsync &>/dev/null
mbsync -a -q
sleep 30
killall mbsync &>/dev/null
mbsync -a -q
