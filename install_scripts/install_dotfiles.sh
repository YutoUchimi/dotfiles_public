#!/bin/sh

set -x

REPOSITORY_PATH=$HOME/dotfiles_public

cp -r \
   ${REPOSITORY_PATH}/.Xmodmap \
   ${REPOSITORY_PATH}/.aspell.conf \
   ${REPOSITORY_PATH}/.bash_aliases \
   ${REPOSITORY_PATH}/.bashrc \
   ${REPOSITORY_PATH}/.crontab \
   ${REPOSITORY_PATH}/.emacs.d \
   ${REPOSITORY_PATH}/.gitconfig \
   ${REPOSITORY_PATH}/.gitignore_global \
   ${REPOSITORY_PATH}/.gpu_checker.cfg \
   ${REPOSITORY_PATH}/.local \
   ${REPOSITORY_PATH}/.notify_time.sh \
   ${REPOSITORY_PATH}/.tmux.conf \
   $HOME

cp -r \
   ${REPOSITORY_PATH}/usr \
   /usr

set +x
