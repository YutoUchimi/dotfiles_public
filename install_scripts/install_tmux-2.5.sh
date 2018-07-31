#!/bin/sh

set -x
tmux_version=$(tmux -V | cut -d " " -f 2)
set +x

if [ $(echo "$tmux_version == 2.5" | bc) -eq 1 ]; then
    echo "\n\033[01;36m[$(basename $0)] Successfully installed! tmux is already installed.\033[00m\n"
    notify-send -i gnome-terminal -t 3000 -u normal \
                "Successfully installed!" "tmux is already installed."
    exit 0
fi

if [ "$(uname)" != "Linux" ]; then
    echo "\n\033[01;31m[$(basename $0)] Unsupported platform: $(uname)\033[00m\n"
    notify-send -i gnome-terminal -t 3000 -u normal \
                "Failed to install!" "Unsupported platform: $(uname)"
    exit 1
fi

set -x
sudo -H apt-get install -qq -y libevent-dev libncurses-dev xsel

TMPDIR=$(mktemp -d)
cd $TMPDIR

VERSION=2.5
wget -q https://github.com/tmux/tmux/releases/download/${VERSION}/tmux-${VERSION}.tar.gz
tar zxf tmux-${VERSION}.tar.gz
cd tmux-${VERSION}

./configure --prefix=$HOME/.local
make -j
make install

rm -rf $TMPDIR

if [ $(which tmux) != $HOME/.local/bin/tmux ]; then
    echo "export PATH=$HOME/.local/bin:$PATH" >> $HOME/.bashrc
fi
set +x

if [ -f $HOME/.local/bin/tmux ]; then
    echo "\n\033[01;36m[$(basename $0)] Successfully installed! tmux is installed.\033[00m\n"
    notify-send -i gnome-terminal -t 3000 -u normal \
                "Successfully installed!" "tmux is installed."
fi
