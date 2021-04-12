#!/bin/sh
# GTK
# :PROPERTIES:
# :header-args+: :tangle "./.local/share/light-mode.d/gtk.sh"
# :END:

# [[file:../../../README.org::*GTK][GTK:1]]
sed --in-place --follow-symlinks 's/-dark/-light/' ~/.xsettingsd
killall -HUP xsettingsd
# GTK:1 ends here
