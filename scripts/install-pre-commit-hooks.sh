#!/bin/bash

set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

echo -e "${GREEN}setting up pre-commit hook(s) in $(pwd | awk -F / '{ print $3; }')"

if [ ! -x "$(command -v pre-commit)" ]; then
    echo "####################################################################################"
    echo -e "${RED}pre-commit not found :(, installing via pip right meow!"
    echo "####################################################################################"
    pip install pre-commit --upgrade --user
    echo "########################################################################################"
    echo -e "${GREEN}pre-commit installed!!"
    echo "########################################################################################"
fi

echo "########################################################################################"
echo -e "${GREEN}try to upgrade pre-commit to the latest version!"
echo "########################################################################################"
pre-commit autoupdate
echo -e "${GREEN}pre-commit verion $(pre-commit --version | cut -d " " -f2)!"
echo "########################################################################################"

if grep --quiet hooksPath ~/.gitconfig; then
    echo -e "${RED}global hooksPath set, please remove to install pre-commit hook(s) in the $(pwd | awk -F / '{ print $3; }') repo!"
    exit 1
fi

echo "installing pre-commit hook in $(pwd | awk -F / '{ print $3; }') repo"
echo "########################################################################################"
pre-commit install && echo -en "${NC}"
