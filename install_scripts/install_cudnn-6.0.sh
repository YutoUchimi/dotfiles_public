#!/bin/sh

set -x
ubuntu_version=$(cat /etc/lsb-release | sed -n 2p | cut -d '=' -f 2)
set +x

if [ $(echo "$ubuntu_version != 14.04" | bc) -eq 1 -a $(echo "$ubuntu_version != 16.04" | bc) -eq 1 ]; then
    echo "\n\033[01;31m[$(basename $0)] Invalid Ubuntu release! This script only supports: Ubuntu 14.04 or 16.04\033[00m\n"
    notify-send -i gnome-terminal -t 3000 -u normal \
                "Failed to install!" "Invalid Ubuntu release! This script only supports: Ubuntu 14.04 or 16.04"
    exit 1
fi

set -x
cuda_version=$(command nvcc --version | sed -n 4p | sed 's/.*, release .*, V\(.*\)/\1/')  # e.g. 8.0.61
cuda_version_float=$(echo "$cuda_version" | cut -d '.'-f -2)  # e.g. 8.0
set +x

if [ $(echo "$cuda_version != 8.0" | bc) -eq 1 ]; then
    echo "\n\033[01;31m[$(basename $0)] Invalid CUDA version! This script only supports: CUDA 8.0\033[00m\n"
    notify-send -i gnome-terminal -t 3000 -u normal \
                "Failed to install!" "Invalid CUDA version! This script only supports: CUDA 8.0"
    exit 1
fi

set -x

HERE=$(pwd)
mkdir -p $HOME/Downloads
cd $HOME/Downloads

wget https://developer.nvidia.com/compute/machine-learning/cudnn/secure/v6/prod/8.0_20170307/cudnn-8.0-linux-x64-v6.0-tgz

file="cudnn-8.0-linux-x64-v6.0.tgz"
if [ -e $file ]; then
    tar xfvz $file
    sudo cp -a cuda/include/cudnn.h /usr/local/cuda-8.0/include/
    sudo cp -a cuda/lib64/libcudnn* /usr/local/cuda-8.0/lib64/
    sudo chmod a+r /usr/local/cuda-8.0/lib64/libcudnn*
    set +x
    echo "\n\033[01;36m[$(basename $0)] Successfully installed!\033[00m\n"
    notify-send -i gnome-terminal -t 3000 -u normal \
                "Successfully installed!" "CUDNN 6.0 is installed."
else
    set +x
    echo "\n\033[01;31m[$(basename $0)] Could not download the designated archive file. Please download it to $HOME/Downloads/ manually.\033[00m"
    echo "\033[01;31m[$(basename $0)]   https://developer.nvidia.com/compute/machine-learning/cudnn/secure/v6/prod/8.0_20170307/cudnn-8.0-linux-x64-v6.0-tgz\033[00m\n"
    notify-send -i gnome-terminal -t 3000 -u normal \
                "Failed to install!" "Could not download the designated archive file. Please download it manually."
fi

set -x
cd $HERE
set +x
