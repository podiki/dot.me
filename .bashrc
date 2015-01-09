export PATH=/usr/local/opt/coreutils/libexec/gnubin:/usr/local/bin:/usr/local/share/pypy:/usr/texbin:/usr/local/sbin:$PATH
export JAVA_HOME=/Library/Internet\ Plug-Ins/JavaAppletPlugin.plugin/Contents/Home
export MANPATH=/usr/local/opt/coreutils/libexec/gnuman:$MANPATH
export EDITOR=emacsclient

# locale
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# bash completions
if [ -f $(brew --prefix)/etc/bash_completion ]; then
    . $(brew --prefix)/etc/bash_completion
fi

# various bash settings (many from the terminally-incoherent blog):
# save all the histories
export HISTFILESIZE=1000000
export HISTSIZE=1000000
# don't put duplicate lines or empty spaces in the history
export HISTCONTROL=ignoreboth
# combine multiline commands in history
shopt -s cmdhist
# merge session histories so last closed shell doesn't overwrite it
shopt -s histappend
# corrects typos (eg: cd /ect becomes cd /etc)
shopt -s cdspell
shopt -s dirspell # Correct dir spelling
shopt -s autocd # use a directory name directly as cd
# resize ouput to fit window
shopt -s checkwinsize
# enable colors
eval "`dircolors -b`"

# command settings
# make grep highlight results using color
export GREP_OPTIONS='--color=auto'
# colorful man pages
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m' # end the info box
export LESS_TERMCAP_so=$'\E[01;42;30m' # begin the info box
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'

# use colordiff instead of diff if available
command -v colordiff >/dev/null 2>&1 && alias diff="colordiff -u"
# use htop instead of top if installed
command -v htop >/dev/null 2>&1 && alias top=htop

# autojump
[[ -s `brew --prefix`/etc/autojump.sh ]] && . `brew --prefix`/etc/autojump.sh

# aliases
# ls to use color, type indicators
alias ls="ls -aGF --color=auto"
# ll for details
alias ll="ls -laGFh --color=auto"
# rlwrap-ed sbcl
alias sbcl="~/rlwrap_sbcl.sh"

# AK's fix for iTerm2 color washout
#source ~/iTerm2colors.sh

# powerline-shell setting for the prompt
function _update_ps1() {
   export PS1="$(~/powerline-shell.py --cwd-max-depth 3 $? 2> /dev/null)"
}

export PROMPT_COMMAND="_update_ps1; $PROMPT_COMMAND"
