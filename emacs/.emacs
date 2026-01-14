;; first two lines (and last one reseting gc-cons-threshold) for faster
;; loading, via https://www.reddit.com/r/emacs/comments/3kqt6e/2_easy_little_known_steps_to_speed_up_emacs_start/
(let ((file-name-handler-alist nil))
  (setq gc-cons-threshold 100000000)

  (require 'package)
  (setq package-quickstart t)
  (setq package-enable-at-startup nil)   ; To prevent initialising twice

  ;; package archives: add MELPA
  (add-to-list 'package-archives
               '("melpa" . "https://melpa.org/packages/"))

  ;; bootstrap use-package
  ;; (unless (package-installed-p 'use-package)
  ;;   (package-refresh-contents)
  ;;   (package-install 'use-package))

  (eval-when-compile (require 'use-package))
  (require 'bind-key)
  (setq use-package-verbose 1)

  (load-file "~/codemonkey/dot.me/emacs/dotemacs.elc")
  ;; this could be nice instead of the save and compile hook, but
  ;; seems this always compiles the file even if no changes
  ;; (org-babel-load-file "~/codemonkey/dot.me/emacs/dotemacs.org" t)

  (setq gc-cons-threshold 800000))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-names-vector
   ["#282a36" "#ff6c6b" "#98be65" "#ECBE7B" "#51afef" "#c678dd" "#46D9FF"
    "#bbc2cf"])
 '(custom-safe-themes
   '("8db4b03b9ae654d4a57804286eb3e332725c84d7cdab38463cb6b97d5762ad26"
     "b571f92c9bfaf4a28cb64ae4b4cdbda95241cd62cf07d942be44dc8f46c491f4"
     "f5eb916f6bd4e743206913e6f28051249de8ccfd070eae47b5bde31ee813d55f"
     "26614652a4b3515b4bbbb9828d71e206cc249b67c9142c06239ed3418eff95e2"
     "f0b0710b7e1260ead8f7808b3ee13c3bb38d45564e369cbe15fc6d312f0cd7a0"
     "3c83b3676d796422704082049fc38b6966bcad960f896669dfc21a7a37a748fa"
     "e56f1b1c1daec5dbddc50abd00fcd00f6ce4079f4a7f66052cf16d96412a09a9"
     "b71d5d49d0b9611c0afce5c6237aacab4f1775b74e513d8ba36ab67dfab35e5a"
     "628278136f88aa1a151bb2d6c8a86bf2b7631fbea5f0f76cba2a0079cd910f7d"
     "1b8d67b43ff1723960eb5e0cba512a2c7a2ad544ddb2533a90101fd1852b426e"
     "bb08c73af94ee74453c90422485b29e5643b73b05e8de029a6909af6a3fb3f58"
     "fc5fcb6f1f1c1bc01305694c59a1a861b008c534cae8d0e48e4d5e81ad718bc6"
     "9dae95cdbed1505d45322ef8b5aa90ccb6cb59e0ff26fef0b8f411dfc416c552"
     "1e7e097ec8cb1f8c3a912d7e1e0331caeed49fef6cff220be63bd2a6ba4cc365"
     "756597b162f1be60a12dbd52bab71d40d6a2845a3e3c2584c6573ee9c332a66e"
     "cdc7555f0b34ed32eb510be295b6b967526dd8060e5d04ff0dce719af789f8e5"
     "6a37be365d1d95fad2f4d185e51928c789ef7a4ccf17e7ca13ad63a8bf5b922f"
     default))
 '(debug-on-error nil)
 '(fci-rule-color "#5B6268")
 '(hl-todo-keyword-faces
   '(("TODO" . "#dc752f") ("NEXT" . "#dc752f") ("THEM" . "#2d9574")
     ("PROG" . "#3a81c3") ("OKAY" . "#3a81c3") ("DONT" . "#f2241f")
     ("FAIL" . "#f2241f") ("DONE" . "#42ae2c") ("NOTE" . "#b1951d")
     ("KLUDGE" . "#b1951d") ("HACK" . "#b1951d") ("TEMP" . "#b1951d")
     ("FIXME" . "#dc752f") ("XXX+" . "#dc752f")
     ("\\?\\?\\?+" . "#dc752f")))
 '(jdee-db-active-breakpoint-face-colors (cons "#1B2229" "#51afef"))
 '(jdee-db-requested-breakpoint-face-colors (cons "#1B2229" "#98be65"))
 '(jdee-db-spec-breakpoint-face-colors (cons "#1B2229" "#3f444a"))
 '(objed-cursor-color "#ff6c6b")
 '(org-msg-mode t)
 '(package-selected-packages
   '(advice-patch all-the-icons-dired biblio bui calfw
                  color-identifiers-mode company-auctex company-math
                  company-quickhelp consult dashboard diminish
                  dired-git-info diredfl doom-modeline doom-themes
                  edit-indirect eglot emms exec-path-from-shell
                  flycheck-ledger fountain-mode frames-only-mode
                  geiser-guile goto-chg highlight-sexp
                  highlight-symbol ido-completing-read+
                  ido-vertical-mode ledger-mode magit magit-popup
                  marginalia markdown-mode mixed-pitch monokai-theme
                  mu4e-alert mu4e-marker-icons multiple-cursors
                  neotree olivetti orderless org-appear
                  org-auto-tangle org-bullets org-cliplink org-contrib
                  org-gcal org-modern org-msg org-noter org-present
                  org-re-reveal org-ref org-super-agenda org-superstar
                  org2blog ox-reveal page-break-lines parsebib
                  rainbow-delimiters slime-company smartparens smex
                  solaire-mode spacemacs-theme tablist use-package
                  vertico-posframe visual-fill-column which-key))
 '(paradox-github-token t)
 '(pdf-view-midnight-colors '("#655370" . "#fbf8ef"))
 '(rustic-ansi-faces
   ["#282c34" "#ff6c6b" "#98be65" "#ECBE7B" "#51afef" "#c678dd" "#46D9FF"
    "#bbc2cf"])
 '(safe-local-variable-values
   '((lisp-fill-paragraphs-as-doc-string nil)
     (eval with-eval-after-load 'git-commit
           (add-to-list 'git-commit-trailers "Change-Id"))
     (eval with-eval-after-load 'tempel
           (if (stringp tempel-path)
               (setq tempel-path (list tempel-path)))
           (let
               ((guix-tempel-snippets
                 (concat
                  (expand-file-name "etc/snippets/tempel"
                                    (locate-dominating-file
                                     default-directory
                                     ".dir-locals.el"))
                  "/*.eld")))
             (unless (member guix-tempel-snippets tempel-path)
               (add-to-list 'tempel-path guix-tempel-snippets))))
     (geiser-insert-actual-lambda) (geiser-guile-binary "guix" "repl")
     (geiser-repl-per-project-p . t)
     (eval let
           ((root-dir-unexpanded
             (locate-dominating-file default-directory
                                     ".dir-locals.el")))
           (when root-dir-unexpanded
             (let*
                 ((root-dir
                   (file-local-name
                    (expand-file-name root-dir-unexpanded)))
                  (root-dir* (directory-file-name root-dir)))
               (unless (boundp 'geiser-guile-load-path)
                 (defvar geiser-guile-load-path 'nil))
               (make-local-variable 'geiser-guile-load-path)
               (require 'cl-lib)
               (cl-pushnew root-dir* geiser-guile-load-path :test
                           #'string-equal))))
     (eval with-eval-after-load 'yasnippet
           (let
               ((guix-yasnippets
                 (expand-file-name "etc/snippets/yas"
                                   (locate-dominating-file
                                    default-directory ".dir-locals.el"))))
             (unless (member guix-yasnippets yas-snippet-dirs)
               (add-to-list 'yas-snippet-dirs guix-yasnippets)
               (yas-reload-all))))
     (eval add-to-list 'completion-ignored-extensions ".go")
     (eval progn (require 'lisp-mode)
           (defun emacs27-lisp-fill-paragraph (&optional justify)
             (interactive "P")
             (or (fill-comment-paragraph justify)
                 (let
                     ((paragraph-start
                       (concat paragraph-start
                               "\\|\\s-*\\([(;\"]\\|\\s-:\\|`(\\|#'(\\)"))
                      (paragraph-separate
                       (concat paragraph-separate
                               "\\|\\s-*\".*[,\\.]$"))
                      (fill-column
                       (if
                           (and
                            (integerp emacs-lisp-docstring-fill-column)
                            (derived-mode-p 'emacs-lisp-mode))
                           emacs-lisp-docstring-fill-column
                         fill-column)))
                   (fill-paragraph justify))
                 t))
           (setq-local fill-paragraph-function
                       #'emacs27-lisp-fill-paragraph))
     (eval modify-syntax-entry 43 "'")
     (eval modify-syntax-entry 36 "'")
     (eval modify-syntax-entry 126 "'")
     (eval let
           ((root-dir-unexpanded
             (locate-dominating-file default-directory
                                     ".dir-locals.el")))
           (when root-dir-unexpanded
             (let*
                 ((root-dir (expand-file-name root-dir-unexpanded))
                  (root-dir* (directory-file-name root-dir)))
               (unless (boundp 'geiser-guile-load-path)
                 (defvar geiser-guile-load-path 'nil))
               (make-local-variable 'geiser-guile-load-path)
               (require 'cl-lib)
               (cl-pushnew root-dir* geiser-guile-load-path :test
                           #'string-equal))))
     (eval setq-local guix-directory
           (locate-dominating-file default-directory ".dir-locals.el"))
     (org-export-allow-bind-keywords . t)
     (eval add-hook 'after-save-hook
           (lambda nil
             (org-babel-tangle-file (expand-file-name "dotemacs.org"))
             (byte-compile-file (expand-file-name "dotemacs.el")))
           nil t)))
 '(timesheet-invoice-number 2)
 '(vc-annotate-background "#282c34")
 '(vc-annotate-color-map
   (list (cons 20 "#98be65") (cons 40 "#b4be6c") (cons 60 "#d0be73")
         (cons 80 "#ECBE7B") (cons 100 "#e6ab6a") (cons 120 "#e09859")
         (cons 140 "#da8548") (cons 160 "#d38079")
         (cons 180 "#cc7cab") (cons 200 "#c678dd")
         (cons 220 "#d974b7") (cons 240 "#ec7091")
         (cons 260 "#ff6c6b") (cons 280 "#cf6162")
         (cons 300 "#9f585a") (cons 320 "#6f4e52")
         (cons 340 "#5B6268") (cons 360 "#5B6268")))
 '(vc-annotate-very-old-color nil)
 '(warning-suppress-types '((comp))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
