;; This "manifest" file can be passed to 'guix package -m' to reproduce
;; the content of your profile.  This is "symbolic": it only specifies
;; package names.  To reproduce the exact same profile, you also need to
;; capture the channels being used, as returned by "guix describe".
;; See the "Replicating Guix" section in the manual.

(use-modules (guix transformations))

(define transform4
  (options->transformation
    '((with-git-url
        .
        "picom=https://github.com/yshui/picom")
      (with-branch . "picom=next"))))

(define transform2
  (options->transformation
    '((with-input . "go@1.14=go@1.16"))))

(concatenate-manifests
 (list
  (specifications->manifest
   '("rofi-calc"
     "gnome-themes-extra" ; for some defaults
     "adwaita-icon-theme" ; ditto
     "breeze-icons"       ; and for KDE too
     "arc-icon-theme"
     "arc-theme"
     "orchis-theme"
     "papirus-icon-theme"
     "firefox"
     "flatpak"
     "xdg-desktop-portal-gtk"
     "font-abattis-cantarell"
     "font-adobe-source-code-pro"
     "font-adobe-source-sans-pro"
     "font-adobe-source-serif-pro"
     "font-google-noto"
     "font-google-roboto"
     "font-liberation"
     "lxappearance"
     "aspell-dict-en"
     "aspell"
     "dunst"
     "xdg-utils"
     "piper"
     "openrgb"
     ;; "corectrl"
     "lm-sensors"
     "udiskie"
     "xrdb"
     "dex"
     "v4l-utils:gui"
     "geeqie"
     "evince"
     "libreoffice"
     "headsetcontrol"
     "feh"
     "mpv"
     "audacity"
     "python-autokey"
     "darktable"
     "xmodmap"
     "xsettingsd"
     "font-awesome"
     "polybar"
     "kitty"
     "redshift:gtk"
     "python" ; for GUIX_PYTHONPATH needed for redshift
     "syncthing"
     "syncthing-gtk"
     "pulseaudio"
     "xset"
     "xrandr"
     "pavucontrol"
     "pasystray"
     ;"glib" ; to pick up XDG_DATA_DIRS, picked up somewhere else now
     "rofi-pass"
     "rofi"
     "python-yubikey-oath-dmenu"
     "font-dejavu"
     "arandr"
     "xprop"
     "icecat"))
  (packages->manifest
   (list
    (transform2
     (specification->package
      "go-gitlab-com-whynothugo-darkman"))
    (transform4
     (specification->package
      "picom"))))))
