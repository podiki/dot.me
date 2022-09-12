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
             (gnu packages display-managers) ; for sddm
             (guix profiles) ;; For manifest-entries
             (srfi srfi-1) ;; For filter-map
             (gnu packages hardware) ;; openrgb
             (gnu packages security-token) ;; for libu2f-host (udev rule)
             (openrgb) ;; for corectrl
             (gnu packages gnome)) ;; for libratbag (piper)

(use-service-modules
 cups
 dbus
 desktop
 docker
 mcron
 networking
 security-token ; for pcscd
 sddm
 sound
 ssh
 syncthing
 sysctl
 xorg)

(use-modules (guix transformations))

(define transform1
  (options->transformation
    '((with-git-url
        .
        "openrgb=https://gitlab.com/Celmerine/OpenRGB")
      (with-branch . "openrgb=lian_li_al120"))))

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

;; From https://guix.gnu.org/cookbook/en/html_node/Customizing-the-Kernel.html
;; and https://gitlab.com/nonguix/nonguix/-/issues/42#note_931635766
(define-public my-linux-libre
  ;; XXX: Access the internal 'make-linux-libre*' procedure, which is
  ;; private and unexported, and is liable to change in the future.
  ((@@ (gnu packages linux) make-linux-libre*)
   (@@ (gnu packages linux) linux-libre-version)
   (@@ (gnu packages linux) linux-libre-gnu-revision)
   (@@ (gnu packages linux) linux-libre-source)
   '("x86_64-linux")
   #:configuration-file (@@ (gnu packages linux) kernel-config)
   #:extra-options
   ;; Appending works even when the option wasn't in the
   ;; file.  The last one prevails if duplicated.
   (append
    ;; sets CONFIG_HSA_AMD for ROCm OpenCL support, see
    ;; https://issues.guix.gnu.org/55111
    `(("CONFIG_HSA_AMD" . #true))
    (@@ (gnu packages linux) %default-extra-linux-options))))

;; (define-public my-corrupt-linux
;;   ;; can get version of latest linux-libre as linux-libre-version
;;   ;; but not sure how to get the hash from nonguix's linux
;;   (corrupt-linux my-linux-libre "5.17.15"
;;                  "0a5n1lb43nhnhwjwclkk3dqp2nxsx5ny7zfl8idvzshf94m9472a"))

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
                    '("wheel" "netdev" "audio" "video" "docker")))
                %base-user-accounts))
  (packages
    (append
      (list (specification->package "xinitrc-xsession")
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
             (service peroxide-service-type) ;testing
             ;; suddenly needed (after staging merge in June 2022?)
             ;; should be switched to libfido2 but waiting for this patch:
             ;; https://issues.guix.gnu.org/52900
             (udev-rules-service 'u2f libu2f-host #:groups '("plugdev"))
             (udev-rules-service 'headsetcontrol headsetcontrol)
             (udev-rules-service 'steam-devices steam-devices-udev-rules)
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
             (service sddm-service-type (sddm-configuration))
             (service docker-service-type)
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
                                                   ;; Reverse the order to put Bordeaux first
                                                   (reverse (append (list "http://substitutes.guix.sama.re"
                                                                          "https://substitutes.nonguix.org")
                                                                    %default-substitute-urls)))
                                                  (authorized-keys
                                                   (append (list (local-file "substitutes.nonguix.org.pub")
                                                                 (local-file "substitutes.guix.sama.re.pub"))
                                                           %default-authorized-guix-keys))))
                              (udev-service-type config =>
                                                 (udev-configuration
                                                  (inherit config)
                                                  (rules (cons (transform1 openrgb) ;openrgb
                                                               (udev-configuration-rules config)))))
                              (sysctl-service-type config =>
                                                   (sysctl-configuration
                                                    (settings (append '(("vm.swappiness" . "10"))
                                                                      %default-sysctl-settings)))))))

  ;; (kernel my-corrupt-linux)
  (kernel linux)
  (kernel-loadable-modules (list v4l2loopback-linux-module))
  (kernel-arguments
   '("quiet"
     "splash"
     ;; Disable the PC speaker (do they still exist?)
     "modprobe.blacklist=pcspkr,snd_pcsp"
     ;; Enable more amdgpu features, e.g. controling power/performance with corectrl
     "amdgpu.ppfeaturemask=0xffffffff"))
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
