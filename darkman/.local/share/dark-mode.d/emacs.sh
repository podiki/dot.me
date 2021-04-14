#!/bin/sh
# emacs
# :PROPERTIES:
# :header-args+: :tangle "./.local/share/dark-mode.d/emacs.sh"
# :END:
# For emacs, call a custom function that toggles between day and night themes. Provide the optional argument to make sure it switches to the correct theme if needed (if already the correct theme, does nothing).


# [[file:../../../README.org::*emacs][emacs:1]]
emacsclient -e '(toggle-day-night-theme :dark)'
# emacs:1 ends here
