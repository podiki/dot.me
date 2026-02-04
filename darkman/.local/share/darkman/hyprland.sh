#!/bin/sh
# Hyprland
# :PROPERTIES:
# :header-args+: :tangle "./.local/share/darkman/hyprland.sh"
# :END:
# Set the cursor theme for Hyprland as well, see [[https://wiki.hyprland.org/FAQ/#how-do-i-change-me-mouse-cursor][this question in the Hyprland FAQ]]. Except this doesn't work as the darkman service spawned by guix-home doesn't see the Hyprland environment variable needed...


# [[file:../../../README.org::*Hyprland][Hyprland:1]]
case "$1" in
    dark) THEME=capitaine-cursors ;;
    light) THEME=capitaine-cursors-light ;;
    *) exit 1 ;;
esac

# hyprctl setcursor $THEME 32
# Hyprland:1 ends here
