(use-modules (gnu)
             (guix download) ;for url-fetch (udev rule)
             (guix packages) ;for origin (udev rule)
             (guix transformations)
             (peroxide-service) ;testing
             (nongnu packages linux) ; this and next for nongnu linux
             (nongnu system linux-initrd)
             (gnu packages games) ; for steam devices udev
             (gnu packages shells) ; for zsh
             (gnu packages linux) ; for fstrim
             (gnu packages networking) ; for blueman
             (guix profiles) ;; For manifest-entries
             (srfi srfi-1) ;; For filter-map
             (gnu packages hardware) ;; openrgb
             (gnu packages security-token) ;; for libfido2 (udev rule)
             (gnu packages admin) ;; for corectrl
             (gnu packages gnome)) ;; for libratbag (piper)

(use-service-modules cups
                     dbus
                     desktop
                     sddm
                     linux
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

(define cachy-url
  "https://github.com/CachyOS/kernel-patches/raw/refs/heads/master/6.17/")

(define (cachy-patch name hash)
  (origin
    (method url-fetch)
    (uri (string-append cachy-url name ".patch"))
    (sha256 (base32 hash))))

(define cap-sys-nice-patch
  (origin
    (method url-fetch)
    (uri (string-append "https://raw.githubusercontent.com/Scrumplex/"
                        "pkgs/refs/heads/main/kernelPatches/"
                        "cap_sys_nice_begone.patch"))
    (sha256
     (base32 "0ya6b43m0ncjbyi6vyq3ipwwx6yj24cw8m167bd6ikwvdz5yi887"))))

(define-public linux-vr-mod
  (customize-linux
   #:linux
   (let ((linux-orig linux-6.17))
     (package/inherit linux-orig
       (source
        (origin
          (inherit (package-source linux-orig))
          (patches
           (append
            (list cap-sys-nice-patch
                  ;; no longer needed with 6.16:
                  ;; "0001-amd-pstate.patch"
                  (cachy-patch "0004-cachy"
                               "15x9s4wnf88a4jp7v41799yxb2a4ljh9bzc8j0gkaazbkshwd2gf")
                  (cachy-patch "sched/0001-bore-cachy"
                               "04334f4gxniv68j7nixk7dnfdfa7f2ygi1r8xpdknf1cn8vaykjv"))
            (origin-patches (package-source linux-orig))))))))
   #:name "linux-vr-mod"
   #:configs '("CONFIG_CACHY=y"
               "CONFIG_SCHED_BORE=y"
               "CONFIG_X86_64_VERSION=3")
   #:modconfig (local-file "/home/john/.config/modprobed.db")))

(operating-system
  (locale "en_US.utf8")
  (timezone "America/New_York")
  (keyboard-layout (keyboard-layout "us" #:options '("ctrl:swapcaps")))
  (host-name "narya")
  (users
   (cons* (user-account
            (name "john")
            (comment "John")
            (group "users")
            (home-directory "/home/john")
            (shell (file-append zsh "/bin/zsh"))
            (supplementary-groups '("wheel" "netdev" "audio" "video" "kvm")))
          %base-user-accounts))
  (packages
   (append
    (map specification->package '("xinitrc-xsession" "hyprland" "ntfs-3g"))
    %base-packages))
  (services
   (cons*
    (service
     pam-limits-service-type
     (list
      ;; higher open file limit, helpful for Wine and esync
      (pam-limits-entry "*" 'both 'nofile 524288)
      ;; lower nice limit for users, but root can go further to rescue system
      (pam-limits-entry "*" 'both 'nice -19)
      (pam-limits-entry "root" 'both 'nice -20)))
    (service kernel-module-loader-service-type '("ntsync"))
    (service pcscd-service-type)
    (service peroxide-service-type) ;testing
    (service
     bluetooth-service-type
     (bluetooth-configuration (fast-connectable? #t)
                              (privacy 'device)
                              (just-works-repairing 'always)))
    (udev-rules-service 'u2f libfido2 #:groups '("plugdev"))
    (udev-rules-service 'headsetcontrol headsetcontrol)
    (udev-rules-service 'steam-devices steam-devices-udev-rules)
    (udev-rules-service 'openrgb openrgb)
    (simple-service 'blueman dbus-root-service-type (list blueman))
    (simple-service 'ratbagd dbus-root-service-type (list libratbag))
    (simple-service 'corectrl-polkit polkit-service-type (list corectrl))
    ;; dbus files from corectrl are system-service files,
    ;; so need to add to dbus-root-service
    (simple-service 'corectrl-dbus dbus-root-service-type (list corectrl))
    ;;(geoclue-service)
    ;; to have geoclue in the system profile, so the agent autostart file is visible
    ;; (simple-service 'profile-geoclue profile-service-type
    ;;                 (list (specification->package "geoclue")))
    ;; fstrim seemed to be running at unexpected times and causing sleep problems
    ;; disable for now (June 2022)
    ;; (simple-service 'my-mcron-jobs
    ;;                 mcron-service-type
    ;;                 (list ; garbage-collector-job
    ;;                       fstrim-job))
    (service cups-service-type
             (cups-configuration
               (web-interface? #t)))
    (service syncthing-service-type
             (syncthing-configuration (user "john")))
    (set-xorg-configuration
     (xorg-configuration (extra-config
                          '("Section \"Device\"
                                                               Identifier \"device-amdgpu\"
                                                               Driver \"amdgpu\"
                                                               Option \"SWCursor\" \"on\"
                                                             EndSection")))
     gdm-service-type)
    (modify-services %desktop-services
      ;; don't use USB modems, scanners, or network-manager-applet
      (delete modem-manager-service-type)
      (delete usb-modeswitch-service-type)
      (delete sane-service-type)
      ;; not sure how to
      ;;(delete (specification->package "network-manager-applet"))
      ;; ignore the power key since a certain naughty kitten likes to press it
      (elogind-service-type
       config => (elogind-configuration (inherit config)
                                        (handle-power-key 'ignore)))
      ;; Set the default sample rate for the pulseaudio daemon to be 48000;
      ;; needed for the Valve Index mic, see
      ;; <https://github.com/ValveSoftware/SteamVR-for-Linux/issues/215#issuecomment-526791835>
      (delete pulseaudio-service-type)
      (guix-service-type
       config =>
       (guix-configuration
         (inherit config)
         (substitute-urls
          ;; Reverse the order to put Bordeaux first, adding in the US mirror
          (reverse (append '("https://substitutes.nonguix.org"
                             "https://cache-cdn.guix.moe")
                           %default-substitute-urls
                           '("https://bordeaux-us-east-mirror.cbaines.net/"))))
         (authorized-keys
          (append
           (list
            (local-file "substitutes.nonguix.org.pub")
            (plain-file "guix-moe.pub"
                        "(public-key (ecc (curve Ed25519) (q #552F670D5005D7EB6ACF05284A1066E52156B51D75DE3EBD3030CD046675D543#)))"))
           %default-authorized-guix-keys))))
      (sysctl-service-type
       config =>
       (sysctl-configuration
         (settings
          (append '(;; see <https://www.phoronix.com/news/Linux-Splitlock-Hurts-Gaming>
                    ("kernel.split_lock_mitigate" . "0")
                    ("vm.swappiness" . "10")
                    ;; potential performance or stability with some games and
                    ;; now a default in e.g. Arch
                    ("vm.max_map_count" . "1048576"))
                  %default-sysctl-settings)))))))
  (kernel linux-vr-mod)
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
  (firmware
   (cons* amdgpu-firmware
          realtek-firmware
          %base-firmware))
  ;; Use the UEFI variant of GRUB with the EFI System
  ;; Partition mounted on /boot/efi.
  (bootloader
    (bootloader-configuration
      (bootloader grub-efi-bootloader)
      (targets '("/boot/efi"))
      (keyboard-layout keyboard-layout)))

  (file-systems
   (append
    (list (file-system
            (device (file-system-label "system-new"))
            (mount-point "/")
            (type "btrfs")
            (flags '(no-atime))
            (options "subvol=root,compress=zstd,ssd"))
          (file-system
            (device (file-system-label "system-new"))
            (mount-point "/swap")
            (type "btrfs")
            (flags '(no-atime))
            (options "subvol=swap,ssd"))
          (file-system
            (device (file-system-label "system-new"))
            (mount-point "/gnu/store")
            (type "btrfs")
            (flags '(no-atime))
            (options "subvol=gnu-store,compress=zstd,ssd"))
          (file-system
            (device (file-system-label "system-new"))
            (mount-point "/var/log")
            (type "btrfs")
            (flags '(no-atime))
            (options "subvol=var-log,compress=zstd,ssd"))
          (file-system
            (device (file-system-label "system-new"))
            (mount-point "/home")
            (type "btrfs")
            (flags '(no-atime))
            (options "subvol=home,compress=zstd,ssd"))
          (file-system
            (device (uuid "8149-982B" 'fat))
            (mount-point "/boot/efi")
            (type "vfat"))
          (file-system
            (device (file-system-label "extra"))
            (mount-point "/mnt/extra")
            (type "ext4")
            (flags '(no-atime)))
          (file-system
            (device (file-system-label "nvmind"))
            (mount-point "/mnt/nvmind")
            (type "ext4")
            (flags '(no-atime))))
    %base-file-systems))

  (swap-devices
   (list
    (swap-space
      (target "/swap/swapfile")
      (dependencies (filter (file-system-mount-point-predicate "/swap")
                            file-systems))))))
