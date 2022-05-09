;; This "manifest" file can be passed to 'guix package -m' to reproduce
;; the content of your profile.  This is "symbolic": it only specifies
;; package names.  To reproduce the exact same profile, you also need to
;; capture the channels being used, as returned by "guix describe".
;; See the "Replicating Guix" section in the manual.

(specifications->manifest
  '("emacs-pgtk-native-comp"
    "emacs-pdf-tools"
    "emacs-use-package"
    "emacs-guix"
    "emacs-highlight-sexp"
    "emacs-ledger-mode"
    "emacs-ivy"
    "emacs-counsel"
    "emacs-swiper"
    "emacs-ivy-posframe"
    "emacs-ivy-rich"
    "emacs-hydra"
    "emacs-ivy-hydra"
    ;; mail
    "mu"
    "isync"
    "go-gitlab.com-shackra-goimapnotify"))
