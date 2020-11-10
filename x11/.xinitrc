#!/bin/sh
# Resources and environment
# Load in the default and user resources and keys

# [[file:README.org::*Resources and environment][Resources and environment:1]]
userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap

# merge in defaults and keymaps
if [ -f $sysresources ]; then
    xrdb -merge $sysresources
fi

if [ -f $sysmodmap ]; then
    xmodmap $sysmodmap
fi

if [ -f "$userresources" ]; then
    xrdb -merge "$userresources"
fi

if [ -f "$usermodmap" ]; then
    xmodmap "$usermodmap"
fi

[[ -f ~/.zshenv ]] && source ~/.zshenv
# Resources and environment:1 ends here



# Environment variables (specific for X, as opposed to ones for all shells)

# [[file:README.org::*Resources and environment][Resources and environment:2]]
export TERMINAL="termite"
export QT_QPA_PLATFORMTHEME="qt5ct"
# Resources and environment:2 ends here

# DPI
# Set DPI based on hostname of the machine

# [[file:README.org::*DPI][DPI:1]]
case $HOSTNAME in
    (azazel) xrandr --dpi 192;;
    (raven)  xrandr --dpi 144;;
esac
# DPI:1 ends here

# Startup programs
# Start any system default programs from ~xinit~

# [[file:README.org::*Startup programs][Startup programs:1]]
if [ -d /etc/X11/xinit/xinitrc.d ] ; then
 for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi
# Startup programs:1 ends here



# Colors from [[https://github.com/deviantfero/wpgtk][wpgtk]]

# [[file:README.org::*Startup programs][Startup programs:2]]
$HOME/.config/wpg/wp_init.sh
# Startup programs:2 ends here



# MPD daemon start (if no other user instance exists)

# [[file:README.org::*Startup programs][Startup programs:3]]
[ ! -s ~/.config/mpd/pid ] && mpd
# Startup programs:3 ends here



# Currently on xmonad

# [[file:README.org::*Window Manager][Window Manager:3]]
exec xmonad
# Window Manager:3 ends here
