#!/bin/sh
# Hyprland
# :PROPERTIES:
# :header-args+: :tangle "./.local/share/dark-mode.d/hyprland.sh"
# :END:
# Set the cursor theme for Hyprland as well, see [[https://wiki.hyprland.org/FAQ/#how-do-i-change-me-mouse-cursor][this question in the Hyprland FAQ]]. Except this doesn't work as the darkman service spawned by guix-home doesn't see the Hyprland environment variable needed...


# [[file:../../../README.org::*Hyprland][Hyprland:1]]
hyprctl setcursor capitaine-cursors-light 32
# Hyprland:1 ends here
