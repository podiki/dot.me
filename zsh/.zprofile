# System-wide
# Honor system-wide environment variables

# [[file:README.org::*System-wide][System-wide:1]]
source /etc/profile
# System-wide:1 ends here

# Guix profile loading
# Test if on a Guix System to set the extra profiles variable and source them. Otherwise, set and source the default one on a foreign distribution. For Guix, also source anything in a profiles ~/etc/profile.d~ directory (while this an expected place, have only seen Flatpak put something in there on Guix).

# [[file:README.org::*Guix profile loading][Guix profile loading:1]]
if [[ -s /run/current-system/profile ]]; then
    export GUIX_EXTRA_PROFILES="$HOME/.config/guix/profiles"
    for i in $GUIX_EXTRA_PROFILES/*; do
        profile=$i/$(basename "$i")
        if [ -f "$profile"/etc/profile ]; then
            GUIX_PROFILE="$profile"
            . "$GUIX_PROFILE"/etc/profile
        fi

        if [ -d "$profile"/etc/profile.d/ ]; then
            for j in "$profile"/etc/profile.d/*.sh ; do
                if [ -r "$j" ]; then
                    . $j
                fi
            done
        fi

        unset profile
    done
else
    export GUIX_PROFILE="$HOME/.config/guix/current"
    . "$GUIX_PROFILE/etc/profile"
    #  export GUIX_LOCPATH=$HOME/.guix-profile/lib/locale
fi
# Guix profile loading:1 ends here

# xdg-desktop-portal fix
# Seems like a bug that the portals do not like multiple directories for ~XDG_DESKTOP_PORTAL_DIR~. So override it manually for now

# [[file:README.org::*xdg-desktop-portal fix][xdg-desktop-portal fix:1]]
export XDG_DESKTOP_PORTAL_DIR=$GUIX_EXTRA_PROFILES/desktop/desktop/share/xdg-desktop-portal/portals
# xdg-desktop-portal fix:1 ends here
