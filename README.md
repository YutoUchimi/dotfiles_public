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
  - rlwrap
  - libgnome2-bin
  - xsel


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
