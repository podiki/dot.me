;; This "home-environment" file can be passed to 'guix home reconfigure'
;; to reproduce the content of your profile.  This is "symbolic": it only
;; specifies package names.  To reproduce the exact same profile, you also
;; need to capture the channels being used, as returned by "guix describe".
;; See the "Replicating Guix" section in the manual.

(use-modules (darkman)
             (ice-9 match)
             (gnu home)
             (gnu packages)
             (gnu services)
             (gnu home services)
             (gnu home services desktop)
             (gnu home services gnupg)
             (gnu home services shepherd)
             (gnu home services sound)
             (gnu packages glib)
             (gnu packages gnome)
             (gnu packages gnupg)
             (gnu services configuration)
             (guix gexp)
             (guix transformations)
             ;; for cut and remove
             (srfi srfi-26)
             (srfi srfi-1))

;; Package lists, with some inspiration from
;; <https://git.sr.ht/~efraim/guix-config> (see item/efraim-home.scm).
(define %cli-packages
  (map specification->package+output
       (list "python-tldr"
             "python-yubikey-manager"
             "colordiff"
             "thefuck"
             "curl"
             "tree"
             "btrfs-progs"
             "compsize"
             "autoconf"
             "automake"
             ;; "mu"
             "make"
             "lm-sensors"
             "unzip"
             "zsh"
             "zsh-syntax-highlighting"
             "htop"
             "stow"
             "git"
             "git:send-email"
             "pwgen"
             "password-store"
             "openssh"
             "pinentry"
             "ccid"
             "gnupg")))

