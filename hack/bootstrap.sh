#!/bin/bash

#------------------------------------------------------------------------------
# File:   $HOME/dotfiles/hack/bootstrap.sh
# Author: Matt Burdan <burdz@burdz.net>
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# bootstrapz
#------------------------------------------------------------------------------

set -euxo pipefail

ignore-errors() {
    set +e
    $1
    set -e
}

env() {
    GO_VERSION=1.10.2
    DROPBOX_VERSION=2015.10.28
    MINIKUBE_VERSION=0.26.1
    SLACK_VERSION=3.1.0
    HUB_VERSION=2.2.9
    BAT_VERSION=0.3.0
    export DEBIAN_FRONTEND=noninteractive
}

deps() {
    sudo apt install -y \
        apt-transport-https \
        curl \
        dirmngr
}

repos() {
    echo "deb http://httpredir.debian.org/debian/ $(lsb_release -cs) main contrib non-free" | sudo tee /etc/apt/sources.list.d/non-free.list
    echo "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list
    echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
    echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" | sudo tee /etc/apt/sources.list.d/google-chrome.list
    echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" | sudo tee /etc/apt/sources.list.d/vscode.list
    echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
    echo "deb [arch=amd64] https://osquery-packages.s3.amazonaws.com/deb deb main" | sudo tee /etc/apt/sources.list.d/osquery.list
    echo "deb http://packages.cloud.google.com/apt cloud-sdk-$(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/google-cloud-sdk.list
    echo "deb http://download.virtualbox.org/virtualbox/debian $(lsb_release -cs) contrib" | sudo tee /etc/apt/sources.list.d/virtualbox.list
    echo "deb http://download.draios.com/stable/deb stable-amd64/" | sudo tee /etc/apt/sources.list.d/draios.list
    echo "deb [arch=amd64] https://updates.signal.org/desktop/apt xenial main" | sudo tee /etc/apt/sources.list.d/signal-xenial.list
}

repos-gpg() {
    curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add - #docker
    curl -fsSL https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add - #sublime
    curl -fsSL https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add - #google-chrome
    curl -fsSL https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add - #vscode
    curl -fsSL https://www.virtualbox.org/download/oracle_vbox_2016.asc | sudo apt-key add - #virtualbox
    curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add - #gcloud-sdk
    curl -fsSL https://s3.amazonaws.com/download.draios.com/DRAIOS-GPG-KEY.public | sudo apt-key add - #sysdig
    curl -fsSL https://updates.signal.org/desktop/apt/keys.asc | sudo apt-key add - #signal
    sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys BBEBDCB318AD50EC6865090613B00F1FD2C19886 0DF731E45CE24F27EEEB1450EFDC8610341D9410 #spotify
    sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 1484120AC4E9F8A1A577AEEE97A80C63C9D8B80B #osquery
    sudo apt-key adv --keyserver hkp://pgp.mit.edu:80 --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB #rvm
}

update() {
    sh -c 'sudo apt update -y'
}

upgrade() {
    sh -c 'sudo apt upgrade -y'
}

packages() {
    sudo apt install -y \
        ca-certificates \
        wget \
        software-properties-common \
        tmux \
        vim \
        htop \
        hexchat \
        git \
        jq \
        conky \
        keepassx \
        vlc \
        browser-plugin-vlc \
        xclip \
        python \
        python-pip \
        sl \
        tcpdump \
        libc++1 \
        zeal \
        firmware-iwlwifi \
        docker-ce \
        sublime-text \
        google-chrome-stable \
        code \
        osquery \
        virtualbox-5.1 \
        google-cloud-sdk \
        sysdig \
        rkhunter \
        chkrootkit \
        nethogs \
        ntp \
        dnsutils \
        nmap \
        gir1.2-gtop-2.0 \
        gir1.2-networkmanager-1.0 \
        gir1.2-clutter-1.0 \
        signal-desktop \
        tree \
        exiftool \
        whois \
        uuid-runtime \
        asciinema \
        clusterssh \
        chromium \
        blueman \
        shellcheck \
        qemu
    sudo apt -f install -y

    if [ -z "$IN_DOCKER" ]; then
        sudo apt install -y \
            wireshark \
            tor
    fi
}

