(define goimapnotify
  (make <service>
    #:provides '(goimapnotify)
    #:docstring "Run 'goimapnotify', to watch a mailbox for events"
    #:start (make-forkexec-constructor
             (list "bash" ;; probably whole thing should be gexp and file-append here?
                   "-c"
                   "goimapnotify -conf ~/gmail.conf 2>&1 | logger --tag=goimapnotify"))
    #:stop (make-kill-destructor)
    #:respawn? #t))

(register-services goimapnotify)

(start goimapnotify)
