#!/bin/bash

#------------------------------------------------------------------------------
# File:   $HOME/dotfiles/vim/compile-vim-python3.sh
# Author: Matt Burdan <burdz@burdz.net>
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# compile vim
#------------------------------------------------------------------------------
# lua:
# sudo cp /usr/include/lua5.3/ /usr/include/lua5.3/include/
# sudo ln -s /usr/lib/x86_64-linux-gnu/liblua5.3.so /usr/local/lib/liblua.so

(
  git clone https://github.com/vim/vim.git
  cd vim/src/ || exit

  sudo apt-get install -y \
      python-dev \
      python3-dev \
      liblua5.3-dev \
      libperl-dev \
      ruby \
      ruby-dev \
      libx11-dev \
      libxt-dev \
      libgtk2.0-dev \
      libncurses5 \
      ncurses-dev

  ./configure \
      --enable-cscope \
      --enable-perlinterp \
      --enable-rubyinterp \
      --enable-python3interp \
      --with-python3-config-dir=/usr/lib/python3.7/config-3.7m-x86_64-linux-gnu \
      --enable-luainterp \
      --with-lua-prefix=/usr/include/lua5.3 \
      --enable-multibyte \
      --with-features=huge \
      --enable-largefile \
      --disable-netbeans \
      --with-x \
      --with-compiledby="burdz@burdz.net" \
      --prefix=/usr/local \
      --enable-gui=auto \
      --enable-fontset

  make VIMRUNTIMEDIR=/usr/share/vim/vim81
  ./vim --version
)
