#!/bin/bash

#------------------------------------------------------------------------------
# File:   $HOME/dotfiles/hack/prepare.sh
# Author: Matt Burdan <burdz@burdz.net>
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# prepz
#------------------------------------------------------------------------------

set -euxo pipefail

update() {
    apt update -y
}

deps() {
    apt install -y \
        sudo \
        git \
        lsb-release
}

sudoers() {
    echo "burdz ALL=(ALL:ALL) ALL" > /etc/sudoers.d/burdz
}

update
deps
sudoers