aws-cli() {
    pip install awscli --upgrade --user
}

virtualenvwrapper() {
    pip install virtualenvwrapper --upgrade --user
}

kernel-modules() {
    if [ -z "$IN_DOCKER" ]; then
        sudo modprobe -r iwlwifi && sudo modprobe iwlwifi
    fi
}

conf() {
    mkdir ~/.config
    ln -sf "$(pwd)"/bash/.bashrc ~/.bashrc
    ln -sf "$(pwd)"/bash/.bash_profile ~/.bash_profile
    ln -sf "$(pwd)"/conky/.conkyrc ~/.conkyrc
    ln -sf "$(pwd)"/curl/.curlrc ~/.curlrc
    ln -sf "$(pwd)"/editor/.editorconfig ~/.editorconfig
    ln -sf "$(pwd)"/git/.gitconfig ~/.gitconfig
    ln -sf "$(pwd)"/gitstatus/.git-status.bash ~/.git-status.bash
    mkdir ~/.config/hexchat && ln -sf "$(pwd)"/hexchat/hexchat.conf ~/.config/hexchat/hexchat.conf
    ln -sf "$(pwd)"/hexchat/servlist.conf ~/.config/hexchat/servlist.conf
    ln -sf "$(pwd)"/ssh/.config ~/.ssh/config
    ln -sf "$(pwd)"/tmux/.tmux.conf ~/.tmux.conf
    ln -sf "$(pwd)"/vim/.vimrc ~/.vimrc
    ln -sf "$(pwd)"/wget/.wgetrc ~/.wgetrc
    ln -sf "$(pwd)"/netrc/.netrc ~/.netrc
    mkdir ~/.gnupg && ln -sf "$(pwd)"/gnupg/gpg-agent.conf ~/.gnupg/gpg-agent.conf

    if [ "$IN_DOCKER" == "true" ]; then                                                                                                                                                                        
        rm -rf ~/.gitconfig                                                                            
    fi
}

bin() {
    ln -sf "$(pwd)"/bin/tat /usr/local/bin/tat
}

tmux-plugins() {
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
}

colours() {
    git clone https://github.com/Anthony25/gnome-terminal-colors-solarized.git
    if [ -z "$IN_DOCKER" ]; then
        pushd gnome-terminal-colors-solarized/
            ./install.sh --scheme=dark --install-dircolors
        popd
    fi
    rm -rfd gnome-terminal-colors-solarized/
}

dropbox() {
    curl -fsSL -o dropbox_${DROPBOX_VERSION}_amd64.deb "https://www.dropbox.com/download?dl=packages/debian/dropbox_${DROPBOX_VERSION}_amd64.deb"
    sudo dpkg -i dropbox_${DROPBOX_VERSION}_amd64.deb
    sudo apt -f install -y
    rm -rf dropbox_${DROPBOX_VERSION}_amd64.deb
}

golang() {
    curl -fsSL -o go${GO_VERSION}.linux-amd64.tar.gz "https://storage.googleapis.com/golang/go${GO_VERSION}.linux-amd64.tar.gz"
    sudo tar -C /usr/local -xzf go${GO_VERSION}.linux-amd64.tar.gz
    rm -rf go${GO_VERSION}.linux-amd64.tar.gz
}

keybase() {
    curl -fsSL -o keybase_amd64.deb "https://prerelease.keybase.io/keybase_amd64.deb"
    sudo dpkg -i keybase_amd64.deb
    sudo apt -f install -y
    rm -rf keybase_amd64.deb
}

kubectl() {
    curl -fsSL -o kubectl "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl"
    chmod +x ./kubectl
    sudo mv ./kubectl /usr/local/bin/kubectl
}

