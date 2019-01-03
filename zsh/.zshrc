HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=10000
setopt hist_ignore_dups append_history extended_history autocd
bindkey -e

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

# correct commands
setopt correct

# Tab completion from both ends
setopt completeinword
# Case-insensitive
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
# Better kilall completion
zstyle ':completion:*:killall:*' command 'ps -u $USER -o cmd'

# Aliases
alias ls='ls --color=auto -F'
alias ll='ls -lahF --color=auto'
eval "$(thefuck --alias)"
alias gp='grep --color -rniC 1'
# Completion for aliases too
setopt COMPLETE_ALIASES

# Colors from wpgtk
(cat ~/.config/wpg/sequences &)

#
# Prompt stuff
#
setopt interactivecomments # pound sign in interactive prompt
# Report CPU stats for long (> 10s) commands
REPORTTIME=10

# powerlevel9k prompt
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
zplug "zuxfoucault/colored-man-pages_mod", use:"*.zsh"
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
