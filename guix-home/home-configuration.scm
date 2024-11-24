;; This "home-environment" file can be passed to 'guix home reconfigure'
;; to reproduce the content of your profile.  This is "symbolic": it only
;; specifies package names.  To reproduce the exact same profile, you also
;; need to capture the channels being used, as returned by "guix describe".
;; See the "Replicating Guix" section in the manual.

(use-modules (gnu home)
             (gnu packages)
             (gnu services)
             (guix gexp)
             (guix transformations)
             (gnu home services desktop)
             (gnu home services gnupg)
             (gnu home services shepherd)
             (gnu home services sound)
             (gnu packages gnupg))

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

(define goimapnotify-gmail-service
  (shepherd-service
   (documentation "Run 'goimapnotify', to watch a mailbox for events")
   (provision '(goimapnotify-gmail))
   (start #~(make-forkexec-constructor
             (list #$(file-append (specification->package "go-gitlab.com-shackra-goimapnotify")
                                  "/bin/goimapnotify")
                   "-conf"
                   "/home/john/gmail.conf")
             #:log-file "/home/john/test.log"
             #:environment-variables (list "PATH=/run/current-system/profile/bin:/home/john/.config/guix/profiles/emacs/emacs/bin:/home/john/.config/guix/profiles/desktop/desktop/bin")))
   (stop #~(make-kill-destructor))
   (respawn? #t)))

(define goimapnotify-proton-service
  (shepherd-service
   (documentation "Run 'goimapnotify', to watch a mailbox for events")
   (provision '(goimapnotify-proton))
   (start #~(make-forkexec-constructor
             (list #$(file-append (specification->package "go-gitlab.com-shackra-goimapnotify")
                                  "/bin/goimapnotify")
                   "-conf"
                   "/home/john/proton.conf")
             #:log-file "/home/john/testp.log"
             #:environment-variables (list "PATH=/run/current-system/profile/bin:/home/john/.config/guix/profiles/emacs/emacs/bin:/home/john/.config/guix/profiles/desktop/desktop/bin")))
   (stop #~(make-kill-destructor))
   (respawn? #t)))

(define darkman-service
  (shepherd-service
   (documentation "Run 'darkman', a system light/dark theme service")
   (provision '(darkman))
   (start #~(make-forkexec-constructor
             (list #$(file-append (specification->package "darkman")
                                  "/bin/darkman")
                   "run")
             #:log-file "/home/john/testd.log"
             #:environment-variables (list "PATH=/run/current-system/profile/bin:/home/john/.config/guix/profiles/emacs/emacs/bin:/home/john/.config/guix/profiles/desktop/desktop/bin")))
   (stop #~(make-kill-destructor))
   (respawn? #t)))

(home-environment
  ;; Below is the list of packages that will show up in your
  ;; Home profile, under ~/.guix-home/profile.
  (packages (append %cli-packages %emacs-packages %desktop-packages))

  ;; Below is the list of Home services.  To search for available
  ;; services, run 'guix home search KEYWORD' in a terminal.
  (services
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
         (service home-shepherd-service-type
                  (home-shepherd-configuration
                   (services (list darkman-service
                                   goimapnotify-gmail-service
                                   goimapnotify-proton-service))))
         ;; (service home-bash-service-type
         ;;          (home-bash-configuration
         ;;           (aliases '(("grep" . "grep --color=auto") ("ll" . "ls -l")
         ;;                      ("ls" . "ls -p --color=auto")))
         ;;           (bashrc (list (local-file "guix-home/.bashrc" "bashrc")))
         ;;           (bash-profile (list (local-file "guix-home/.bash_profile"
         ;;                                           "bash_profile")))))
         )))
