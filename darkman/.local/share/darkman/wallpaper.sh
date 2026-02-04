#!/bin/sh
# Wallpaper
# :PROPERTIES:
# :header-args+: :tangle "./.local/share/darkman/wallpaper.sh"
# :END:
# Switch wallpaper with ~swaybg~

# [[file:../../../README.org::*Wallpaper][Wallpaper:1]]
case "$1" in
    dark) WALL=/home/john/Downloads/disco-dark.png ;;
    light) WALL=/home/john/.local/share/guix-sandbox-home/.local/share/Steam/userdata/11883925/760/remote/2561580/screenshots/20241115011344_1.jpg ;;
    *) exit 1 ;;
esac

if pgrep -x "swaybg" > /dev/null
then
    killall swaybg
fi

WAYLAND_DISPLAY=wayland-1 guix shell swaybg -- nohup swaybg -i "$WALL" --mode fill &
# Wallpaper:1 ends here
