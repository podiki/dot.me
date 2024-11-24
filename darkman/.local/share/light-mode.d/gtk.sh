#!/bin/sh
# GTK
# :PROPERTIES:
# :header-args+: :tangle "./.local/share/light-mode.d/gtk.sh"
# :END:

# [[file:../../../README.org::*GTK][GTK:1]]
sed --in-place --follow-symlinks 's/-dark/-light/' ~/.xsettingsd
sed --in-place --follow-symlinks 's/-Dark/-Light/' ~/.xsettingsd
killall -HUP xsettingsd
DISPLAY=:0 GDK_BACKEND=x11 lxappearance&
sleep 0.2
killall lxappearance
# GTK:1 ends here

# [[file:../../../README.org::*GTK][GTK:2]]
gsettings set org.gnome.desktop.interface gtk-theme Orchis-light
gsettings set org.gnome.desktop.interface icon-theme Papirus-Light
gsettings set org.gnome.desktop.interface cursor-theme capitaine-cursors
# GTK:2 ends here
