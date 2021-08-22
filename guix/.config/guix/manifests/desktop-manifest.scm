;; This "manifest" file can be passed to 'guix package -m' to reproduce
;; the content of your profile.  This is "symbolic": it only specifies
;; package names.  To reproduce the exact same profile, you also need to
;; capture the channels being used, as returned by "guix describe".
;; See the "Replicating Guix" section in the manual.

(use-modules (guix transformations))

(define transform5
  (options->transformation
    '((with-source
        .
        "https://github.com/flatpak/flatpak/releases/download/1.11.2/flatpak-1.11.2.tar.xz"))))

(define transform4
  (options->transformation
    '((with-git-url
        .
        "picom=https://github.com/yshui/picom")
      (with-branch . "picom=next"))))

(define transform2
  (options->transformation
    '((with-input . "go@1.14=go@1.16"))))

(define transform1
  (options->transformation
    '((with-source
        .
        "xdg-desktop-portal-gtk=https://github.com/flatpak/xdg-desktop-portal-gtk/releases/download/1.8.0/xdg-desktop-portal-gtk-1.8.0.tar.xz"))))

(concatenate-manifests
 (list
  (specifications->manifest
   '("rofi-calc"
     "xdg-desktop-portal"
     "arc-icon-theme"
     "arc-theme"
     "orchis-theme"
     "papirus-icon-theme"
     "firefox"
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
     "openrgb"
     "lm-sensors"
     "xrdb"
     "dex"
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
     "redshift"
     "syncthing"
     "syncthing-gtk"
     "pulseaudio"
     "xset"
     "xrandr"
     "pavucontrol"
     "glib" ; to pick up XDG_DATA_DIRS
     "rofi-pass"
     "rofi"
     "python-yubikey-oath-dmenu"
     "font-dejavu"
     "arandr"
     "icecat"))
  (packages->manifest
   (list
    (transform1
     (specification->package
      "xdg-desktop-portal-gtk"))
    (transform2
     (specification->package
      "go-gitlab-com-whynothugo-darkman"))
    (transform4
     (specification->package
      "picom"))
    (transform5
     (specification->package
      "flatpak"))))))
