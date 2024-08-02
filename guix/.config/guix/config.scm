;; This is an operating system configuration generated
;; by the graphical installer.

(use-modules (gnu)
             (guix download) ;for url-fetch (udev rule)
             (guix packages) ;for origin (udev rule)
             (peroxide-service) ;testing
             (nongnu packages linux) ; this and next for nongnu linux
             (nongnu system linux-initrd)
             (gnu packages games) ; for steam devices udev
             (gnu packages shells) ; for zsh
             (gnu packages linux) ; for fstrim
             (gnu packages networking) ; for blueman
             (guix profiles) ;; For manifest-entries
             (srfi srfi-1) ;; For filter-map
             (rosenthal packages wm) ;; for hyprland
             (gnu packages hardware) ;; openrgb
             (gnu packages security-token) ;; for libfido2 (udev rule)
             (openrgb) ;; for corectrl and openrgb-next
             (gnu packages gnome)) ;; for libratbag (piper)

(use-service-modules
 cups
 dbus
 desktop
 docker
 sddm
 mcron
 networking
 security-token ; for pcscd
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

(define linux-vrfix
  (package/inherit linux
    (source
     (origin
       (inherit (package-source linux))
       (patches (append '("cap_sys_nice_begone.patch")
                        (origin-patches (package-source linux))))))))

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
                    '("wheel" "netdev" "audio" "video" "docker" "kvm")))
                %base-user-accounts))
  (packages
    (append
     (list (specification->package "xinitrc-xsession")
           (specification->package "hyprland")
           (specification->package "ntfs-3g"))
      %base-packages))
  (services (cons*
             (service pam-limits-service-type
               (list
                 ;; higher open file limit, helpful for Wine and esync
                 (pam-limits-entry "*" 'both 'nofile 524288)
                 ;; lower nice limit for users, but root can go further to rescue system
                 (pam-limits-entry "*" 'both 'nice -19)
                 (pam-limits-entry "root" 'both 'nice -20)))
             (service pcscd-service-type)
             (service peroxide-service-type) ;testing
             (service bluetooth-service-type
                      (bluetooth-configuration (fast-connectable? #t)
                                               (privacy 'device)
                                               (just-works-repairing 'always)))
             (udev-rules-service 'u2f libfido2 #:groups '("plugdev"))
             (udev-rules-service 'headsetcontrol headsetcontrol)
             (udev-rules-service 'steam-devices steam-devices-udev-rules)
             (udev-rules-service 'openrgb openrgb)
             (simple-service 'blueman dbus-root-service-type (list blueman))
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
             ;; fstrim seemed to be running at unexpected times and causing sleep problems
             ;; disable for now (June 2022)
             ;; (simple-service 'my-mcron-jobs
             ;;                 mcron-service-type
             ;;                 (list ; garbage-collector-job
             ;;                       fstrim-job))
             (service syncthing-service-type
                      (syncthing-configuration (user "john")))
             ;(service sddm-service-type)
             ;(set-xorg-configuration (xorg-configuration (extra-config
             ;                                             '("Section \"Device\"
             ;                                                  Identifier \"device-amdgpu\"
             ;                                                  Driver \"amdgpu\"
             ;                                                  Option \"SWCursor\" \"on\"
             ;                                                EndSection")))
             ;                        sddm-service-type)
             (service docker-service-type)
             (modify-services %desktop-services
                              ;(delete gdm-service-type) ; replaced by lightdm
                              ;; don't use USB modems, scanners, or network-manager-applet
                              (delete modem-manager-service-type)
                              (delete usb-modeswitch-service-type)
                              (delete sane-service-type)
                              ;; not sure how to
                              ;(delete (specification->package "network-manager-applet"))
                              ;; ignore the power key since a certain naughty kitten likes to press it
                              (elogind-service-type config =>
                                                    (elogind-configuration
                                                     (inherit config)
                                                     (handle-power-key 'ignore)))
                              ;; Set the default sample rate for the pulseaudio daemon to be
                              ;; 48000; needed for the Valve Index mic, see
                              ;; https://github.com/ValveSoftware/SteamVR-for-Linux/issues/215#issuecomment-526791835
                              ;; (pulseaudio-service-type config =>
                              ;;                          (pulseaudio-configuration
                              ;;                           (daemon-conf '((default-sample-rate . 44100)))))
                              (delete pulseaudio-service-type)
                              (guix-service-type config =>
                                                 (guix-configuration
                                                  (inherit config)
                                                  (substitute-urls
                                                   ;; Reverse the order to put Bordeaux first, adding in the US mirror
                                                   ;; don't reverse as the US mirror has become slow/unresponsive for unknown reasons
                                                   (append ;'("https://bordeaux-us-east-mirror.cbaines.net/")
                                                           %default-substitute-urls
                                                           '("https://cuirass.genenetwork.org"
                                                             "https://substitutes.nonguix.org")))
                                                  (authorized-keys
                                                   (append (list (local-file "substitutes.nonguix.org.pub")
                                                                 (local-file "cuirass.genenetwork.org.pub"))
                                                           %default-authorized-guix-keys))))
                              (sysctl-service-type config =>
                                (sysctl-configuration
                                 (settings
                                  (append '(("vm.swappiness" . "10")
                                            ;; potential performance
                                            ;; or stability with some
                                            ;; games and now a default
                                            ;; in e.g. Arch
                                            ("vm.max_map_count" . "1048576"))
                                          %default-sysctl-settings)))))))
  (kernel linux-6.10)
  (kernel-loadable-modules (list v4l2loopback-linux-module))
  (kernel-arguments
   '("quiet"
     "splash"
     ;; Disable the PC speaker (do they still exist?)
     "modprobe.blacklist=pcspkr,snd_pcsp"
     ;; Enable more amdgpu features, e.g. controling power/performance with corectrl
     "amdgpu.ppfeaturemask=0xffffffff"
     "amd_pstate=active"))
  (initrd microcode-initrd)
  (firmware (cons* amdgpu-firmware
                   realtek-firmware
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
                         (type "vfat"))
                       (file-system
                         (device (file-system-label "extra"))
                         (mount-point "/mnt/extra")
                         (type "ext4")
                         (flags '(no-atime))))
                 %base-file-systems))

  (swap-devices
   (list
    (swap-space
     (target "/swap/swapfile")
     (dependencies (filter (file-system-mount-point-predicate "/swap")
                           file-systems))))))
