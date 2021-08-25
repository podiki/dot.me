;; This "manifest" file can be passed to 'guix package -m' to reproduce
;; the content of your profile.  This is "symbolic": it only specifies
;; package names.  To reproduce the exact same profile, you also need to
;; capture the channels being used, as returned by "guix describe".
;; See the "Replicating Guix" section in the manual.

(use-modules (guix transformations))

(define transform1
  (options->transformation
    '((with-git-url
        .
        "emacs-guix=https://github.com/alezost/guix.el"))))

(concatenate-manifests
  (list
    (specifications->manifest
      '("emacs-pgtk-native-comp"
        "emacs-pdf-tools"
        "emacs-use-package"
        ;; mail
        "mu"
        "isync"
        "go-gitlab.com-shackra-goimapnotify"))
    (packages->manifest
     (list
      (transform1
       (specification->package
        "emacs-guix"))))))
