#!/usr/bin/env bash
#------------------------------------------------------------------------------
## File:   $HOME/.bash_profile
## Author: Matt Burdan <burdz@burdz.net>
##------------------------------------------------------------------------------
#
##------------------------------------------------------------------------------
## Settings.
##------------------------------------------------------------------------------

# python
source "$HOME"/.local/bin/virtualenvwrapper.sh

# golang
export PATH=~/.local/bin:$PATH
export PATH=~/go/bin/:$PATH
export PATH=/usr/local/go/bin/:$PATH

# default editor
export VISUAL=vim
export EDITOR="$VISUAL"

# less with more
# from: https://wiki.archlinux.org/index.php/Color_output_in_console#man
export LESS_TERMCAP_mb=$'\e[1;32m'
export LESS_TERMCAP_md=$'\e[1;32m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_so=$'\e[01;33m'
export LESS_TERMCAP_ue=$'\e[0m'
export LESS_TERMCAP_us=$'\e[1;4;31m'

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"

# load default rvm profile
[[ -s "$HOME/.profile" ]] && source "$HOME/.profile"

# load RVM into the shell sessions *as a function*
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"
