#!/bin/sh

sh $HOME/dotfiles/install_scripts/install_emacs-24.4.sh

set -x
sudo -H pip install epc jedi virtualenv
set +x

if [ -e $(sudo -H pip show jedi | grep Location | cut -d " " -f 2) ]; then
    echo "\n\033[01;36m[$(basename $0)] Sucessfully installed!\033[00m\n"
    notify-send -i gnome-terminal -t 3000 -u normal \
                "Successfully installed!" "jedi is installed."
fi
