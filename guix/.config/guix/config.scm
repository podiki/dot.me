;; This is an operating system configuration generated
;; by the graphical installer.

(use-modules (gnu)
             (guix download) ;for url-fetch (udev rule)
             (guix packages) ;for origin (udev rule)
             (nongnu packages linux) ; this and next for nongnu linux
             (nongnu system linux-initrd)
             (gnu services syncthing)
             (gnu services mcron)
             (gnu services sysctl) ; for sysctl service
             (gnu packages shells) ; for zsh
             (gnu packages linux) ; for fstrim
             (gnu packages display-managers) ; for sddm
             (guix profiles) ;; For manifest-entries
             (srfi srfi-1) ;; For filter-map
             (openrgb) ;; openrgb
             (gnu packages gnome) ;; for libratbag (piper)
             ;; (pkill9 services fhs) ;; For fhs-binaries-compatibility-service
             ;; (pkill9 utils) ;; For package-output->package
             )
(use-service-modules
 cups
 dbus
 desktop
 networking
 security-token ; for pcscd
 sddm
 ssh
 xorg)

(define fstrim-job
  ;; Run fstrim on all applicable mounted drives once a week
  ;; on Sunday at 11:35am.
  #~(job "35 11 * * Sun"
         (string-append #$util-linux+udev
                        "/sbin/fstrim --all --verbose")))

(define garbage-collector-job
  ;; Collect garbage 5 minutes after midnight every day.
  ;; The job's action is a shell command.
  #~(job "5 0 * * *"            ;Vixie cron syntax
         "guix gc -F 1G"))

