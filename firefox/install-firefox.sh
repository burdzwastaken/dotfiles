#!/bin/bash

#------------------------------------------------------------------------------
# File:   $HOME/dotfiles/firefox/install-firefox.sh
# Author: Matt Burdan <burdz@burdz.net>
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# install firefox
#------------------------------------------------------------------------------

curl -fsSL -o firefox.tar.bz2 "https://download.mozilla.org/?product=firefox-latest-ssl&os=linux64&lang=en-US"
sudo tar -C /opt -xvf firefox.tar.bz2
rm -rf firefox.tar.bz2
