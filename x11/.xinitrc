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



# Environment variables (specific for X, as opposed to ones for all shells), including setting XDG desktop (see [[https://old.reddit.com/r/i3wm/comments/6in8m1/did_you_know_xdg_current_desktop/][this on Reddit]] for potential changes by some programs)

# [[file:README.org::*Resources and environment][Resources and environment:2]]
export TERMINAL="kitty"
export QT_QPA_PLATFORMTHEME="qt5ct"
# Resources and environment:2 ends here



# Set a GTK theme name (even though this isn't the one actually used) to make sure Firefox has readable lines with some themes (can become dark on dark in the address bar, for instance). Currently using a light/dark mode setup to set themes instead.

# [[file:README.org::*Resources and environment][Resources and environment:3]]
# export GTK_THEME="Adwaita:light"
# Resources and environment:3 ends here

# DPI
# Set DPI based on hostname of the machine

# [[file:README.org::*DPI][DPI:1]]
case $HOSTNAME in
    (azazel) xrandr --dpi 192;;
    (narya)  xrandr --dpi 144;;
esac
# DPI:1 ends here



# Now, for the desktop Guix system need some scaling settings

# [[file:README.org::*DPI][DPI:3]]
if [ "$HOSTNAME" = "narya" ]; then
    QT_SCALE_FACTOR=0.75
fi
# DPI:3 ends here

# Screen setup
# This should probably just be written to the Xorg configuration, but I'm lazy. Also, it doesn't seem to be a problem at the login manger (gdm), but only after logging in.

# [[file:README.org::*Screen setup][Screen setup:1]]
if [ "$HOSTNAME" = "narya" ]; then
    xrandr --output DisplayPort-0 --primary --mode 3840x2160 --pos 0x0 --rotate normal --output DisplayPort-1 --off --output DisplayPort-2 --off --output HDMI-A-0 --off
fi
# Screen setup:1 ends here

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



# An xsettings daemon

# [[file:README.org::*Startup programs][Startup programs:2]]
xsettingsd&
# Startup programs:2 ends here



# Colors from [[https://github.com/deviantfero/wpgtk][wpgtk]]

# [[file:README.org::*Startup programs][Startup programs:3]]
$HOME/.config/wpg/wp_init.sh
# Startup programs:3 ends here



# MPD daemon start (if no other user instance exists)

# [[file:README.org::*Startup programs][Startup programs:4]]
[ ! -s ~/.config/mpd/pid ] && mpd
# Startup programs:4 ends here



# I love anything Lisp related, so used [[https://wiki.archlinux.org/index.php/Stumpwm][StumpWM]] for a while. Still really like using Lisp to hack and configure a WM, but now trying and learning [[https://wiki.archlinux.org/index.php/Xmonad][xmonad]]. Multiple monitor and/or hotplugging monitors causes me crashes (or at least reloading Stump), e.g. [[https://github.com/stumpwm/stumpwm/issues/763][this issue]].

# [[file:README.org::*Window Manager][Window Manager:2]]
# exec sbcl --load ~/.config/stumpwm/startstump.lisp
# for running a compiled version
export SBCL_HOME=$(dirname $(which sbcl))/../lib/sbcl/
dbus-run-session stumpwm
# Window Manager:2 ends here
