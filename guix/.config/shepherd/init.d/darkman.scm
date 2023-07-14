(define darkman
  (make <service>
    #:provides '(darkman)
    #:docstring "Run 'darkman', a system light/dark theme service"
    #:start (make-forkexec-constructor
             (list "bash" ;; probably whole thing should be gexp and file-append here?
                   "-c"
                   "darkman run 2>&1 | logger --tag=darkman"))
    #:stop (make-kill-destructor)
    #:respawn? #t))

(register-services darkman)

(start darkman)
