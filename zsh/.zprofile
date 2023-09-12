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

# ~XDG_CONFIG_DIRs~ fix
# To work around some search paths not being exported consistently in Guix, e.g. [[https://issues.guix.gnu.org/50103][issue #50103]], add the desktop profile to ~XDG_CONFIG_DIRS~


# [[file:README.org::*~XDG_CONFIG_DIRs~ fix][~XDG_CONFIG_DIRs~ fix:1]]
if [[ -s /run/current-system/profile ]]; then
    export XDG_CONFIG_DIRS=$GUIX_EXTRA_PROFILES/desktop/desktop/etc/xdg:$XDG_CONFIG_DIRS
fi
# ~XDG_CONFIG_DIRs~ fix:1 ends here

# Homebrew
# Utilize homebrew if it exists (Mac only)


# [[file:README.org::*Homebrew][Homebrew:1]]
if [[ -s /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi
# Homebrew:1 ends here
