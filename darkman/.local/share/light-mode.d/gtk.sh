#!/bin/sh
# GTK
# :PROPERTIES:
# :header-args+: :tangle "./.local/share/light-mode.d/gtk.sh"
# :END:

# [[file:../../../README.org::*GTK][GTK:1]]
sed --in-place --follow-symlinks 's/-dark/-light/' ~/.xsettingsd
killall -HUP xsettingsd
lxappearance&
sleep 0.2
killall lxappearance
# GTK:1 ends here
