#!/bin/sh

set -x

REPOSITORY_PATH=$HOME/dotfiles_public

mv $HOME/.bashrc $HOME/.bashrc.orig

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
