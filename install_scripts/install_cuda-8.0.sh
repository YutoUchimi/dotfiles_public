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
cuda_version=$($(echo "nvcc -V") | sed -n 4p | cut -d ' ' -f 6)  # e.g. V8.0.61
cuda_version_float=$(echo "$cuda_version" | cut -d 'V' -f 2 | cut -d '.' -f -2)  # e.g. 8.0
set +x

if [ $(echo "$cuda_version_float == 8.0" | bc) -eq 1 ]; then
    echo "\n\033[01;36m[$(basename $0)] Successfully installed! CUDA 8.0 is already installed.\033[00m\n"
    notify-send -i gnome-terminal -t 3000 -u normal \
                "Successfully installed!" "CUDA 8.0 is already installed."
    exit 0
fi

set -x

HERE=$(pwd)
mkdir -p $HOME/Downloads
cd $HOME/Downloads

if [ $(echo "$ubuntu_version == 14.04" | bc) -eq 1 ]; then
    src_fname=cuda-repo-ubuntu1404-8-0-local-ga2_8.0.61-1_amd64-deb
    dst_fname=cuda-repo-ubuntu1404-8-0-local-ga2_8.0.61-1_amd64.deb
elif [ $(echo "$ubuntu_version == 16.04" | bc) -eq 1 ]; then
    src_fname=cuda-repo-ubuntu1604-8-0-local-ga2_8.0.61-1_amd64-deb
    dst_fname=cuda-repo-ubuntu1604-8-0-local-ga2_8.0.61-1_amd64.deb
fi

wget https://developer.nvidia.com/compute/cuda/8.0/Prod2/local_installers/$src_fname
mv $src_fname $dst_fname
sudo dpkg -i $dst_fname
sudo apt-get update
sudo apt-get install -y cuda

set +x

echo "\n\033[01;36m[$(basename $0)] Successfully installed!\033[00m\n"
notify-send -i gnome-terminal -t 3000 -u normal \
        "Successfully installed!" "CUDA 8.0 is installed."

set -x
cd $HERE
rm $HOME/Downloads/$dst_fname
set +x
