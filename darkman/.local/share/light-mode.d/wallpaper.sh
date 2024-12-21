#!/bin/sh
# Wallpaper
# :PROPERTIES:
# :header-args+: :tangle "./.local/share/light-mode.d/wallpaper.sh"
# :END:
# Switch wallpaper with ~swaybg~

# [[file:../../../README.org::*Wallpaper][Wallpaper:1]]
killall swaybg
WAYLAND_DISPLAY=wayland-1 guix shell swaybg -- swaybg -i /home/john/.local/share/guix-sandbox-home/.local/share/Steam/userdata/11883925/760/remote/2561580/screenshots/20241115011344_1.jpg &
# Wallpaper:1 ends here
