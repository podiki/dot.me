# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory autocd
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/john/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

setopt sharehistory
setopt extendedhistory

# superglobs
setopt extendedglob
unsetopt caseglob

# Tab completion from both ends
setopt completeinword
# Case-insensitive
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
# Better kilall completion
zstyle ':completion:*:killall:*' command 'ps -u $USER -o cmd'

# Aliases
alias ls='ls --color=auto'
alias ll='ls -lah --color=auto'
eval "$(thefuck --alias)"
# Completion for aliases too
setopt COMPLETE_ALIASES

setopt interactivecomments # pound sign in interactive prompt
# Report CPU stats for long (> 10s) commands
REPORTTIME=10

DEFAULT_USER=$USER
TERM='xterm-256color'

# powerlevel9k
POWERLEVEL9K_MODE='awesome-fontconfig'
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(root_indicator context dir vcs)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status)
POWERLEVEL9K_COLOR_SCHEME='dark'
POWERLEVEL9K_PROMPT_ON_NEWLINE=true
POWERLEVEL9K_OK_ICON='✓'

#
# zplug
#
source /usr/share/zsh/scripts/zplug/init.zsh

zplug "bhilburn/powerlevel9k", use:powerlevel9k.zsh-theme
#zplug "marzocchi/zsh-notify"

# Install plugins if there are plugins that have not been installed
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

# Then, source plugins and add commands to $PATH
zplug load --verbose
