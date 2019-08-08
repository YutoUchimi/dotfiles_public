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


install_cudnn_7_3_1 () {
    cd $HOME
    mkdir -p $HOME/Downloads
    cd $HOME/Downloads

    # Download libcudnn7
    local FILE0_ID=1kSIi7XPBsu63hpvxWlWdcHCGUw20lWmp
    local FILE0_NAME=libcudnn7_7.3.1.20-1+cuda9.2_amd64.deb
    download_from_google_drive ${FILE0_ID} ${FILE0_NAME}

    # Download libcudnn7-dev
    local FILE1_ID=13ral8_APskBMKSLyPNJbYmkJBAxr_g-D
    local FILE1_NAME=libcudnn7-dev_7.3.1.20-1+cuda9.2_amd64.deb
    download_from_google_drive ${FILE1_ID} ${FILE1_NAME}

    sudo dpkg -i ${FILE0_NAME}
    sudo dpkg -i ${FILE1_NAME}
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
cuda_version=$(command nvcc --version | sed -n 4p | sed 's/.*, release .*, V\(.*\)/\1/')  # e.g. 9.2.148
cuda_version_float=$(echo "$cuda_version" | cut -d '.'-f -2)  # e.g. 9.2
set +x

if [ $(echo "$cuda_version != 9.2" | bc) -eq 1 ]; then
    echo "\n\033[01;31m[$(basename $0)] Invalid CUDA version! This script only supports: CUDA 9.2\033[00m\n"
    notify-send -i gnome-terminal -t 3000 -u normal \
                "Failed to install!" "Invalid CUDA version! This script only supports: CUDA 9.2"
    exit 1
fi

set -x
install_cudnn_7_3_1
set +x

echo "\n\033[01;36m[$(basename $0)] Successfully installed!\033[00m\n"
notify-send -i gnome-terminal -t 3000 -u normal \
            "Successfully installed!" "CUDNN 7.0 is installed."
