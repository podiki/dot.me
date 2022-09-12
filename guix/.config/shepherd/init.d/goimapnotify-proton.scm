(define goimapnotify-proton
  (make <service>
    #:provides '(goimapnotify-proton)
    #:docstring "Run 'goimapnotify', to watch a mailbox for events"
    #:start (make-forkexec-constructor
             (list "bash" ;; probably whole thing should be gexp and file-append here?
                   "-c"
                   "goimapnotify -conf ~/proton.conf 2>&1 | logger --tag=goimapnotify-proton"))
    #:stop (make-kill-destructor)
    #:respawn? #t))

(register-services goimapnotify-proton)

(start goimapnotify-proton)