minikube() {
    curl -fsSL -o minikube "https://storage.googleapis.com/minikube/releases/v${MINIKUBE_VERSION}/minikube-linux-amd64"
    chmod +x ./minikube
    sudo mv ./minikube /usr/local/bin/minikube
}

spotify() {
    curl -fsSL -o libssl1.0.0 "http://ftp.us.debian.org/debian/pool/main/o/openssl/libssl1.0.0_1.0.1t-1+deb8u7_amd64.deb"
    sudo dpkg -i libssl1.0.0
    rm -rf libssl1.0.0
    sudo apt install -y spotify-client
}

slack() {
    curl -fsSL -o slack-desktop-${SLACK_VERSION}-amd64.deb "https://downloads.slack-edge.com/linux_releases/slack-desktop-${SLACK_VERSION}-amd64.deb"
    sudo dpkg -i slack-desktop-${SLACK_VERSION}-amd64.deb
    sudo apt -f install -y
    rm -rf slack-desktop-${SLACK_VERSION}-amd64.deb
}

shodan() {
    pip install shodan --upgrade --user
}

yq() {
    pip install yq --upgrade --user
}

rvm() {
    curl -fsSL https://get.rvm.io | bash
}

discord() {
    curl -fsSL -o discord.deb "https://discordapp.com/api/download?platform=linux&format=deb"
    sudo dpkg -i discord.deb
    sudo apt -f install -y
    rm -rf discord.deb
}

vim-plugins() {
    git clone https://github.com/burdzwastaken/vim-colors-solarized.git
    mkdir -p ~/.vim/colors && mv vim-colors-solarized/colors/solarized.vim ~/.vim/colors/

    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

    if [ -z "$IN_DOCKER" ]; then
        vim +PluginInstall +qall
    fi
}

fzf() {
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    true | ~/.fzf/install
}

hub() {
    curl -fsSL -o hub-${HUB_VERSION}.tgz "https://github.com/github/hub/releases/download/v${HUB_VERSION}/hub-linux-amd64-${HUB_VERSION}.tgz"
    tar -zxvf hub-${HUB_VERSION}.tgz
    sudo cp hub-linux-amd64-${HUB_VERSION}/bin/hub /usr/local/bin/
    sudo cp hub-linux-amd64-${HUB_VERSION}/etc/hub.bash_completion.sh /etc/hub.bash_completion
    sudo rm -rf hub-*
}

bat() {
    curl -fsSL -o bat.deb "https://github.com/sharkdp/bat/releases/download/v${BAT_VERSION}/bat-musl_${BAT_VERSION}_amd64.deb"
    sudo dpkg -i bat.deb
    rm -rf bat.deb
}

gc-hooks() {
    sudo mkdir -p /etc/git/hooks
}

wallpaper() {
    sudo mkdir -p /usr/share/backgrounds/debian
    sudo chown burdz:burdz -R /usr/share/backgrounds/debian
    ln -sf "$(pwd)"/images/linux-debian-wallpaper.jpg /usr/share/backgrounds/debian/linux-debian-wallpaper.jpg
    ln -sf "$(pwd)"/images/linux-debian-metal-wallpaper.jpg /usr/share/backgrounds/debian/linux-debian-metal-wallpaper.jpg
    ln -sf "$(pwd)"/images/linux-debian-high-res-wallpaper.jpg /usr/share/backgrounds/debian/linux-debian-high-res-wallpaper.jpg
}

autoremove() {
    sh -c 'sudo apt autoremove -y'
}

env
deps
repos
repos-gpg
update
upgrade
packages
aws-cli
virtualenvwrapper
tmux-plugins
kernel-modules
conf
bin
colours
ignore-errors dropbox
golang
ignore-errors keybase
kubectl
minikube
spotify
ignore-errors slack
shodan
yq
rvm
ignore-errors discord
vim-plugins
fzf
hub
bat
gc-hooks
wallpaper
autoremove
