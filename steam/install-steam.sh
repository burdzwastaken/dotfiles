#!/bin/bash

#------------------------------------------------------------------------------
# File:   $HOME/dotfiles/steam/install-steam.sh
# Author: Matt Burdan <burdz@burdz.net>
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# install steam
#------------------------------------------------------------------------------

set -euxo pipefail

nonfree() {
    if [ ! -f /etc/apt/sources.list.d/non-free.list ]; then
        echo "deb http://httpredir.debian.org/debian/ $(lsb_release -cs) main contrib non-free" | sudo tee /etc/apt/sources.list.d/non-free.list
    fi
}

multi-arch() {
    # enable multi-arch
    sudo dpkg --add-architecture i386
}

update() {
    sh -c 'sudo apt update -y'
}

upgrade() {
    sh -c 'sudo apt upgrade -y'
}

install() {
    sh -c 'sudo apt install -y steam'
}

nonfree
multi-arch
update
upgrade
install
