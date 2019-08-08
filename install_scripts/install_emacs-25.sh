#!/bin/sh

if [ $(which emacs25) ]; then
    echo "\n\033[01;36m[$(basename $0)] Successfully installed! Emacs 25 is already installed.\033[00m\n"
    notify-send -i gnome-terminal -t 3000 -u normal \
                "Successfully installed!" "Emacs 25 is already installed."
    exit 0
fi

set -x

sudo add-apt-repository -y ppa:kelleyk/emacs
sudo apt-get update
sudo apt-get install -y emacs25
sudo ln -sf $(which emacs25) $(which emacs)

set +x

if [ $(which emacs25) ]; then
    echo "\n\033[01;36m[$(basename $0)] Successfully installed!\033[00m\n"
    notify-send -i gnome-terminal -t 3000 -u normal \
                "Successfully installed!" "Emacs 25 in installed."
fi
