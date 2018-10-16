#!/bin/sh

set -x

REPOSITORY_PATH=$(echo $(cd $(dirname $0) && pwd))

if [ -f ${HOME}/.bashrc ]; then
    mv ${HOME}/.bashrc ${HOME}/.bashrc.orig
fi

cp -r \
   ${REPOSITORY_PATH}/.Xmodmap \
   ${REPOSITORY_PATH}/.aspell.conf \
   ${REPOSITORY_PATH}/.bash_aliases \
   ${REPOSITORY_PATH}/.bashrc \
   ${REPOSITORY_PATH}/.emacs.d \
   ${REPOSITORY_PATH}/.gitignore_global \
   ${REPOSITORY_PATH}/.local \
   ${REPOSITORY_PATH}/.notify_time.sh \
   ${REPOSITORY_PATH}/.tmux.conf \
   $HOME

set +x
