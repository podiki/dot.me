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

# [[file:README.org::*.zshenv][.zshenv:2]]
#typeset -U PATH path
#PATH=("$HOME/.local/bin" "$path[@]")
PATH=$HOME/.local/bin:$PATH
export PATH
# .zshenv:2 ends here



# Get colors from [[https://github.com/deviantfero/wpgtk/][wpgtk]] so commands in non-interactive shells also have them

# [[file:README.org::*.zshenv][.zshenv:3]]
(cat ~/.config/wpg/sequences &)
# .zshenv:3 ends here
