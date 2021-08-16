#!/usr/bin/env sh

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -x polybar >/dev/null; do sleep 1; done

# Launch bar based on hostname
case $HOSTNAME in
    (azazel) polybar azazel &;;
    (narya)  polybar raven &;;
esac

echo "Bars launched..."
