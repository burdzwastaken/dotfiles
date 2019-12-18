#!/bin/bash

#------------------------------------------------------------------------------
# File:   $HOME/dotfiles/firefox/install-firefox.sh
# Author: Matt Burdan <burdz@burdz.net>
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# install firefox
#------------------------------------------------------------------------------

echo 'downloading firefox tarball...'
curl -fSL -o firefox.tar.bz2 "https://download.mozilla.org/?product=firefox-latest-ssl&os=linux64&lang=en-US"
echo 'extracting to /opt'
sudo tar -C /opt -xvf firefox.tar.bz2
echo 'cleaning up...'
rm -rf firefox.tar.bz2
