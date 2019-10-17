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

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"

# load default rvm profile
[[ -s "$HOME/.profile" ]] && source "$HOME/.profile"

# load RVM into the shell sessions *as a function*
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"
