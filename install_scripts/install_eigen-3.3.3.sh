#!/bin/sh

if [ -f /usr/local/include/eigen3/Eigen/Core ]; then
    echo "\n\033[01;36m[$(basename $0)] Successfully installed! Eigen3 is already installed.\033[00m\n"
    notify-send -i gnome-terminal -t 3000 -u normal \
                "Successfully installed!" "Eigen3 is already installed."
else
    set -x

    HERE=$(pwd)
    mkdir -p $HOME/Downloads
    cd $HOME/Downloads

    wget bitbucket.org/eigen/eigen/get/3.3.3.tar.gz
    tar zxf 3.3.3.tar.gz
    cd eigen-eigen-67e894c6cd8f
    mkdir build
    cd build
    cmake ..
    sudo make install

    cd $HERE
    rm $HOME/Downloads/3.3.3.tar.gz
    rm -rf $HOME/Downloads/eigen-eigen-67e894c6cd8f

    set +x

    if [ -f /usr/local/include/eigen3/Eigen/Core ]; then
        echo "\n\033[01;36m[$(basename $0)] Successfully installed!\033[00m\n"
        notify-send -i gnome-terminal -t 3000 -u normal \
                    "Successfully installed!" "Eigen3 is installed."
    fi
fi
