;; This "manifest" file can be passed to 'guix package -m' to reproduce
;; the content of your profile.  This is "symbolic": it only specifies
;; package names.  To reproduce the exact same profile, you also need to
;; capture the channels being used, as returned by "guix describe".
;; See the "Replicating Guix" section in the manual.

(use-modules (guix transformations))

(define native-comp
  (options->transformation
   '((with-input . "emacs-minimal=emacs"))))

(packages->manifest
 (map native-comp
      (map specification->package
           '("emacs"
             "emacs-pdf-tools"
             "emacs-use-package"
             "emacs-guix"
             "emacs-highlight-sexp"
             "emacs-ledger-mode"
             "emacs-vertico"
             "emacs-vertico-posframe"
             "emacs-marginalia"
             "python-lsp-server"
             ;; mail
             "mu"
             "oauth2ms"
             "isync"
             "go-gitlab.com-shackra-goimapnotify"))))
