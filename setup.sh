#!/bin/sh

set_cmd_for_sudo () {
    if [ $(whoami) = 'root' ]; then
        service_cmd='service'
        tee_cmd='tee'
        touch_cmd='touch'
    else
        service_cmd='sudo service'
        tee_cmd='sudo tee'
        touch_cmd='sudo touch'
    fi
}


copy_dotfiles () {
    REPOSITORY_PATH=$(echo $(cd $(dirname $0) && pwd))

    if [ -f ${HOME}/.bashrc -a ! -f ${HOME}/.bashrc.orig ]; then
        mv $HOME/.bashrc $HOME/.bashrc.orig
    fi

    cp -r \
       ${REPOSITORY_PATH}/.Xmodmap \
       ${REPOSITORY_PATH}/.aspell.conf \
       ${REPOSITORY_PATH}/.bash_aliases \
       ${REPOSITORY_PATH}/.bashrc \
       ${REPOSITORY_PATH}/.cron_functions.sh \
       ${REPOSITORY_PATH}/.emacs.d \
       ${REPOSITORY_PATH}/.gitconfig \
       ${REPOSITORY_PATH}/.gitignore_global \
       ${REPOSITORY_PATH}/.local \
       ${REPOSITORY_PATH}/.rviz \
       ${REPOSITORY_PATH}/.tmux.conf \
       $HOME
}


home_dir_name_ja2en () {
    LANG=C
    xdg-user-dirs-gtk-update
}


setup_keybind () {
    func_file=/usr/share/X11/xkb/symbols/underscore
    $touch_cmd $func_file
    grep nobackslash $func_file > /dev/null
    exit_status=$?
    if [ $exit_status -eq 1 ]; then
        echo 'partial modifier_keys' | $tee_cmd $func_file
        echo 'xkb_symbols "nobackslash" {' | $tee_cmd -a $func_file
        echo '  replace key <AB11> { [ underscore, underscore ] };' | \
            $tee_cmd -a $func_file
        echo '};' | $tee_cmd -a $func_file
    fi

    rules_file=/usr/share/X11/xkb/rules/evdev
    grep nobackslash $rules_file > /dev/null
    exit_status=$?
    if [ $exit_status -eq 1 ]; then
        echo '! option = symbols' | $tee_cmd -a $rules_file
        echo '  underscore:nobackslash = +underscore(nobackslash)' | \
            $tee_cmd -a $rules_file
    fi

    dconf write /org/gnome/desktop/input-sources/xkb-options \
          "['ctrl:nocaps', 'underscore:nobackslash']"
}


setup_ntp_daemon () {
    ntpdc -nc monlist localhost 2>&1 | \
        grep "***Server reports data not found" > /dev/null
    exit_status=$?
    if [ $exit_status -eq 1 ]; then
        echo "disable monitor" | $tee_cmd -a /etc/ntp.conf
        $service_cmd ntp restart
    fi
}


set -x
set_cmd_for_sudo
copy_dotfiles
home_dir_name_ja2en
setup_keybind
setup_ntp_daemon
set +x
