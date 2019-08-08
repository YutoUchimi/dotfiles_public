#!/bin/sh


download_from_google_drive () {
    local FILE_ID=$1
    local FILE_NAME=$2

    if ( ! which curl > /dev/null ); then
        sudo apt-get update
        sudo apt-get install -y curl
    fi

    curl -sc /tmp/cookie \
         "https://drive.google.com/uc?export=download&id=${FILE_ID}" > /dev/null
    local CODE="$(awk '/_warning_/ {print $NF}' /tmp/cookie)"
    curl -Lb /tmp/cookie \
         "https://drive.google.com/uc?export=download&confirm=${CODE}&id=${FILE_ID}" \
         -o ${FILE_NAME}
}


install_cuda_9_2 () {
    cd $HOME
    mkdir -p $HOME/Downloads
    cd $HOME/Downloads

    local FILE_ID=19GRc9luGP09JtFPJ6QZYA4vIhkYzuj8C
    local FILE_NAME=cuda-repo-ubuntu1604_9.2.148-1_amd64.deb
    download_from_google_drive ${FILE_ID} ${FILE_NAME}

    sudo dpkg -i ${FILE_NAME}
    sudo apt-key adv --fetch-keys http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/7fa2af80.pub
    sudo apt-get update
    sudo apt-get install -y cuda-9-2
    cd -
}


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
cuda_version=$($(echo "nvcc -V") | sed -n 4p | cut -d ' ' -f 6)  # e.g. V9.2.148
cuda_version_float=$(echo "$cuda_version" | cut -d 'V' -f 2 | cut -d '.' -f -2)  # e.g. 9.2
set +x

if [ $(echo "$cuda_version_float == 9.2" | bc) -eq 1 ]; then
    echo "\n\033[01;36m[$(basename $0)] Successfully installed! CUDA 9.2 is already installed.\033[00m\n"
    notify-send -i gnome-terminal -t 3000 -u normal \
                "Successfully installed!" "CUDA 9.2 is already installed."
    exit 0
fi

set -x
install_cuda_9_2
set +x

echo "\n\033[01;36m[$(basename $0)] Successfully installed!\033[00m\n"
notify-send -i gnome-terminal -t 3000 -u normal \
        "Successfully installed!" "CUDA 9.2 is installed."
