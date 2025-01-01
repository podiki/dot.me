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



# Add a user local bin to ~PATH~ (right now just for XMonad with Stack, default install location)

# [[file:README.org::*.zshenv][.zshenv:3]]
typeset -U path PATH
path=(~/.local/bin $path)
export PATH
# .zshenv:3 ends here



# Enable MangoHud by default

# [[file:README.org::*.zshenv][.zshenv:5]]
export MANGOHUD=1
# .zshenv:5 ends here
