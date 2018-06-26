#!/bin/sh

set -x
wget https://raw.githubusercontent.com/google/styleguide/gh-pages/cpplint/cpplint.py
sudo mv cpplint.py /usr/local/bin/cpplint.py
sudo chmod 755 /usr/local/bin/cpplint.py
set +x

if [ -f /usr/local/bin/cpplint.py ]; then
    echo "\n\033[01;36m[$(basename $0)] Successfully installed! cpplint.py is installed.\033[00m\n"
    notify-send -i gnome-terminal -t 3000 -u normal \
                "Successfully installed!" "cpplint.py is installed."
fi

set -x
sudo cp $HOME/dotfiles/usr/local/bin/flycheck-google-cpplint.el /usr/local/bin/flycheck-google-cpplint.el
set +x

if [ -f /usr/local/bin/flycheck-google-cpplint.el ]; then
    echo "\n\033[01;36m[$(basename $0)] Successfully installed! flycheck-google-cpplint.el is installed.\033[00m\n"
    notify-send -i gnome-terminal -t 3000 -u normal \
                "Successfully installed!" "flycheck-google-cpplint.el is installed."
fi
