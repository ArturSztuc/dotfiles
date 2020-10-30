# .bashrc

# Do not run if not in interactive mode
[[ $- == *i* ]] || return
export TERM=xterm-256color


#~/./screenfetch-dev
~/./WORK/scripts/printTasks -f ~/WORK/TODO -t ls

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi
TIME=`date +%H`

# Requires xdotools and my suckless/simple terminal fork...
if [ "$TIME" -ge 6 -a "$TIME" -le 16 ];
then
  if [ -z "$TMUX" ];
  then
    xdotool key F6 BackSpace
  fi
fi

# Don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# Append to the history file, don't overwrite it
shopt -s histappend

GPG_TTY='tty'
export GPG_TTY

# for setting to the history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000000
HISTFILESIZE=2000000

# Check the window size after each command and, if necessarty, 
# update the values of LINES and COLUMNS
shopt -s checkwinsize

#eneable colour support of ls...
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias ll='ls --color=auto -h -l'
    alias la='ls --color=auto -h -l -a'
fi

#User specific aliases and functions
export PATH=${PATH}:/opt/google/chrome/
export PATH=${PATH}:/opt/icedtea-bin-3.6.0/bin/
export PATH=${PATH}:/home/artur/WORK/scripts/
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/icedtea-bin-3.6.0/jre/lib
#PS1='\[\033[1;36m\]\u\[\033[1;31m\]@\[\033[1;32m\]\h:\[\033[36m\]\w\[\033[1;31m\]\$\[\033[0m\] '
PS1='\[$(tput bold)\]\[\033[38;5;9m\]\t\[$(tput bold)\]\[$(tput sgr0)\]\[\033[38;5;15m\] \[\033[1;36m\]\u\[\033[1;31m\]@\[\033[1;32m\]\h:\[\033[36m\]\w\[\033[1;31m\]\$\[\033[0m\] '
export PATH=${PATH}:/home/artur/.local/bin
export PATH=${PATH}:/home/artur/software/anyconnect-linux64-4.8.01090/vpn

export EDITOR=vim
export TO_MAILTO='a.sztuc16@imperial.ac.uk'

#alias sshfslx00='sshfs -C -o reconnect,ServerAliveInterval=15,ServerAliveCountMax=3,workaround=nodelaysrv /home/as16/lx00/ as16@lx00.hep.ph.ic.ac.uk:/vols/build/t2k/as16/MCMC_dir'
#alias sshfslx01='sshfs -C -o reconnect,ServerAliveInterval=15,ServerAliveCountMax=3,workaround=nodelaysrv /home/as16/lx01/ as16@lx01.hep.ph.ic.ac.uk:/vols/build/t2k/as16/mcmc'
#sshfs -C -o reconnect,ServerAliveInterval=16,ServerAliveCountMax=3,workaround=nodelaysrv /home/as16/lx01/ as16@lx01.hep.ph.ic.ac.uk:/vols/build/t2k/as16/mcmc

# TMUX ALIASES
alias tn = 'tmux new -s'
alias ta = 'tmux attach -t'
alias tl = 'tmux ls'

# TERMINAL HELPER ALIASES
alias whatterm = "ps -o 'cmd=' -p $(ps -o 'ppid=' -p $$)"
alias e        = "exit"
alias c        = "clear"

# LS ALIASES
alias ll = 'ls --color=auto -l -h'
alias la = 'ls --color=auto -l -a -h'

# TASK PRINTING ALIASES
alias tls  = "printTasks -f ~/WORK/TODO -t ls"
alias tadd = "printTasks -f ~/WORK/TODO -t add"
alias trm  = "printTasks -f ~/WORK/TODO -t rm"

# DIRECTORY ALIASES
alias sk    = 'cd /home/artur/WORK/SuperK'
alias vpnSK = 'cd /opt/cisco/anyconnect/bin'
alias hmcmc = 'cd /home/artur/WORK/T2K/HMCMC/DEV'


# MUTT ALIASES
alias m  = 'cd ~/.mutt/attachments_UCL && mutt -F ~/.mutt/UCL_muttrc'
alias mi = 'cd ~/.mutt/attachments && mutt -F ~/.mutt/ICL_muttrc'
alias mu = 'cd ~/.mutt/attachments_UCL && mutt -F ~/.mutt/UCL_muttrc'



# OTHER SOFTWARE ALIASES
alias zathura       = "zathura --fork"
alias google-chrome = 'google-chrome-stable'
alias vimtex        = "vim --servername vim"
alias im            = 'feh --scale-down --auto-zoom --magick-timeout 1'
alias battery       = 'cat /sys/class/power_supply/BAT0/capacity'



#export GTK_IM_MODULE=ibus
#export XMODIFIERS=@im=ibus
#export QT_IM_MODULE=ibus

#export GTK_IM_MODULE=fcitx
#export XMODIFIERS=@im=fcitx
#export QT_IM_MODULE=fcitx

# HELPER FUNCTIONS
function dateuk(){
  if [ -n "$1" ]; then
    echo -e "$(date --date='TZ="Europe/London" '$1)"
  else
    TZ='Europe/London' date
  fi
}

function dateph(){
  if [ -n "$1" ]; then
    echo -e "$(date --date='TZ="Asia/Manila" '$1)"
  else
    TZ='Asia/Manila' date
  fi
}

function datejp(){
  if [ -n "$1" ]; then
    echo -e "$(date --date='TZ="Asia/Tokyo" '$1)"
  else
    TZ='Asia/Tokyo' date
  fi
}

function dateus(){
  if [ -n "$1" ]; then
    echo -e "$(date --date='TZ="America/Chicago" '$1)"
  else
    TZ='America/Chicago' date
  fi
}

function dateeast(){
  if [ -n "$1" ]; then
    echo -e "$(date --date='TZ="America/New_York" '$1)"
  else
    TZ='America/New_York' date
  fi
}

function countdown(){
   date1=$((`date +%s` + $1)); 
   while [ "$date1" -ge `date +%s` ]; do 
     echo -ne "$(date -u --date @$(($date1 - `date +%s`)) +%H:%M:%S)\r";
     sleep 0.1
   done
   alsaloop -t 500000
}
function stopwatch(){
  date1=`date +%s`; 
   while true; do 
    echo -ne "$(date -u --date @$((`date +%s` - $date1)) +%H:%M:%S)\r"; 
    sleep 0.1
   done
}
