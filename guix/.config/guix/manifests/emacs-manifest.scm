;; This "manifest" file can be passed to 'guix package -m' to reproduce
;; the content of your profile.  This is "symbolic": it only specifies
;; package names.  To reproduce the exact same profile, you also need to
;; capture the channels being used, as returned by "guix describe".
;; See the "Replicating Guix" section in the manual.

(use-modules (guix transformations))

(define native-comp
  (options->transformation
   '((with-input . "emacs-minimal=emacs-pgtk"))))

(define org-msg-fix
  (options->transformation
    '((with-input . "emacs-minimal=emacs-pgtk")
      (with-branch . "emacs-org-msg=1.12")
      (with-git-url
        .
        "emacs-org-msg=https://github.com/danielfleischer/org-msg"))))

(concatenate-manifests
 (list (packages->manifest
        (list (org-msg-fix (specification->package "emacs-org-msg"))))
       (packages->manifest
        (map native-comp
             (map specification->package
                  '("emacs-visual-fill-column"
                    "emacs-goto-chg"
                    "emacs-frames-only-mode"
                    "emacs-paradox"
                    "emacs-exec-path-from-shell"
                    "emacs-color-theme-solarized"
                                        ;"emacs-molokai-theme"
                    "emacs-monokai-theme"
                    "emacs-spacemacs-theme"
                    "emacs-doom-themes"
                    "emacs-solaire-mode"
                    "emacs-mixed-pitch"
                    ;; native comp fail "emacs-powerline"
                    ;; native comp fail for powerline "emacs-spaceline-all-the-icons"
                    "emacs-doom-modeline"
                    "emacs-dashboard"
                    "emacs-ido-completing-read+"
                    "emacs-ido-vertical-mode"
                    "emacs-smex"
                    "emacs-multiple-cursors"
                    "emacs-orderless"
                    ;"emacs-ivy"
                    ;"emacs-swiper"
                    ;"emacs-counsel"
                    ;"emacs-ivy-posframe"
                    ;"emacs-ivy-rich"
                    ;"emacs-counsel-org-clock"
                    ;"emacs-hydra"
                    ;"emacs-ivy-hydra"
                    "emacs-consult"
                    "emacs-which-key"
                    ;"emacs-color-identifiers-mode"
                    "emacs-highlight-symbol"
                    ;"emacs-define-word"
                    "emacs-langtool"
                    "emacs-neotree"
                    "emacs-diredfl"
                    "emacs-dired-git-info"
                    "emacs-org"
                    "emacs-org-contrib"
                    "emacs-org-superstar"
                    "emacs-org-bullets"
                    "emacs-org-modern"
                    "emacs-org-appear"
                    "emacs-org-present"
                    "emacs-htmlize"
                    "emacs-org-re-reveal"
                    "emacs-ox-reveal"
                    ;"emacs-org2blog"
                    ;"emacs-org-gcal"
                    "emacs-calfw"
                    "emacs-org-super-agenda"
                    "emacs-org-ref"
                    "emacs-org-noter"
                    ;"emacs-advice-patch"
                    "emacs-org-cliplink"
                    "emacs-org-auto-tangle"
                    ;"emacs-org-msg"
                    "emacs-mu4e-alert"
                    ;"emacs-mu4e-marker-icons"
                    "emacs-magit"
                    "emacs-company"
                    "emacs-company-quickhelp"
                    "emacs-company"
                    "emacs-flycheck"
                    ;"emacs-flycheck-color-mode-line"
                    "emacs-rainbow-delimiters"
                    "emacs-smartparens"
                    "emacs-slime"
                    "emacs-slime-company"
                    ;"emacs-info-look"
                    ;"emacs-cython-mode"
                    ;"emacs-python-mode"
                    ;"emacs-company-jedi"
                    ;"emacs-haxe-mode"
                    "emacs-eglot"
                    "emacs-fountain-mode"
                    "emacs-markdown-mode"
                    "emacs-olivetti"
                    "emacs-ledger-mode"
                    "emacs-flycheck-ledger"
                    "emacs-auctex"
                    ;"emacs-latex-pretty-symbols"
                    "emacs-company-auctex"
                    "emacs-company-math"
                    "emacs-emms"
                    "emacs-nerd-icons"
                    "emacs-all-the-icons"
                    "emacs-all-the-icons-dired"
                    "emacs-pgtk"
                    "emacs-pdf-tools"
                    "emacs-use-package"
                    "guile"
                    "emacs-debbugs"
                    "emacs-geiser"
                    "emacs-geiser-guile"
                    "emacs-guix"
                    "emacs-yasnippet"
                    "emacs-highlight-sexp"
                    "emacs-ledger-mode"
                    "emacs-vertico"
                    "emacs-vertico-posframe"
                    "emacs-marginalia"
                    "python-lsp-server"
                    "emacs-docker-compose-mode"
                    "emacs-eat"
                    ;; mail
                    "mu"
                    "oauth2ms"
                    "isync"
                    "go-gitlab.com-shackra-goimapnotify"))))))
