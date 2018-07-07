#!/bin/sh

set -x

emacs_version=$($(echo "emacs --version") | head -n1 | cut -d " " -f 3)  # e.g. 24.4.2
emacs_version_float=$(echo "$emacs_version" | cut -d '.' -f -2)  # e.g. 24.4

set +x

if [ $(echo "$emacs_version_float >= 24.4" | bc) -eq 1 ]; then
    echo "\n\033[01;36m[$(basename $0)] Successfully installed! emacs >= 24.4 is already installed.\033[00m\n"
    notify-send -i gnome-terminal -t 3000 -u normal \
                "Successfully installed!" "emacs >= 24.4 is already installed."
else
    set -x

    HERE=$(pwd)
    sudo apt-get purge emacs
    sudo apt-get install -y build-essential
    sudo apt-get build-dep emacs24

    mkdir -p $HOME/Downloads
    cd $HOME/Downloads

    wget ftp://ftp-osl.osuosl.org/pub/libpng/src/libpng16/libpng-1.6.34.tar.gz
    tar -xvf libpng-1.6.34.tar.gz
    cd libpng-1.6.34
    ./configure
    make check
    sudo make install
    sudo ldconfig

    cd $HOME/Downloads

    wget http://ftp.gnu.org/gnu/emacs/emacs-24.4.tar.gz
    tar -xvf emacs-24.4.tar.gz
    cd emacs-24.4
    ./configure
    make -j
    sudo make install

    cd $HERE
    rm -rf $HOME/Downloads/libpng-1.6.34.tar.gz
    rm -rf $HOME/Downloads/emacs-24.4.tar.gz

    set +x

    if [ -f /usr/local/bin/emacs ]; then
        echo "\n\033[01;36m[$(basename $0)] Successfully installed! In order to use emacs 24.4, please reboot computer.\033[00m\n"
        notify-send -i gnome-terminal -t 3000 -u normal \
                    "Successfully installed!" "In order to use emacs 24.4, please reboot computer."
    fi
fi
