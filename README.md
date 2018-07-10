# dotfiles_public


Install
=======

apt-get install
---------------
  - subversion
  - ssh
  - aptitude
  - python-pip
  - git
  - emacs24
  - ntp
  - ibus-mozc
  - indicator-multiload
  - htop
  - ccache
  - apt
  - cmake-curses-gui


pip install
-----------
  - pip
  - ipython
  - setuptools
  - percol
  - numpy
  - matplotlib
  - flake8
  - hacking
  - chainer
  - cupy
  - grip


Setup
=====

bash
----
  - change Japanese name dirs to English name in HOME dir
    ```
    LANG=C;xdg-user-dirs-gtk-update
    ```

  - disable CapsLock
    ```
    dconf write /org/gnome/desktop/input-sources/xkb-options "['ctrl:nocaps']"
    ```

  - install necessary packages
    ```
    sudo apt-get update
    sudo apt-get install subversion ssh aptitude python-pip
    ```

  - ssh settings.
    register id_rsa.pub on your github account as ssh keys.
    ```
    ssh-keygen -t rsa
    ```


/etc/ssh/sshd_config
--------------------
  - settings for security
    ```
    PermitRootLogin no
    PasswordAuthentication no
    ```


bash
----
  - after settings above...
    ```
    sudo service ssh restart
    ```

  - if a list appears when do this command,
    ```
    ntpdc -nc monlist localhost
    ```
    then add below to the last line in /etc/ntp.conf


/etc/ntp.conf
-------------
  - settings for security
    ```
    disable monitor
    ```


bash
----
  - now restart ntp
    ```
    sudo service restart ntp
    ```
