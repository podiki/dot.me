#!/bin/sh

userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap

$HOME/.config/wpg/wp_init.sh

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

# some relevant environment variables
export TERMINAL="termite"
export QT_QPA_PLATFORMTHEME="qt5ct"

# DPI settings
# set correct dpi
xrandr --dpi 192
# After moving from infinality to freetype 2.7/fontconfig 2.12
# suddenly fonts got really large, turned dpi down from 288
# commented out below settings
# QT HiDPI
#export QT_SCALE_FACTOR=2
# GDK 3 (GTK+ 3) HiDPI
#export GDK_SCALE=2
#export GDK_DPI_SCALE=0.5

# start some nice programs

if [ -d /etc/X11/xinit/xinitrc.d ] ; then
 for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi

# MPD daemon start (if no other user instance exists)
[ ! -s ~/.config/mpd/pid ] && mpd

# i3wm
exec i3 # --shmlog-size=26214400
