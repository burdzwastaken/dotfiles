#!/bin/bash

#------------------------------------------------------------------------------
# File:   $HOME/dotfiles/scripts/install-pre-commit-hooks.sh
# Author: Matt Burdan <burdz@burdz.net>
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# sweet hookz
#------------------------------------------------------------------------------

set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

echo -e "${GREEN}setting up pre-commit hook(s) in $(pwd | awk -F / '{ print $3; }')"

if [ ! -x "$(command -v pre-commit)" ]; then
    echo -e "${RED}pre-commit not found :(, installing via pip right meow!"
    pip install pre-commit --upgrade --user
    echo -e "${GREEN}pre-commit installed!!"
fi

echo -e "${GREEN}try to upgrade pre-commit to the latest version!"
pre-commit autoupdate
echo -e "${GREEN}pre-commit verion $(pre-commit --version | cut -d " " -f2)!"

if grep --quiet hooksPath ~/.gitconfig; then
    echo -e "${RED}global hooksPath set, please remove to install pre-commit hook(s) in the $(pwd | awk -F / '{ print $3; }') repo!"
    exit 1
fi

echo "installing pre-commit hook in $(pwd | awk -F / '{ print $3; }') repo"
pre-commit install && echo -en "${NC}"
