# .zshenv
# :PROPERTIES:
# :header-args+: :tangle ".zshenv"
# :END:
# Set up a few environment variables we need everywhere, especially the One True Editor (with a fallback of nano)

# [[file:README.org::*.zshenv][.zshenv:1]]
export DEFAULT_USER=$USER
#TERM='xterm-256color'

export EDITOR='emacsclient -a nano'
# .zshenv:1 ends here



# workaround core-updates-frozen bug with TZ and HOSTNAME not universal

# [[file:README.org::*.zshenv][.zshenv:2]]
export TZ=America/New_York
export HOSTNAME=$(hostname)
# .zshenv:2 ends here



# ssh with pgp

# [[file:README.org::*.zshenv][.zshenv:3]]
export GPG_TTY="$(tty)"
export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
gpgconf --launch gpg-agent
# .zshenv:3 ends here



# Add a user local bin to ~PATH~ (right now just for XMonad with Stack, default install location)

# [[file:README.org::*.zshenv][.zshenv:4]]
#typeset -U PATH path
#PATH=("$HOME/.local/bin" "$path[@]")
PATH=$HOME/.local/bin:$PATH
export PATH
# .zshenv:4 ends here
