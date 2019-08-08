FROM ubuntu:xenial

MAINTAINER Yuto Uchimi <momosama1072@gmail.com>

RUN adduser --disabled-password --gecos "" user && \
    echo "user:password" | chpasswd && \
    usermod -aG sudo user

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update -qq && \
    apt-get dist-upgrade -qq -y

RUN apt-get update -qq && \
    apt-get install -qq -y \
        acpi \
        apt \
        apt-cacher-ng \
        apt-utils \
        aptitude \
        bc \
        ccache \
        cmake \
        cmake-curses-gui \
        cron \
        curl \
        emacs \
        git \
        hddtemp \
        htop \
        ibus-mozc \
        indicator-multiload \
        ipython \
        libboost-all-dev \
        libeigen3-dev \
        libflann-dev \
        libfreetype6-dev \
        libgnome2-bin \
        libnotify-bin \
        libqhull-dev \
        libvtk5-dev \
        lm-sensors \
        lsb-release \
        man-db \
        mesa-utils \
        mlocate \
        nkf \
        notify-osd \
        ntp \
        patch \
        pkg-config \
        python \
        python-dev \
        python-pip \
        python-setuptools \
        python-vtk \
        rlwrap \
        ssh \
        sudo \
        tcl-vtk \
        wget \
        xdg-user-dirs-gtk \
        xsel

RUN pip install -q -U "pip==9.0.3" setuptools

RUN pip install -q -U \
        chainer \
        flake8 \
        grip \
        hacking \
        "ipython<6" \
        "matplotlib<3" \
        numpy \
        percol

ENV HOME /home/user
ENV SHELL /bin/bash

RUN git clone https://github.com/YutoUchimi/dotfiles_public.git \
        /home/user/dotfiles_public && \
    /bin/bash /home/user/dotfiles_public/setup.sh && \
    chown -R user:user /home/user

USER user

CMD /bin/bash -c "cd $HOME && bash --login -c 'exec bash'"
