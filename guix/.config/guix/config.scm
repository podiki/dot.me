;; This is an operating system configuration generated
;; by the graphical installer.

(use-modules (gnu)
             (guix download) ;for url-fetch (udev rule)
             (guix packages) ;for origin (udev rule)
             (nongnu packages linux) ; this and next for nongnu linux
             (nongnu system linux-initrd)
             (gnu packages shells) ; for zsh
             (gnu packages linux) ; for fstrim
             (gnu packages display-managers) ; for sddm
             (guix profiles) ;; For manifest-entries
             (srfi srfi-1) ;; For filter-map
             (gnu packages hardware) ;; openrgb
             (openrgb) ;; for corectrl
             (gnu packages gnome)) ;; for libratbag (piper)

(use-service-modules
 cups
 dbus
 desktop
 mcron
 networking
 security-token ; for pcscd
 sddm
 sound
 ssh
 syncthing
 sysctl
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
            ;(specification->package "emacs")
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
             (simple-service 'corectrl-polkit polkit-service-type
                             (list corectrl))
             ;; dbus files from corectrl are system-service files,
             ;; so need to add to dbus-root-service
             (simple-service 'corectrl-dbus dbus-root-service-type
                             (list corectrl))
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
             (service sddm-service-type (sddm-configuration))
             (modify-services %desktop-services
                              (delete gdm-service-type) ; replaced by sddm
                              ;; don't use USB modems, scanners, or network-manager-applet
                              (delete modem-manager-service-type)
                              (delete usb-modeswitch-service-type)
                              (delete sane-service-type)
                              ;; not sure how to
                              ;(delete (specification->package "network-manager-applet"))
                              ;; Set the default sample rate for the pulseaudio daemon to be
                              ;; 48000; needed for the Valve Index mic, see
                              ;; https://github.com/ValveSoftware/SteamVR-for-Linux/issues/215#issuecomment-526791835
                              (pulseaudio-service-type config =>
                                                       (pulseaudio-configuration
                                                        (daemon-conf '((default-sample-rate . 48000)))))
                              (guix-service-type config =>
                                                 (guix-configuration
                                                  (inherit config)
                                                  (substitute-urls
                                                   (append (list "https://substitutes.nonguix.org"
                                                                 "http://substitutes.guix.sama.re")
                                                           %default-substitute-urls))
                                                  (authorized-keys
                                                   (append (list (local-file "substitutes.nonguix.org.pub")
                                                                 (local-file "substitutes.guix.sama.re.pub"))
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
  (kernel-arguments
   '("quiet"
     "splash"
     ;; Disable the PC speaker (do they still exist?)
     "modprobe.blacklist=pcspkr,snd_pcsp"))
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

  (swap-devices (list (swap-space (target "/swap/swapfile")
                                  (dependencies
                                   (filter (lambda (x)
                                             (equal? (file-system-mount-point x)
                                                     "/swap"))
                                           file-systems))))))
