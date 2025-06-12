#!/bin/sh
# GTK
# :PROPERTIES:
# :header-args+: :tangle "./.local/share/dark-mode.d/gtk.sh"
# :END:
# For GTK need to send ~HUP~ to the ~xsettings~ daemon to reload settings. This does give live changes of settings in things like Firefox. All this does is change the theme name to "-dark" from "-light" and reload. However, the mouse cursor theme is not updated on the root window (background) or in some programs. Opening lxappearance at least helps for the root window, so quickly open and kill that as a work around for now.

# Firefox has the extension [[https://github.com/skhzhang/time-based-themes/][automaticDark]] set to change themes based on the system theme (from "Light" to "Dark"); wouldn't be needed for Firefox themes where "Default" looks good for light and dark system themes. Also, [[https://darkreader.org/][Dark Reader]] is set to activate based on system theme as well (it can do its own browser dark theme, but doesn't quite match well for me).


# [[file:../../../README.org::*GTK][GTK:1]]
sed --in-place --follow-symlinks 's/-light/-dark/' ~/.xsettingsd
sed --in-place --follow-symlinks 's/-Light/-Dark/' ~/.xsettingsd
sed --in-place --follow-symlinks 's/capitaine-cursors/capitaine-cursors-light/' ~/.xsettingsd
killall -HUP xsettingsd
DISPLAY=:0 GDK_BACKEND=x11 lxappearance&
sleep 0.2
killall lxappearance
# GTK:1 ends here



# Well, the above doesn't really work for Wayland at all (or maybe for some applications?), see [[https://github.com/swaywm/sway/wiki/GTK-3-settings-on-Wayland][Sway wiki]]. So, use ~gsettings~ directly.


# [[file:../../../README.org::*GTK][GTK:2]]
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
gsettings set org.gnome.desktop.interface gtk-theme Orchis-dark
gsettings set org.gnome.desktop.interface icon-theme Papirus-Dark
# gsettings set org.gnome.desktop.interface cursor-theme capitaine-cursors-light
# GTK:2 ends here