(define native-comp
  (options->transformation
   '((with-input . "emacs-minimal=emacs-pgtk"))))

(define org-msg-git
  (options->transformation
   '((with-input . "emacs-minimal=emacs-pgtk")
     (with-git-url
      .
      "emacs-org-msg=https://github.com/jeremy-compostella/org-msg"))))

(define %emacs-packages
  (append
   (list (org-msg-git (specification->package "emacs-org-msg")))
   (map native-comp
        (map specification->package
             (list "emacs-visual-fill-column"
                   "emacs-goto-chg"
                   "emacs-frames-only-mode"
                   "emacs-paradox"
                   "emacs-exec-path-from-shell"
                   "emacs-color-theme-solarized"
                   ;; commented out missing/not currently used
                   ;; packages
                   ;; "emacs-molokai-theme"
                   "emacs-monokai-theme"
                   "emacs-spacemacs-theme"
                   "emacs-doom-themes"
                   "emacs-solaire-mode"
                   "emacs-mixed-pitch"
                   ;; native comp fail "emacs-powerline"
                   ;; native comp fail for powerline "emacs-spaceline-all-the-icons"
                   "emacs-doom-modeline"
                   "emacs-dashboard"
                   "emacs-ido-completing-read+"
                   "emacs-ido-vertical-mode"
                   "emacs-smex"
                   "emacs-multiple-cursors"
                   "emacs-orderless"
                   ;; "emacs-ivy"
                   ;; "emacs-swiper"
                   ;; "emacs-counsel"
                   ;; "emacs-ivy-posframe"
                   ;; "emacs-ivy-rich"
                   ;; "emacs-counsel-org-clock"
                   ;; "emacs-hydra"
                   ;; "emacs-ivy-hydra"
                   "emacs-consult"
                   "emacs-which-key"
                   ;; "emacs-color-identifiers-mode"
                   "emacs-highlight-symbol"
                   ;; "emacs-define-word"
                   "emacs-langtool"
                   "emacs-neotree"
                   "emacs-diredfl"
                   "emacs-dired-git-info"
                   "emacs-org"
                   "emacs-org-contrib"
                   "emacs-org-superstar"
                   "emacs-org-bullets"
                   "emacs-org-modern"
                   "emacs-org-appear"
                   "emacs-org-present"
                   "emacs-htmlize"
                   "emacs-org-re-reveal"
                   "emacs-ox-reveal"
                   ;; "emacs-org2blog"
                   ;; "emacs-org-gcal"
                   "emacs-calfw"
                   "emacs-org-super-agenda"
                   "emacs-org-ref"
                   "emacs-org-noter"
                   ;; "emacs-advice-patch"
                   "emacs-org-cliplink"
                   "emacs-org-auto-tangle"
                   ;; "emacs-org-msg"
                   "emacs-mu4e-alert"
                   ;; "emacs-mu4e-marker-icons"
                   "emacs-magit"
                   "emacs-company"
                   "emacs-company-quickhelp"
                   "emacs-company"
                   "emacs-flycheck"
                   ;; "emacs-flycheck-color-mode-line"
                   "emacs-rainbow-delimiters"
                   "emacs-smartparens"
                   "emacs-slime"
                   "emacs-slime-company"
                   ;; "emacs-info-look"
                   ;; "emacs-cython-mode"
                   ;; "emacs-python-mode"
                   ;; "emacs-company-jedi"
                   ;; "emacs-haxe-mode"
                   "emacs-eglot"
                   "emacs-fountain-mode"
                   "emacs-markdown-mode"
                   "emacs-olivetti"
                   "emacs-ledger-mode"
                   "emacs-flycheck-ledger"
                   "emacs-auctex"
                   ;; "emacs-latex-pretty-symbols"
                   "emacs-company-auctex"
                   "emacs-company-math"
                   "emacs-emms"
                   "emacs-nerd-icons"
                   "emacs-all-the-icons"
                   "emacs-all-the-icons-dired"
                   "emacs-pgtk"
                   "emacs-pdf-tools"
                   "emacs-use-package"
                   "guile"
                   "emacs-debbugs"
                   "emacs-geiser"
                   "emacs-geiser-guile"
                   "emacs-guix"
                   "emacs-yasnippet"
                   "emacs-highlight-sexp"
                   "emacs-gdscript-mode"
                   "emacs-ledger-mode"
                   "emacs-vertico"
                   "emacs-vertico-posframe"
                   "emacs-marginalia"
                   "python-lsp-server"
                   "emacs-docker-compose-mode"
                   "emacs-eat"
                   ;; mail
                   "mu"
                   "oauth2ms"
                   "isync"
                   "go-gitlab.com-shackra-goimapnotify")))))

(define rofi-calc-wayland
  (options->transformation
   '((with-input . "rofi=rofi-wayland"))))

(define %desktop-packages
  (append
   (list (rofi-calc-wayland (specification->package "rofi-calc")))
   (map specification->package+output
        (list "gnome-themes-extra" ; for some defaults
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
              ;; conflicts with mpv (but really shouldn't as it only
              ;; propagates glib), among others; how to get gsettings
              ;; then?
              ;; "glib:bin"
              ;; fonts
              "font-abattis-cantarell"
              "font-adobe-source-code-pro"
              "font-adobe-source-sans-pro"
              "font-adobe-source-serif-pro"
              "font-google-noto"
              "font-google-noto-sans-cjk"
              "font-google-noto-emoji"
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
              "godot"
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
              "yubikey-touch-detector"
              "font-dejavu"
              "arandr"
              "xprop"
              "wireplumber"
              ;; wayland
              "xremap-wlroots"
              "gammastep"
              "waybar"
              "swaynotificationcenter"))))

;; much stolen from
;; <https://git.ditigal.xyz/~ruther/guix-exprs/tree/main/item/ruther/home/services/wayland.scm>
;; and (gnu home services desktop)
(define (wayland-hyprland-env-shepherd-service config)
  (list
   (shepherd-service
    (documentation "Sets WAYLAND_DISPLAY and HYPRLAND_INSTANCE_SIGNATURE to arguments
passed in. This should be called from a wayland compositor: herd start
wayland-display $WAYLAND_DISPLAY $HYPRLAND_INSTANCE_SIGNATURE")
    (provision '(wayland-hyprland-env))
    (auto-start? #f)
    (respawn? #f)
    (start #~(lambda (wayland-display hyprland-sign)
               (setenv "WAYLAND_DISPLAY" wayland-display)
               (setenv "HYPRLAND_INSTANCE_SIGNATURE" hyprland-sign)))
    (stop #~(lambda _
              (unsetenv "WAYLAND_DISPLAY")
              (unsetenv "HYPRLAND_INSTANCE_SIGNATURE")
              #f)))))

(define-public home-wayland-hyprland-env-service-type
  (service-type
   (name 'home-wayland-hyprland-env)
   (description "A service to set WAYLAND_DISPLAY and HYPRLAND_INSTANCE_SIGNATURE for
shepherd services.")
   (default-value #f)
   (extensions
    (list (service-extension home-shepherd-service-type
                             wayland-hyprland-env-shepherd-service)))))

(define (goimapnotify-shepherd-service config-name)
  ;; config-name is base name, full path is $HOME/config-name.conf
  (list (shepherd-service
        (documentation "Run 'goimapnotify', to watch a mailbox for events")
        (provision (list (string->symbol
                          (string-append "goimapnotify-" config-name))))
        (modules '((shepherd support))) ;for %user-log-dir
        (start #~(make-forkexec-constructor
                  (list #$(file-append
                           (specification->package
                            "go-gitlab.com-shackra-goimapnotify")
                           "/bin/goimapnotify")
                        "-conf" (string-append (getenv "HOME")
                                               "/" #$config-name ".conf"))
                  #:log-file (string-append %user-log-dir "/goimapnotify-"
                                            #$config-name ".log")
                  ;; Need pinentry to see the X(Wayland) server, just
                  ;; use the default.
                  #:environment-variables (cons "DISPLAY=:0"
                                                (default-environment-variables))))
        ;; in conf onNewMail --socket-name=/run/user/1000/emacs/server
        (stop #~(make-kill-destructor))
        (respawn? #t))))

(define home-goimapnotify-service-type
  (service-type (name 'goimapnotify)
                (extensions
                 (list (service-extension home-shepherd-service-type
                                          goimapnotify-shepherd-service)))
                (default-value "goimapnotify")
                (description "goimapnotify service")))

(define (darkman-shepherd-service config)
  (list (shepherd-service
        (documentation "Run 'darkman', a system light/dark theme service")
        (provision '(darkman))
        (requirement '(dbus wayland-hyprland-env))
        (modules '((shepherd support)  ;for %user-log-dir
                   ;; for remove and cut
                   (srfi srfi-1)
                   (srfi srfi-26)))
        (start #~(lambda _
                   (if (service-running? (lookup-service 'wayland-hyprland-env))
                       (make-forkexec-constructor
                        (list #$(file-append (specification->package "darkman")
                                             "/bin/darkman")
                              "run")
                        #:log-file (string-append %user-log-dir "/darkman.log")
                        #:environment-variables
                        (cons* (string-append "WAYLAND_DISPLAY=" (or
                                                                  (getenv "WAYLAND_DISPLAY")
                                                                  "NOTSET"))
                               (string-append "HYPRLAND_INSTANCE_SIGNATURE="
                                              (or (getenv "HYPRLAND_INSTANCE_SIGNATURE")
                                                  "NOTSET"))
                               ;; shouldn't have these variables by default
                               ;; anyway (hence this whole thing) so
                               ;; probably don't need this?
                               ;; (remove (cut string-prefix? "HYPRLAND_INSTANCE_SIGNATURE=" <>)
                               ;;         (remove (cut string-prefix? "WAYLAND_DISPLAY=" <>)
                               ;;                 (default-environment-variables)))
                               (default-environment-variables)))
                       #f)))
        (stop #~(make-kill-destructor))
        (auto-start? #f)
        (respawn? #t))))

(define (home-darkman-profile-entries config)
  (list darkman (list glib "bin") gsettings-desktop-schemas))

(define home-darkman-service-type
  (service-type (name 'home-darkman)
                (extensions
                 (list (service-extension home-shepherd-service-type
                                          darkman-shepherd-service)
                       (service-extension home-profile-service-type
                                          home-darkman-profile-entries)
                       ;; need this for env
                       (service-extension home-wayland-hyprland-env-service-type
                                          (const #t))))
                (default-value #f)
                (description "darkman service")))

(define (home-darkman-profile-entries config)
  (list darkman dconf (list glib "bin") gsettings-desktop-schemas))

(define home-darkman-service-type
  (service-type (name 'home-darkman)
                (extensions
                 (list (service-extension home-shepherd-service-type
                                          darkman-shepherd-service)
                       (service-extension home-profile-service-type
                                          home-darkman-profile-entries)))
                (default-value #f)
                (description "darkman service")))

(home-environment
 ;; Below is the list of packages that will show up in your
 ;; Home profile, under ~/.guix-home/profile.
 (packages (append %cli-packages %emacs-packages %desktop-packages))
 ;; Below is the list of Home services.  To search for available
 ;; services, run 'guix home search KEYWORD' in a terminal.
 (services
  (append
   (list (service home-dbus-service-type) ;; pipewire complains no dbus service
         (service home-pipewire-service-type)
         (service home-gpg-agent-service-type
                  (home-gpg-agent-configuration
                   ;; Use the default gtk2 pintentry program.
                   (pinentry-program
                    (file-append pinentry "/bin/pinentry"))
                   (ssh-support? #t)
                   ;; From
                   ;; <https://github.com/drduh/config/blob/master/gpg-agent.conf>,
                   ;; except no TTY setting (just needed for
                   ;; localization?).
                   (default-cache-ttl 60)
                   (max-cache-ttl 120)
                   ;; Shouldn't this be set by the option above?
                   (extra-content "enable-ssh-support")))
         (service home-wayland-hyprland-env-service-type)
         (service home-darkman-service-type)
         (service home-goimapnotify-service-type "gmail")
         (service home-goimapnotify-service-type "proton"))
   %base-home-services)))
