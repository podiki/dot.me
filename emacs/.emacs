;; first two lines (and last one reseting gc-cons-threshold) for faster
;; loading, via https://www.reddit.com/r/emacs/comments/3kqt6e/2_easy_little_known_steps_to_speed_up_emacs_start/
(let ((file-name-handler-alist nil))
  (setq gc-cons-threshold 100000000)

  (require 'package)
  (setq package-enable-at-startup nil)   ; To prevent initialising twice

  ;; package archives: org and melpa
  (add-to-list 'package-archives
               '("org" . "http://orgmode.org/elpa/") t)
  (add-to-list 'package-archives
               '("melpa" . "https://melpa.org/packages/"))
  (add-to-list 'package-archives
               '("melpa-stable" . "https://stable.melpa.org/packages/"))
  
  (package-initialize)

  ;; bootstrap use-package
  (unless (package-installed-p 'use-package)
    (package-refresh-contents)
    (package-install 'use-package))

  ;; requiring use-package was with eval-when-compile but that gave some
  ;; eager macro expansion warning of not finding the file
  ;; (and maybe slightly faster without too)
  (require 'use-package)
  (require 'bind-key)
  (setq use-package-verbose 1
        use-package-always-ensure t)

  (org-babel-load-file "~/codemonkey/dot.me/emacs/dotemacs.org")
  (custom-set-variables
   ;; custom-set-variables was added by Custom.
   ;; If you edit it by hand, you could mess it up, so be careful.
   ;; Your init file should contain only one such instance.
   ;; If there is more than one, they won't work right.
   '(custom-safe-themes
     (quote
      ("f0dc4ddca147f3c7b1c7397141b888562a48d9888f1595d69572db73be99a024" "8db4b03b9ae654d4a57804286eb3e332725c84d7cdab38463cb6b97d5762ad26" "b571f92c9bfaf4a28cb64ae4b4cdbda95241cd62cf07d942be44dc8f46c491f4" "f5eb916f6bd4e743206913e6f28051249de8ccfd070eae47b5bde31ee813d55f" "26614652a4b3515b4bbbb9828d71e206cc249b67c9142c06239ed3418eff95e2" "f0b0710b7e1260ead8f7808b3ee13c3bb38d45564e369cbe15fc6d312f0cd7a0" "3c83b3676d796422704082049fc38b6966bcad960f896669dfc21a7a37a748fa" "e56f1b1c1daec5dbddc50abd00fcd00f6ce4079f4a7f66052cf16d96412a09a9" "b71d5d49d0b9611c0afce5c6237aacab4f1775b74e513d8ba36ab67dfab35e5a" "628278136f88aa1a151bb2d6c8a86bf2b7631fbea5f0f76cba2a0079cd910f7d" "1b8d67b43ff1723960eb5e0cba512a2c7a2ad544ddb2533a90101fd1852b426e" "bb08c73af94ee74453c90422485b29e5643b73b05e8de029a6909af6a3fb3f58" "fc5fcb6f1f1c1bc01305694c59a1a861b008c534cae8d0e48e4d5e81ad718bc6" "9dae95cdbed1505d45322ef8b5aa90ccb6cb59e0ff26fef0b8f411dfc416c552" "1e7e097ec8cb1f8c3a912d7e1e0331caeed49fef6cff220be63bd2a6ba4cc365" "756597b162f1be60a12dbd52bab71d40d6a2845a3e3c2584c6573ee9c332a66e" "cdc7555f0b34ed32eb510be295b6b967526dd8060e5d04ff0dce719af789f8e5" "6a37be365d1d95fad2f4d185e51928c789ef7a4ccf17e7ca13ad63a8bf5b922f" default)))
   '(debug-on-error nil)
   '(ivy-mode t)
   '(org-msg-mode nil)
   '(package-selected-packages
     (quote
      (org-variable-pitch dashboard ivy-rich ivy-posframe advice-patch org-cliplink visual-fill-column dired-git-info diredfl dired cdlatex org-noter org-ref mu4e-conversation counsel ivy let-alist org-msg org-mime mu4e-alert notmuch org-super-agenda calfw calfw-org org-gcal flycheck-ledger ledger-mode org-analyzer org-re-reveal pdf-tools solaire-mode hlinum doom-themes doom-modeline which-key use-package timesheet spacemacs-theme spaceline-all-the-icons smex smartparens slime-company rainbow-delimiters paradox ox-reveal org2blog org-plus-contrib org-bullets olivetti neotree multiple-cursors monokai-theme molokai-theme markdown-mode magit latex-pretty-symbols langtool imenu-list ido-vertical-mode ido-ubiquitous highlight-symbol highlight-sexp goto-chg fountain-mode flycheck-color-mode-line flx-ido exec-path-from-shell emms ein diminish define-word cython-mode company-quickhelp company-math company-jedi company-auctex color-theme-solarized color-identifiers-mode all-the-icons-dired)))
   '(paradox-github-token t)
   '(pdf-view-midnight-colors (quote ("#655370" . "#fbf8ef")))
   '(timesheet-invoice-number 2))

  (custom-set-faces
   ;; custom-set-faces was added by Custom.
   ;; If you edit it by hand, you could mess it up, so be careful.
   ;; Your init file should contain only one such instance.
   ;; If there is more than one, they won't work right.
   )

  (setq gc-cons-threshold 800000))
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("f0dc4ddca147f3c7b1c7397141b888562a48d9888f1595d69572db73be99a024" "8db4b03b9ae654d4a57804286eb3e332725c84d7cdab38463cb6b97d5762ad26" "b571f92c9bfaf4a28cb64ae4b4cdbda95241cd62cf07d942be44dc8f46c491f4" "f5eb916f6bd4e743206913e6f28051249de8ccfd070eae47b5bde31ee813d55f" "26614652a4b3515b4bbbb9828d71e206cc249b67c9142c06239ed3418eff95e2" "f0b0710b7e1260ead8f7808b3ee13c3bb38d45564e369cbe15fc6d312f0cd7a0" "3c83b3676d796422704082049fc38b6966bcad960f896669dfc21a7a37a748fa" "e56f1b1c1daec5dbddc50abd00fcd00f6ce4079f4a7f66052cf16d96412a09a9" "b71d5d49d0b9611c0afce5c6237aacab4f1775b74e513d8ba36ab67dfab35e5a" "628278136f88aa1a151bb2d6c8a86bf2b7631fbea5f0f76cba2a0079cd910f7d" "1b8d67b43ff1723960eb5e0cba512a2c7a2ad544ddb2533a90101fd1852b426e" "bb08c73af94ee74453c90422485b29e5643b73b05e8de029a6909af6a3fb3f58" "fc5fcb6f1f1c1bc01305694c59a1a861b008c534cae8d0e48e4d5e81ad718bc6" "9dae95cdbed1505d45322ef8b5aa90ccb6cb59e0ff26fef0b8f411dfc416c552" "1e7e097ec8cb1f8c3a912d7e1e0331caeed49fef6cff220be63bd2a6ba4cc365" "756597b162f1be60a12dbd52bab71d40d6a2845a3e3c2584c6573ee9c332a66e" "cdc7555f0b34ed32eb510be295b6b967526dd8060e5d04ff0dce719af789f8e5" "6a37be365d1d95fad2f4d185e51928c789ef7a4ccf17e7ca13ad63a8bf5b922f" default)))
 '(debug-on-error nil)
 '(fci-rule-color "#484a42")
 '(ivy-mode t)
 '(jdee-db-active-breakpoint-face-colors (cons "#efefef" "#0098dd"))
 '(jdee-db-requested-breakpoint-face-colors (cons "#efefef" "#50a14f"))
 '(jdee-db-spec-breakpoint-face-colors (cons "#efefef" "#a0a1a7"))
 '(objed-cursor-color "#e45649")
 '(org-msg-mode t)
 '(package-selected-packages
   (quote
    (org-table org-superstar org-superstar-mode counsel-org-clock ivy-hydra org-variable-pitch dashboard ivy-rich ivy-posframe advice-patch org-cliplink visual-fill-column dired-git-info diredfl dired cdlatex org-noter org-ref mu4e-conversation counsel ivy let-alist org-msg org-mime mu4e-alert notmuch calfw calfw-org org-gcal flycheck-ledger ledger-mode org-analyzer org-re-reveal pdf-tools solaire-mode hlinum doom-themes doom-modeline which-key use-package timesheet spacemacs-theme spaceline-all-the-icons smex smartparens slime-company rainbow-delimiters paradox ox-reveal org2blog org-plus-contrib org-bullets olivetti neotree multiple-cursors monokai-theme molokai-theme markdown-mode magit latex-pretty-symbols langtool imenu-list ido-vertical-mode ido-ubiquitous highlight-symbol highlight-sexp goto-chg fountain-mode flycheck-color-mode-line flx-ido exec-path-from-shell emms ein diminish define-word cython-mode company-quickhelp company-math company-jedi company-auctex color-theme-solarized color-identifiers-mode all-the-icons-dired)))
 '(paradox-github-token t)
 '(pdf-view-midnight-colors (quote ("#655370" . "#fbf8ef")))
 '(timesheet-invoice-number 2)
 '(vc-annotate-background "#f0f0f0")
 '(vc-annotate-color-map
   (list
    (cons 20 "#50a14f")
    (cons 40 "#74a334")
    (cons 60 "#98a51a")
    (cons 80 "#bda800")
    (cons 100 "#c69c18")
    (cons 120 "#d09030")
    (cons 140 "#da8548")
    (cons 160 "#c86566")
    (cons 180 "#b74585")
    (cons 200 "#a626a4")
    (cons 220 "#ba3685")
    (cons 240 "#cf4667")
    (cons 260 "#e45649")
    (cons 280 "#d36860")
    (cons 300 "#c27b78")
    (cons 320 "#b18e8f")
    (cons 340 "#484a42")
    (cons 360 "#484a42")))
 '(vc-annotate-very-old-color nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