;; from pkill-9
;; (define (manifest->packages manifest)
;;   "Return the list of packages in MANIFEST."
;;   (filter-map (lambda (entry)
;;                 (let ((item (manifest-entry-item entry)))
;;                   (if (package? item) item #f)))
;;               (manifest-entries manifest)))

;; (define fhs-packages
;;   (append (list (package-output->package (@ (gnu packages gcc) gcc-7) "lib"))
;;           (manifest->packages
;;            (specifications->manifest
;;             (list
;;              "libxcomposite" "libxtst" "libxaw" "libxt" "libxrandr" "libxext" "libx11"
;;              "libxfixes" "glib" "gtk+" "gtk+@2" "bzip2" "zlib" "gdk-pixbuf" "libxinerama"
;;              "libxdamage" "libxcursor" "libxrender" "libxscrnsaver" "libxxf86vm"
;;              "libxi" "libsm" "libice" "gconf" "freetype" "curl" "nspr" "nss" "fontconfig"
;;              "cairo" "pango" "expat" "dbus" "cups" "libcap" "sdl2" "libusb" "dbus-glib"
;;              "atk" "eudev" "network-manager" "pulseaudio" "openal" "alsa-lib" "mesa"

;;              "libxmu" "libxcb" "glu" "util-linux" "libogg" "libvorbis" "sdl" "sdl2-image"
;;              "glew" "openssl" "libidn" "tbb" "flac" "freeglut" "libjpeg" "libpng" "libpng@1.2"
;;              "libsamplerate" "libmikmod" "libtheora" "libtiff" "pixman" "speex" "sdl-image"
;;              "sdl-ttf" "sdl-mixer" "sdl2-ttf" "sdl2-mixer" "gstreamer" "gst-plugins-base"
;;              "glu" "libcaca" "libcanberra" "libgcrypt" "libvpx"
;;              ;;"librsvg" ;; currently requires compiling, but shouldn't, it's being weird
;;              "libxft"
;;              "libvdpau" "gst-plugins-ugly" "libdrm" "xkeyboard-config" "libpciaccess"
;;              ;; "ffmpeg@3.4" ;; failing for some reason (2021-08-07)
;;              "mit-krb5" ;; needed for beataroni
;;              "libpng" "libgpg-error" "sqlite" "libnotify"

;;              "fuse" "e2fsprogs" "p11-kit" "xz" "keyutils" "xcb-util-keysyms" "libselinux"
;;              "ncurses" "jack" "jack2" "vulkan-loader")))))

;; TODO make these git version
(define %steam-input-udev-rules
  (file->udev-rule
    "60-steam-input.rules"
    (let ((version "8a3f1a0e2d208b670aafd5d65e216c71f75f1684"))
      (origin
       (method url-fetch)
       (uri (string-append "https://raw.githubusercontent.com/ValveSoftware/"
                           "steam-devices/" version "/60-steam-input.rules"))
       (sha256
        (base32 "1k6sa9y6qb9vh7qsgvpgfza55ilcsvhvmli60yfz0mlks8skcd1f"))))))

(define %steam-vr-udev-rules
  (file->udev-rule
    "60-steam-vr.rules"
    (let ((version "13847addfd56ef70dee98c1f7e14c4b4079e2ce8"))
      (origin
       (method url-fetch)
       (uri (string-append "https://raw.githubusercontent.com/ValveSoftware/"
                           "steam-devices/" version "/60-steam-vr.rules"))
       (sha256
        (base32 "0f05w4jp2pfp948vwwqa17ym2ps7sgh3i6sdc69ha76jlm49rp0z"))))))

(operating-system
  (locale "en_US.utf8")
  (timezone "America/New_York")
  (keyboard-layout (keyboard-layout "us"
                                    #:options '("ctrl:swapcaps")))
  (host-name "narya")
  (users (cons* (user-account
                  (name "john")
                  (comment "John")
                  (group "users")
                  (home-directory "/home/john")
                  (shell (file-append zsh "/bin/zsh"))
                  (supplementary-groups
                    '("wheel" "netdev" "audio" "video")))
                %base-user-accounts))
  (packages
    (append
      (list (specification->package "xinitrc-xsession")
            (specification->package "emacs")
            (specification->package "nss-certs")
            (specification->package "ntfs-3g"))
      %base-packages))
  (services (cons*
             (pam-limits-service
              (list
               ;; higher open file limit, helpful for Wine and esync
               (pam-limits-entry "*" 'both 'nofile 524288)
               ;; lower nice limit for users, but root can go further to rescue system
               (pam-limits-entry "*" 'both 'nice -19)
               (pam-limits-entry "root" 'both 'nice -20)))
             (service pcscd-service-type)
             (udev-rules-service 'steam-input %steam-input-udev-rules)
             (udev-rules-service 'steam-vr %steam-vr-udev-rules)
             (simple-service 'ratbagd dbus-root-service-type (list libratbag))
             ;; (simple-service 'corectrl-polkit polkit-service-type
             ;;                 (list corectrl))
             ;; dbus files from corectrl are system-service files,
             ;; so need to add to dbus-root-service
             ;; (simple-service 'corectrl-dbus dbus-root-service-type
             ;;                 (list corectrl))
             ;(geoclue-service)
             ;; to have geoclue in the system profile, so the agent autostart file is visible
             ;; (simple-service 'profile-geoclue profile-service-type
             ;;                 (list (specification->package "geoclue")))
             (simple-service 'my-mcron-jobs
                             mcron-service-type
                             (list ; garbage-collector-job
                                   fstrim-job))
             (service syncthing-service-type
                      (syncthing-configuration (user "john")))
             ;; (service fhs-binaries-compatibility-service-type
             ;;          (fhs-configuration
             ;;           (lib-packages fhs-packages)
             ;;           (additional-special-files
             ;;            `(;; QT apps fail to recieve keyboard input unless they find this hardcoded path.
             ;;              ("/usr/share/X11/xkb"
             ;;               ,(file-append
             ;;                 (canonical-package
             ;;                  (@ (gnu packages xorg) xkeyboard-config))
             ;;                 "/share/X11/xkb"))
             ;;              ;; Chromium component of electron apps break without fontconfig configuration here.
             ;;              ("/etc/fonts" ,"/run/current-system/profile/etc/fonts")))))
             (service sddm-service-type (sddm-configuration))
             (modify-services %desktop-services
                              (delete gdm-service-type) ; replaced by sddm
                              ;; don't use USB modems, scanners, or network-manager-applet
                              (delete modem-manager-service-type)
                              (delete usb-modeswitch-service-type)
                              (delete sane-service-type)
                              ;; not sure how to
                              ;(delete (specification->package "network-manager-applet"))
                              (guix-service-type config =>
                                                 (guix-configuration
                                                  (inherit config)
                                                  (substitute-urls
                                                   (append (list "https://substitutes.nonguix.org"
                                                                 "http://substitutes.guix.sama.re"
                                                                 "https://mirror.brielmaier.net")
                                                           %default-substitute-urls))
                                                  (authorized-keys
                                                   (append (list (local-file "substitutes.nonguix.org.pub")
                                                                 (local-file "substitutes.guix.sama.re.pub")
                                                                 (local-file "mirror.brielmaier.net.pub"))
                                                           %default-authorized-guix-keys))))
                              (udev-service-type config =>
                                                 (udev-configuration
                                                  (inherit config)
                                                  (rules (cons openrgb
                                                               (udev-configuration-rules config)))))
                              (sysctl-service-type config =>
                                                   (sysctl-configuration
                                                    (settings (append '(("vm.swappiness" . "10"))
                                                                      %default-sysctl-settings)))))))
  (kernel linux)
  (initrd microcode-initrd)
  (firmware (cons* amdgpu-firmware
                   %base-firmware))
  ;; Use the UEFI variant of GRUB with the EFI System
  ;; Partition mounted on /boot/efi.
  (bootloader (bootloader-configuration
                (bootloader grub-efi-bootloader)
                (targets '("/boot/efi"))
                (keyboard-layout keyboard-layout)))

  (file-systems (append
                 (list (file-system
                         (device (file-system-label "system"))
                         (mount-point "/")
                         (type "btrfs")
                         (flags '(no-atime))
                         (options "subvol=root,compress=lzo,ssd"))
                       (file-system
                         (device (file-system-label "system"))
                         (mount-point "/swap")
                         (type "btrfs")
                         ;; to have swap start on boot with btrfs
                         ;; see https://issues.guix.gnu.org/50788#2
                         (needed-for-boot? #t)
                         (flags '(no-atime))
                         (options "subvol=swap,ssd"))
                       (file-system
                         (device (file-system-label "system"))
                         (mount-point "/gnu/store")
                         (type "btrfs")
                         (flags '(no-atime))
                         (options "subvol=gnu-store,compress=lzo,ssd"))
                       (file-system
                         (device (file-system-label "system"))
                         (mount-point "/var/log")
                         (type "btrfs")
                         (flags '(no-atime))
                         (options "subvol=var-log,compress=lzo,ssd"))
                       (file-system
                         (device (file-system-label "system"))
                         (mount-point "/home")
                         (type "btrfs")
                         (flags '(no-atime))
                         (options "subvol=home,compress=lzo,ssd"))
                       (file-system
                         (device (uuid "5989-F926" 'fat))
                         (mount-point "/boot/efi")
                         (type "vfat")))
                 %base-file-systems))
  ;; use dependencies here instead of the needed-for-boot? flag above?
  (swap-devices (list (swap-space (target "/swap/swapfile")))))
