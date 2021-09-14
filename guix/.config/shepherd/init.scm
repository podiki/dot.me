;; init.scm -- default shepherd configuration file.
;; from: https://guix.gnu.org/blog/2020/gnu-shepherd-user-services/

(use-modules (shepherd service)
             ((ice-9 ftw) #:select (scandir)))

;; Load all the files in the directory 'init.d' with a suffix '.scm'.
(for-each
  (lambda (file)
    (load (string-append "init.d/" file)))
  (scandir (string-append (dirname (current-filename)) "/init.d")
           (lambda (file)
             (string-suffix? ".scm" file))))

;; Send shepherd into the background
(action 'shepherd 'daemonize)
