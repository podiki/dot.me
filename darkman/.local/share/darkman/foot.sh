#!/bin/sh
# foot
# :PROPERTIES:
# :header-args+: :tangle "./.local/share/darkman/foot.sh"
# :END:

# [[file:../../../README.org::*foot][foot:1]]
case "$1" in
    dark) SIGNAL=SIGUSR1 ;;
    light) SIGNAL=SIGUSR2 ;;
    *) exit 1;;
esac

sed -i "s/initial-color-theme=.*/initial-color-theme=$1/g" ~/.config/foot/foot.ini

pkill -$SIGNAL foot
# foot:1 ends here
