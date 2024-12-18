;; This "manifest" file can be passed to 'guix package -m' to reproduce
;; the content of your profile.  This is "symbolic": it only specifies
;; package names.  To reproduce the exact same profile, you also need to
;; capture the channels being used, as returned by "guix describe".
;; See the "Replicating Guix" section in the manual.

(use-modules (guix transformations))

(define transform1
  (options->transformation
   '((with-input . "rofi=rofi-wayland"))))

(concatenate-manifests
 (list
  (packages->manifest
   (list (transform1 (specification->package "rofi-calc"))))
  (specifications->manifest
   '("gnome-themes-extra" ; for some defaults
     "adwaita-icon-theme" ; ditto
     "breeze-icons"       ; and for KDE too
     "hicolor-icon-theme" ; fallback
     "arc-icon-theme"
     "arc-theme"
     "orchis-theme"
     "papirus-icon-theme"
     "firefox"
     "signal-desktop"
     "element-desktop"
     "zoom"
     "flatpak"
     "xdg-desktop-portal-gtk"
     "xdg-desktop-portal-wlr"
     "xdg-desktop-portal-hyprland"
     "font-abattis-cantarell"
     "font-adobe-source-code-pro"
     "font-adobe-source-sans-pro"
     "font-adobe-source-serif-pro"
     "font-google-noto"
     "font-google-roboto"
     "font-liberation"
     "font-microsoft-web-core-fonts"
     "thunar"
     "lxsession" ; just for lxpolkit
     "lxappearance"
     "aspell-dict-en"
     "aspell"
     "darkman"
     "dunst"
     "xdg-utils"
     "piper"
     "bluez"
     "blueman"
     "openrgb"
     "corectrl"
     "lm-sensors"
     "udiskie"
     "xrdb"
     "dex"
     "v4l-utils:gui"
     "geeqie"
     "evince"
     "libreoffice"
     "heroic"
     "steam"
     "headsetcontrol"
     "feh"
     "mpv"
     "opencl-icd-loader"
     "rocm-opencl-runtime"
     "darktable"
     "xmodmap"
     "xsettingsd"
     "font-awesome"
     "polybar"
     "kitty"
     "alacritty"
     "foot"
     "redshift:gtk"
     "picom"
     "python" ; for GUIX_PYTHONPATH needed for redshift
     "syncthing"
     "syncthing-gtk"
     "pulseaudio"
     "xset"
     "xrandr"
     "pavucontrol"
     "pasystray"
     "rofi-wayland"
     "rofi-pass-wayland"
     "yubikey-oath-dmenu"
     "font-dejavu"
     "arandr"
     "xprop"
     "wireplumber"
     ;; wayland
     "xremap-wlroots"
     "gammastep"
     "waybar"
     "swaynotificationcenter"))))
