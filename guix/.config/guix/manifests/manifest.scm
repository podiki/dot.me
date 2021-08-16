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

(define transform3
  (options->transformation
    '((with-patch
        .
        "openrgb=/home/john/codemonkey/guix-pod/crucial.patch"))))

(define transform2
  (options->transformation
    '((with-input . "go@1.14=go@1.16"))))

(define transform1
  (options->transformation
    '((with-source
        .
        "xdg-desktop-portal-gtk=https://github.com/flatpak/xdg-desktop-portal-gtk/releases/download/1.8.0/xdg-desktop-portal-gtk-1.8.0.tar.xz"))))

(packages->manifest
  (list (specification->package "emacs-guix")
        (specification->package "rofi-calc")
        (specification->package "python-tldr")
        (specification->package "emacs-pdf-tools")
        (specification->package "python-yubikey-manager")
        (specification->package "curl")
        (transform1
          (specification->package "xdg-desktop-portal-gtk"))
        (specification->package "xdg-desktop-portal")
        (specification->package "arc-icon-theme")
        (specification->package "arc-theme")
        (transform2
          (specification->package
            "go-gitlab-com-whynothugo-darkman"))
        (specification->package "firefox")
        (specification->package "font-abattis-cantarell")
        (specification->package
          "font-adobe-source-code-pro")
        (specification->package
          "font-adobe-source-sans-pro")
        (specification->package
          "font-adobe-source-serif-pro")
        (specification->package "lxappearance")
        (specification->package "mu")
        (specification->package "aspell-dict-en")
        (specification->package "aspell")
        (specification->package "dunst")
        (specification->package "xdg-utils")
        (transform3 (specification->package "openrgb"))
        (specification->package "lm-sensors")
        (transform4 (specification->package "picom"))
        (specification->package "xrdb")
        (specification->package "emacs-pgtk-native-comp")
        (specification->package "unzip")
        (specification->package "dex")
        (specification->package "feh")
        (specification->package "xmodmap")
        (specification->package "emacs-use-package")
        (specification->package "xsettingsd")
        (specification->package "font-awesome")
        (specification->package "polybar")
        (specification->package "xorgproto")
        (specification->package "libxft")
        (specification->package "pkg-config")
        (specification->package "libxscrnsaver")
        (specification->package "libxinerama")
        (specification->package "libxrandr")
        (specification->package "libx11")
        (specification->package "ghc@8.6")
        (specification->package "gcc-toolchain@10")
        (specification->package "cabal-install")
        (specification->package "zsh")
        (specification->package "kitty")
        (specification->package "htop")
        (specification->package "redshift")
        (specification->package "stow")
        (specification->package "syncthing")
        (specification->package "syncthing-gtk")
        (specification->package "pulseaudio")
        (specification->package "xset")
        (specification->package "xrandr")
        (specification->package "pavucontrol")
        (transform5 (specification->package "flatpak"))
        (specification->package "rofi-pass")
        (specification->package "rofi")
        (specification->package "git")
        (specification->package "password-store")
        (specification->package "font-dejavu")
        (specification->package "openssh")
        (specification->package "pinentry")
        (specification->package "ccid")
        (specification->package "gnupg")
        (specification->package "arandr")
        (specification->package "icecat")))
