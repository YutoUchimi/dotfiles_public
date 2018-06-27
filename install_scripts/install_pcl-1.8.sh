#!/bin/sh

if [ -e /usr/local/include/pcl-1.8/pcl/pcl_base.h ]; then
    echo "\n\033[01;36m[$(basename $0)] PCL 1.8 is already installed.\033[00m\n"
    notify-send -i gnome-terminal -t 3000 -u normal \
                "Successfully installed!" "PCL 1.8 is already installed."
    exit 0

else
    if [ $(which deactivate) ]; then
        source $(which deactivate)
    fi

    set -x

    sudo apt-get install -y libboost-all-dev
    sudo apt-get install -y libeigen3-dev=3.2.0-8
    sudo apt-get install -y libusb-1.0-0-dev libudev-dev openjdk-6-jdk freeglut3-dev doxygen graphviz
    sudo apt-get install -y libvtk-java libvtk5-dev libvtk5-qt4-dev libvtk5.8 libvtk5.8-qt4 python-vtk tcl-vtk
    sudo apt-get install -y libflann-dev
    sudo apt-get install -y libpcap-dev
    sudo apt-get install -y libqhull-dev
    sudo apt-get install -y libopenni-dev
    sudo updatedb

    HERE=$(pwd)
    mkdir -p $HOME/Downloads
    cd $HOME/Downloads
    version="1.8.0rc2"
    url="https://github.com/PointCloudLibrary/pcl/archive/pcl-${version}.tar.gz"
    fname=pcl-${version}.tar.gz
    wget $url -O $fname
    tar zxf $fname

    cd pcl-pcl-${version}

    mkdir build
    cd build

    cmake .. -DBUILD_GPU:=ON -DBUILD_visualization:=ON -DCMAKE_INSTALL_PREFIX:=/usr/local
    make -j
    sudo ln -s /usr/local/cuda/lib64/libcudart.so /usr/lib/libcudart.so
    sudo make -j install

    # For some reason, not all build were executed in the first time
    cmake .. -DBUILD_GPU:=ON -DBUILD_visualization:=ON -DCMAKE_INSTALL_PREFIX:=/usr/local
    make -j
    sudo make -j install

    cd $HERE
    rm $HOME/Downloads/$fname

    set +x
fi

if [ -e /usr/local/include/pcl-1.8/pcl/pcl_base.h ]; then
    echo "\n\033[01;36m[$(basename $0)] Successfully installed!\033[00m\n"
    notify-send -i gnome-terminal -t 3000 -u normal \
                "Successfully installed!" "PCL 1.8 is installed."
fi
