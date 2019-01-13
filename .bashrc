# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

function parse_git_branch {
    git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ [\1]/'
}

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\[\033[01;31m\]$(parse_git_branch)\[\033[00m\]\n\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w$(parse_git_branch)\n\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi


###--------------------------------------------------------------------------###


# C-r: percol history search
percol-search-history () {
    local l=$(HISTTIMEFORMAT= history | tac | sed -e 's/^\s*[0-9]\+\s\+//' | \
                  percol --query "$READLINE_LINE")
  READLINE_LINE="$l"
  READLINE_POINT=${#l}
}
bind -x '"\C-r": percol-search-history'

## Rviz for a laptop user
# export OGRE_RTT_MODE=Copy

if [ $(find $HOME -maxdepth 3 -name ".catkin_tools" 2> /dev/null | \
           sed -n 1p) ]; then
    source $(find $HOME -maxdepth 3 -name ".catkin_tools" 2> /dev/null | \
                 sort | sed -n 1p | sed s#.catkin_tools#devel/setup.bash#)
elif [ $ROS_DISTRO ]; then
    source /opt/ros/${ROS_DISTRO}/setup.bash
fi

if [ $(rospack find jsk_tools 2> /dev/null) ]; then
    rossetmaster localhost
    rossetip
fi

show_ros () {
    echo "ROS_DISTRO: $ROS_DISTRO"
    echo "CMAKE_PREFIX_PATH: $CMAKE_PREFIX_PATH"
}

percol-search-rostopic () {
  local l=$(rostopic list | percol)
  READLINE_LINE="$READLINE_LINE$l"
  READLINE_POINT=${#READLINE_LINE}
}

if ( which rosversion > /dev/null ); then
    show_ros
    # Esc-p : rostopic search
    bind -x '"\ep" : percol-search-rostopic'
fi

# For tmux path
export PATH=$HOME/.local/bin:$PATH
export TERM=xterm

export CUDA_HOME=/usr/local/cuda
export PATH=$CUDA_HOME/bin:$PATH
export LD_LIBRARY_PATH=$CUDA_HOME/lib64:$LD_LIBRARY_PATH

show_cuda () {
    # cuda
    CUDA_VERSION=$(command nvcc --version | sed -n 4p | \
                       sed 's/.*, release .*, V\(.*\)/\1/')
    echo "CUDA_VERSION: $CUDA_VERSION"
    # cudnn
    if [ -e $CUDA_HOME/include/cudnn.h ]; then
        CUDNN_MAJOR=$(cat $CUDA_HOME/include/cudnn.h | \
                          grep '#define CUDNN_MAJOR' | awk '{print $3}')
        CUDNN_MINOR=$(cat $CUDA_HOME/include/cudnn.h | \
                          grep '#define CUDNN_MINOR' | awk '{print $3}')
        CUDNN_PATCHLEVEL=$(cat $CUDA_HOME/include/cudnn.h | \
                               grep '#define CUDNN_PATCHLEVEL' | \
                               awk '{print $3}')
        CUDNN_VERSION="$CUDNN_MAJOR.$CUDNN_MINOR.$CUDNN_PATCHLEVEL"
    elif [ -e /usr/include/cudnn.h ]; then
        CUDNN_MAJOR=$(cat /usr/include/cudnn.h | \
                             grep '#define CUDNN_MAJOR' | awk '{print $3}')
        CUDNN_MINOR=$(cat /usr/include/cudnn.h | \
                             grep '#define CUDNN_MINOR' | awk '{print $3}')
        CUDNN_PATCHLEVEL=$(cat /usr/include/cudnn.h | \
                                  grep '#define CUDNN_PATCHLEVEL' | \
                                  awk '{print $3}')
        CUDNN_VERSION="$CUDNN_MAJOR.$CUDNN_MINOR.$CUDNN_PATCHLEVEL"
    fi
    echo "CUDNN_VERSION: $CUDNN_VERSION"
}
if ( which nvcc > /dev/null ); then show_cuda; fi

if ( which pycd.sh > /dev/null ); then source `which pycd.sh`; fi

# autoenv
if ( which activate.sh > /dev/null ); then source `which activate.sh`; fi

if [ "$CONDA_PREFIX" != "" ]; then
    source $CONDA_PREFIX/bin/activate $CONDA_DEFAULT_ENV
elif [ $(find -L $HOME -maxdepth 5 -name activate 2> /dev/null | \
             grep -E ".anaconda*/bin/activate" | sort | sed -n 1p) ]; then
    source $(find -L $HOME -maxdepth 5 -name activate 2> /dev/null | \
                 grep -E ".anaconda*/bin/activate" | sort | sed -n 1p)
fi
if [ "$CONDA_PREFIX" != "" ]; then
    echo "CONDA_PREFIX: $CONDA_PREFIX"
fi

if [ $(crontab -l 2>/dev/null | wc -c | cut -d " " -f 1) -lt 1 ]; then
    if [ -f $HOME/.crontab ]; then
        crontab $HOME/.crontab
    fi
fi
