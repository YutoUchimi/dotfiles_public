#!/bin/sh

set -x
wget https://raw.githubusercontent.com/google/styleguide/gh-pages/cpplint/cpplint.py
mv cpplint.py $HOME/.local/bin/cpplint.py
chmod 755 $HOME/.local/bin/cpplint.py
set +x

if [ -f $HOME/.local/bin/cpplint.py ]; then
    echo "\n\033[01;36m[$(basename $0)] Successfully installed! cpplint.py is installed.\033[00m\n"
    notify-send -i gnome-terminal -t 3000 -u normal \
                "Successfully installed!" "cpplint.py is installed."
fi

set -x
REPOSITORY_PATH=$(echo $(cd $(dirname $0)/.. && pwd))
cp ${REPOSITORY_PATH}/.local/lib/flycheck-google-cpplint.el ${HOME}/.local/lib/flycheck-google-cpplint.el
set +x

if [ -f ${HOME}/.local/lib/flycheck-google-cpplint.el ]; then
    echo "\n\033[01;36m[$(basename $0)] Successfully installed! flycheck-google-cpplint.el is installed.\033[00m\n"
    notify-send -i gnome-terminal -t 3000 -u normal \
                "Successfully installed!" "flycheck-google-cpplint.el is installed."
fi
