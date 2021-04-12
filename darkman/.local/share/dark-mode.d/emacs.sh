#!/bin/sh
# emacs
# :PROPERTIES:
# :header-args+: :tangle "./.local/share/dark-mode.d/emacs.sh"
# :END:
# For emacs, call a custom function that toggles between day and night themes. This should be rewritten to explicitly pick the right theme instead of assuming it is currently set to the light theme already.


# [[file:../../../README.org::*emacs][emacs:1]]
emacsclient -e '(toggle-day-night-theme)'
# emacs:1 ends here
