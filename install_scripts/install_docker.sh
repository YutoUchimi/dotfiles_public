#!/bin/sh

if [ `which docker` ]; then
    echo "\n\033[01;36m[$(basename $0)] Successfully installed! docker is already installed.\033[00m\n"
    notify-send -i gnome-terminal -t 3000 -u normal \
                "Successfully installed!" "docker is already installed."
    exit 0
fi

set -x

HERE=$(pwd)
mkdir -p $HOME/Downloads
cd $HOME/Downloads

curl -fsSL get.docker.com -o get-docker.sh
sh get-docker.sh
sudo usermod -aG docker $USER

cd $HERE

set +x

if [ `which docker` ]; then
    echo "\n\033[01;36m[$(basename $0)] Successfully installed! In order to use docker, please reboot computer.\033[00m\n"
    notify-send -i gnome-terminal -t 3000 -u normal \
                "Successfully installed!" "In order to use docker, please reboot computer."
fi
