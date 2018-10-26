#!/bin/sh

if [ `which google-chrome` ]; then
    echo "\n\033[01;36m[$(basename $0)] Successfully installed! Google Chrome is already installed.\033[00m\n"
    notify-send -i gnome-terminal -t 3000 -u normal \
                "Successfully installed!" "Google Chrome is already installed."
    exit 0
fi

set -x

HERE=$(pwd)
mkdir -p $HOME/Downloads
cd $HOME/Downloads

wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo dpkg -i google-chrome-stable_current_amd64.deb

cd $HERE

set +x

if [ `which google-chrome` ]; then
    echo "\n\033[01;36m[$(basename $0)] Successfully installed! Google Chrome is installed.\033[00m\n"
    notify-send -i gnome-terminal -t 3000 -u normal \
                "Successfully installed!" "Google Chrome is installed."
fi
