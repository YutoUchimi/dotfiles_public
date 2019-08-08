#!/bin/sh

set_cmd_for_sudo () {
    if [ $(whoami) = 'root' ]; then
        apt_get_cmd='apt-get'
        pip_cmd='pip'
        sed_cmd='sed'
        sensors_detect_cmd='sensors-detect'
        service_cmd='service'
        tee_cmd='tee'
        touch_cmd='touch'
    else
        apt_get_cmd='sudo apt-get'
        pip_cmd='sudo -H pip'
        sed_cmd='sudo sed'
        sensors_detect_cmd='sudo sensors-detect'
        service_cmd='sudo service'
        tee_cmd='sudo tee'
        touch_cmd='sudo touch'
    fi
}


apt_get_install () {
    local repo_path=$(echo $(cd $(dirname $0) && pwd))
    $apt_get_cmd update
    $apt_get_cmd install \
                 $(grep -vE "^\s*#" ${repo_path}/apt_requirements.txt | \
                       tr "\n" " ")
}


pip_install () {
    local repo_path=$(echo $(cd $(dirname $0) && pwd))
    $pip_cmd install "pip==9.0.3"
    $pip_cmd install -r ${repo_path}/pip_requirements.txt
}


copy_dotfiles () {
    local repo_path=$(echo $(cd $(dirname $0) && pwd))

    if [ -f ${HOME}/.bashrc -a ! -f ${HOME}/.bashrc.orig ]; then
        mv $HOME/.bashrc $HOME/.bashrc.orig
    fi

    cp -r \
       ${repo_path}/.Xmodmap \
       ${repo_path}/.aspell.conf \
       ${repo_path}/.bash_aliases \
       ${repo_path}/.bashrc \
       ${repo_path}/.cron_functions.sh \
       ${repo_path}/.crontab \
       ${repo_path}/.emacs.d \
       ${repo_path}/.gitconfig \
       ${repo_path}/.gitignore_global \
       ${repo_path}/.local \
       ${repo_path}/.rviz \
       ${repo_path}/.tmux.conf \
       $HOME
}


home_dir_name_ja2en () {
    LANG=C
    xdg-user-dirs-gtk-update
}


setup_keybind () {
    local func_file=/usr/share/X11/xkb/symbols/underscore
    $touch_cmd $func_file
    grep nobackslash $func_file > /dev/null
    local exit_status=$?
    if [ $exit_status -eq 1 ]; then
        echo 'partial modifier_keys' | $tee_cmd $func_file
        echo 'xkb_symbols "nobackslash" {' | $tee_cmd -a $func_file
        echo '  replace key <AB11> { [ underscore, underscore ] };' | \
            $tee_cmd -a $func_file
        echo '};' | $tee_cmd -a $func_file
    fi

    local rules_file=/usr/share/X11/xkb/rules/evdev
    grep nobackslash $rules_file > /dev/null
    local exit_status=$?
    if [ $exit_status -eq 1 ]; then
        echo '! option = symbols' | $tee_cmd -a $rules_file
        echo '  underscore:nobackslash = +underscore(nobackslash)' | \
            $tee_cmd -a $rules_file
    fi

    dconf write /org/gnome/desktop/input-sources/xkb-options \
          "['ctrl:nocaps', 'underscore:nobackslash']"
}


setup_ssh_daemon () {
    local config_file=/etc/ssh/sshd_config
    $sed_cmd \
        -i \
        -e "s/$(cat $config_file | \
               grep -E ^#\?PermitRootLogin)/PermitRootLogin no/" \
        $config_file
    $sed_cmd \
        -i \
        -e "s/$(cat $config_file | \
               grep -E ^#\?PasswordAuthentication)/PasswordAuthentication no/" \
        $config_file
    $service_cmd ssh restart
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


setup_lm_sensors () {
    yes yes | $sensors_detect_cmd
    $service_cmd kmod start
}


set -x
set_cmd_for_sudo
apt_get_install
pip_install
copy_dotfiles
home_dir_name_ja2en
setup_keybind
setup_ssh_daemon
setup_ntp_daemon
setup_lm_sensors
set +x
