#!/bin/sh
# Wallpaper
# :PROPERTIES:
# :header-args+: :tangle "./.local/share/dark-mode.d/wallpaper.sh"
# :END:
# Switch wallpaper with ~swaybg~

# [[file:../../../README.org::*Wallpaper][Wallpaper:1]]
killall swaybg
WAYLAND_DISPLAY=wayland-1 guix shell swaybg -- swaybg -i /home/john/Downloads/disco-dark.png &
# Wallpaper:1 ends here
