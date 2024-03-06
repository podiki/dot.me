;; This "home-environment" file can be passed to 'guix home reconfigure'
;; to reproduce the content of your profile.  This is "symbolic": it only
;; specifies package names.  To reproduce the exact same profile, you also
;; need to capture the channels being used, as returned by "guix describe".
;; See the "Replicating Guix" section in the manual.

(use-modules (gnu home)
             (gnu packages)
             (gnu services)
             (guix gexp)
             (gnu home services desktop)
             (gnu home services shepherd)
             (gnu home services sound))

(define goimapnotify-gmail-service
  (shepherd-service
   (documentation "Run 'goimapnotify', to watch a mailbox for events")
   (provision '(goimapnotify-gmail))
   (start #~(make-forkexec-constructor
             (list #$(file-append (specification->package "go-gitlab.com-shackra-goimapnotify")
                                  "/bin/goimapnotify")
                   "-conf"
                   "/home/john/gmail.conf")
             #:log-file "/home/john/test.log"))
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
             #:log-file "/home/john/testp.log"))
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
  ;;(packages (specifications->packages (list "heroic")))

  ;; Below is the list of Home services.  To search for available
  ;; services, run 'guix home search KEYWORD' in a terminal.
  (services
   (list (service home-dbus-service-type) ;; pipewire complains no dbus service
         (service home-pipewire-service-type)
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
