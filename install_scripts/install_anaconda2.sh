#!/bin/sh

if [ -e ~/.anaconda2 ]; then
  echo "\n\033[01;36m[$(basename $0)] anaconda is already installed.\033[00m\n"
  notify-send -i gnome-terminal -t 3000 -u normal \
              "Successfully installed!" "anaconda is already installed."
  exit 0
fi

set -x

cd $(mktemp -d)

if [ "$(uname)" = "Linux" ]; then
  wget -q 'https://repo.continuum.io/miniconda/Miniconda2-latest-Linux-x86_64.sh'
  bash ./Miniconda2-latest-Linux-x86_64.sh -p $HOME/.anaconda2 -b
elif [ "$(uname)" = "Darwin" ]; then
  wget -q 'https://repo.continuum.io/miniconda/Miniconda2-latest-MacOSX-x86_64.sh'
  bash ./Miniconda2-latest-MacOSX-x86_64.sh -p $HOME/.anaconda2 -b
else
  echo "\n\033[01;31m[$(basename $0)] Unsupported platform: $(uname)\033[00m\n"
  notify-send -i gnome-terminal -t 3000 -u normal \
              "Failed to install!" "Unsupported platform: $(uname)"
  exit 1
fi

set +x

if [ -e ~/.anaconda2 ]; then
  echo "\n\033[01;36m[$(basename $0)] Successfully installed!\033\00m\n"
  notify-send -i gnome-terminal -t 3000 -u normal \
              "Successfully installed!" "anaconda is installed."
fi
