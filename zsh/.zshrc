# p10k instant prompt

# [[file:README.org::*p10k instant prompt][p10k instant prompt:1]]
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
# p10k instant prompt:1 ends here

# Basic loading from installer

# [[file:README.org::*Basic loading from installer][Basic loading from installer:1]]
if [[ -r "$HOME/.config/zi/init.zsh" ]]; then
  source "$HOME/.config/zi/init.zsh" && zzinit
fi
zi light-mode for \
  z-shell/z-a-meta-plugins \
  @annexes # <- https://z.digitalclouds.dev/ecosystem/annexes
# examples here -> https://z.digitalclouds.dev/docs/gallery/collection
zicompinit # <- https://z.digitalclouds.dev/docs/guides/commands
# Basic loading from installer:1 ends here

# Prompt
# Load powerlevel10k theme:

# [[file:README.org::*Prompt][Prompt:1]]
zinit light romkatv/powerlevel10k

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
# Prompt:1 ends here

# Misc
# Color for man pages:

# [[file:README.org::*Misc][Misc:1]]
zi ice use:"*.zsh"
zi light zuxfoucault/colored-man-pages_mod
# Misc:1 ends here

# History and completion

# [[file:README.org::*History and completion][History and completion:1]]
HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=10000
setopt hist_ignore_dups append_history extended_history autocd

# The following lines were added by compinstall
zstyle :compinstall filename '$HOME/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

# Completion for kitty
if [[ "$TERM" == (screen*|xterm*|rxvt*|termite*|kitty*) ]]; then
    kitty + complete setup zsh | source /dev/stdin
fi

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
# History and completion:1 ends here

# GPG
# Per the gpg-agent documentation

# [[file:README.org::*GPG][GPG:1]]
export GPG_TTY="$(tty)"
# GPG:1 ends here

# Keybindings
# Set emacs style (by default through ~EDITOR~, but anyway)

# [[file:README.org::*Keybindings][Keybindings:1]]
bindkey -e
# Keybindings:1 ends here



# Set up general keybindings, mostly just didn't have delete key registering correctly in Termite or Emacs

# [[file:README.org::*Keybindings][Keybindings:2]]
# create a zkbd compatible hash;
# to add other keys to this hash, see: man 5 terminfo
typeset -g -A key

key[Home]="${terminfo[khome]}"
key[End]="${terminfo[kend]}"
key[Insert]="${terminfo[kich1]}"
key[Backspace]="${terminfo[kbs]}"
key[Delete]="${terminfo[kdch1]}"
key[Up]="${terminfo[kcuu1]}"
key[Down]="${terminfo[kcud1]}"
key[Left]="${terminfo[kcub1]}"
key[Right]="${terminfo[kcuf1]}"
key[PageUp]="${terminfo[kpp]}"
key[PageDown]="${terminfo[knp]}"
key[Shift-Tab]="${terminfo[kcbt]}"

# setup key accordingly
[[ -n "${key[Home]}"      ]] && bindkey -- "${key[Home]}"      beginning-of-line
[[ -n "${key[End]}"       ]] && bindkey -- "${key[End]}"       end-of-line
[[ -n "${key[Insert]}"    ]] && bindkey -- "${key[Insert]}"    overwrite-mode
[[ -n "${key[Backspace]}" ]] && bindkey -- "${key[Backspace]}" backward-delete-char
[[ -n "${key[Delete]}"    ]] && bindkey -- "${key[Delete]}"    delete-char
[[ -n "${key[Up]}"        ]] && bindkey -- "${key[Up]}"        up-line-or-history
[[ -n "${key[Down]}"      ]] && bindkey -- "${key[Down]}"      down-line-or-history
[[ -n "${key[Left]}"      ]] && bindkey -- "${key[Left]}"      backward-char
[[ -n "${key[Right]}"     ]] && bindkey -- "${key[Right]}"     forward-char
[[ -n "${key[PageUp]}"    ]] && bindkey -- "${key[PageUp]}"    beginning-of-buffer-or-history
[[ -n "${key[PageDown]}"  ]] && bindkey -- "${key[PageDown]}"  end-of-buffer-or-history
[[ -n "${key[Shift-Tab]}" ]] && bindkey -- "${key[Shift-Tab]}" reverse-menu-complete

# Finally, make sure the terminal is in application mode, when zle is
# active. Only then are the values from $terminfo valid.
if (( ${+terminfo[smkx]} && ${+terminfo[rmkx]} )); then
        autoload -Uz add-zle-hook-widget
        function zle_application_mode_start { echoti smkx }
        function zle_application_mode_stop { echoti rmkx }
        add-zle-hook-widget -Uz zle-line-init zle_application_mode_start
        add-zle-hook-widget -Uz zle-line-finish zle_application_mode_stop
fi
# Keybindings:2 ends here

# Aliases

# [[file:README.org::*Aliases][Aliases:1]]
alias ls='ls --color=auto -F'
alias ll='ls -lahF --color=auto'
# removed thefuck for now (test breakage)
# eval "$(thefuck --alias)"
alias gp='grep --color -rniC 1'
# Completion for aliases too
setopt COMPLETE_ALIASES
# Aliases:1 ends here

# Looks

# [[file:README.org::*Looks][Looks:1]]
# Colors from wpgtk
#(cat ~/.config/wpg/sequences &)

#
# Prompt stuff
#
setopt interactivecomments # pound sign in interactive prompt
# Report CPU stats for long (> 10s) commands
REPORTTIME=10

# powerlevel9k prompt
#POWERLEVEL9K_MODE='awesome-fontconfig'
#POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(root_indicator context dir vcs)
#POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status)
#POWERLEVEL9K_COLOR_SCHEME='dark'
#POWERLEVEL9K_PROMPT_ON_NEWLINE=true
#POWERLEVEL9K_OK_ICON='✓'

#
# Window title
#
autoload -Uz add-zsh-hook

function xterm_title_precmd () {
        print -Pn '\e]2;%n@%m %~\a'
        [[ "$TERM" == 'screen'* ]] && print -Pn '\e_\005{g}%n\005{-}@\005{m}%m\005{-} \005{B}%~\005{-}\e\\'
}

function xterm_title_preexec () {
        print -Pn '\e]2;%n@%m %~ %# ' && print -n "${(q)1}\a"
        [[ "$TERM" == 'screen'* ]] && { print -Pn '\e_\005{g}%n\005{-}@\005{m}%m\005{-} \005{B}%~\005{-} %# ' && print -n "${(q)1}\e\\"; }
}

if [[ "$TERM" == (screen*|xterm*|rxvt*|termite*|kitty*|foot*) ]]; then
        add-zsh-hook -Uz precmd xterm_title_precmd
        add-zsh-hook -Uz preexec xterm_title_preexec
fi
# Looks:1 ends here

# Syntax highlight

# [[file:README.org::*Syntax highlight][Syntax highlight:1]]
source ~/.guix-home/profile/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
# Syntax highlight:1 ends here
