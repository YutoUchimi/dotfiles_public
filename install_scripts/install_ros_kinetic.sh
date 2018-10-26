#!/bin/sh

if [ $ROS_DISTRO == "kinetic" ]; then
    echo "\n\033[01;36m[$(basename $0)] Successfully installed! ROS kinetic is already installed.\033[00m\n"
    notify-send -i gnome-terminal -t 3000 -u normal \
                "Successfully installed!" "ROS kinetic is already installed."
    exit 0
fi

set -x
ubuntu_version=$(cat /etc/lsb-release | sed -n 2p | cut -d '=' -f 2)
set +x

if [ $(echo "$ubuntu_version != 16.04" | bc) -eq 1 ]; then
    echo "\n\033[01;31m[$(basename $0)] Invalid Ubuntu release! This script only supports: Ubuntu 16.04\033[00m\n"
    notify-send -i gnome-terminal -t 3000 -u normal \
                "Failed to install!" "Invalid Ubuntu release! This script only supports: Ubuntu 16.04"
    exit 1
fi

set -x

sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
sudo apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net:80 --recv-key 421C365BD9FF1F717815A3895523BAEEB01FA116
sudo apt-get update
sudo apt-get install -y ros-kinetic-desktop-full
sudo apt-get install -y python-rosinstall python-rosinstall-generator python-wstool build-essential python-catkin-tools

sudo rosdep init
rosdep update

set +x

echo "\n\033[01;36m[$(basename $0)] Successfully installed!\033[00m\n"
echo "\n\033[01;36m[$(basename $0)]   Please re-source setup files: 'source /opt/ros/kinetic/setup.bash'\033[00m\n"
notify-send -i gnome-terminal -t 3000 -u normal \
            "Successfully installed!" "ROS kinetic is installed."
