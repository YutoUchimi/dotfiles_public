## Alias Commands

alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

alias grep='grep --color=auto --exclude-dir=.svn'

# ros completion
alias rp='rostopic'
alias rn='rosnode'
alias rr='rosrun'
alias rl='roslaunch'
complete -F _roscomplete_rostopic rp
complete -F _roscomplete_rosnode rn
complete -F _roscomplete_exe rr
complete -F _roscomplete_launch rl

# git completion
alias ga='git add'
alias gb='git branch -v'
alias gc='git commit'
alias gcm='git commit -m'
alias gco='git checkout'
alias gcob='git checkout -b'
alias gd='git diff'
alias gdc='git diff --cached'
alias gfa='git fetch --all -p'
alias gl='git log'
alias gp='git push'
alias grb='git rebase'
alias grm='git remote -v'
alias gst='git status'
alias gt='git tree'

source /usr/share/bash-completion/completions/git
__git_complete ga _git_add
__git_complete gb _git_branch
__git_complete gc _git_commit
__git_complete gcm _git_commit
__git_complete gco _git_checkout
__git_complete gcob _git_checkout
__git_complete gd _git_diff
__git_complete gdc _git_diff
__git_complete gfa _git_fetch
__git_complete gl _git_log
__git_complete gp _git_push
__git_complete grb _git_rebase
__git_complete grm _git_remote
__git_complete gst _git_status
__git_complete gt _git_tree

# emacs
if ( which emacs25 > /dev/null ); then
    alias e='emacs25 -nw'
else
    alias e="emacs -nw"
fi
