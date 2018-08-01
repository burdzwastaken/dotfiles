#------------------------------------------------------------------------------
# File:   $HOME/.bashrc
# Author: Matt Burdan <burdz@burdz.net>
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# Settings.
#------------------------------------------------------------------------------

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=10000
HISTFILESIZE=20000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# autocorrect cd mistakes
shopt -s cdspell

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# if this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# alias definitions.
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# function definitions
if [ -f ~/.bash_functions ]; then
    . ~/.bash_functions
fi

# enable programmable completion features
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# colours for terminal https://github.com/Anthony25/gnome-terminal-colors-solarized
if [ -f ~/.dir_colors/dircolors ]
    then eval `dircolors ~/.dir_colors/dircolors`
fi

# git-status
source ~/.git-status.bash

# kubectl completion
source <(kubectl completion bash)

# hub completion
if [ -f /etc/hub.bash_completion ]; then
  . /etc/hub.bash_completion
fi

# TmuxLine
vim +TmuxLine +qall

# invoke ssh-agent
if [ -z "$SSH_AUTH_SOCK" ] ; then
  eval `ssh-agent -s`
  ssh-add
fi

# few colours
BLACK='\e[0;30m'
BLUE='\e[0;34m'
GREEN='\e[0;32m'
CYAN='\e[0;36m'
RED='\e[0;31m'
PURPLE='\e[0;35m'
BROWN='\e[0;33m'
LIGHTGRAY='\e[0;37m'
DARKGRAY='\e[1;30m'
LIGHTBLUE='\e[1;34m'
LIGHTGREEN='\e[1;32m'
LIGHTRED='\e[1;31m'
LIGHTPURPLE='\e[1;35m'
YELLOW='\e[1;33m'
WHITE='\e[1;37m'
NC='\e[0m' # no color

# welcome burdz

echo -ne "${LIGHTGREEN}""Hello, $USER. today is, "; date
echo -e "${LIGHTGREEN}"; cal ;
echo -e "publicIP: $(shodan myip)" ;
echo -e "internalwiredIP: $(ip addr show enxac7f3ee606da | grep -Po 'inet \K[\d.]+')" ;
echo -e "internalwirelessIP: $(ip addr show wlp4s0 | grep -Po 'inet \K[\d.]+')" ;
echo -e "${LIGHTGREEN}"; uname -a ;
echo ""
