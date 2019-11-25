#!/bin/bash

#------------------------------------------------------------------------------
# File:   $HOME/dotfiles/vim/compile-vim-python3.sh
# Author: Matt Burdan <burdz@burdz.net>
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# compile vim
#------------------------------------------------------------------------------

(
  git clone https://github.com/vim/vim.git
  cd vim/src/ || exit

  sudo apt-get install -y \
      python-dev \
      python3-dev \
      ruby \
      ruby-dev \
      libx11-dev \
      libxt-dev \
      libgtk2.0-dev \
      libncurses5 \
      ncurses-dev

  ./configure \
      --enable-perlinterp \
      --enable-python3interp \
      --enable-rubyinterp \
      --enable-cscope \
      --enable-gui=auto \
      --enable-gtk2-check \
      --enable-gnome-check \
      --with-features=huge \
      --enable-multibyte \
      --with-x \
      --with-compiledby="burdz@burdz.net" \
      --with-python3-config-dir=/usr/lib/python3.7/config-3.7m-x86_64-linux-gnu \
      --prefix=/usr/local

  make VIMRUNTIMEDIR=/usr/share/vim/vim81
  ./vim --version
)
