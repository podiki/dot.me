(require 'package)
(setq package-enable-at-startup nil)   ; To prevent initialising twice

;; package archives, org, melpa, and marmalade
(add-to-list 'package-archives
             '("org" . "http://orgmode.org/elpa/") t)
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/"))
(add-to-list 'package-archives
             '("melpa-stable" . "https://stable.melpa.org/packages/"))
;; (add-to-list 'package-archives
;;              '("marmalade" . "https://marmalade-repo.org/packages/"))

(package-initialize)

;; bootstrap use-package
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(eval-when-compile
  (require 'use-package))
(setq use-package-always-ensure t)

(org-babel-load-file "~/codemonkey/dot.me/emacs/dotemacs.org")
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("8db4b03b9ae654d4a57804286eb3e332725c84d7cdab38463cb6b97d5762ad26" "b571f92c9bfaf4a28cb64ae4b4cdbda95241cd62cf07d942be44dc8f46c491f4" "f5eb916f6bd4e743206913e6f28051249de8ccfd070eae47b5bde31ee813d55f" "26614652a4b3515b4bbbb9828d71e206cc249b67c9142c06239ed3418eff95e2" "f0b0710b7e1260ead8f7808b3ee13c3bb38d45564e369cbe15fc6d312f0cd7a0" "3c83b3676d796422704082049fc38b6966bcad960f896669dfc21a7a37a748fa" "e56f1b1c1daec5dbddc50abd00fcd00f6ce4079f4a7f66052cf16d96412a09a9" "b71d5d49d0b9611c0afce5c6237aacab4f1775b74e513d8ba36ab67dfab35e5a" "628278136f88aa1a151bb2d6c8a86bf2b7631fbea5f0f76cba2a0079cd910f7d" "1b8d67b43ff1723960eb5e0cba512a2c7a2ad544ddb2533a90101fd1852b426e" "bb08c73af94ee74453c90422485b29e5643b73b05e8de029a6909af6a3fb3f58" "fc5fcb6f1f1c1bc01305694c59a1a861b008c534cae8d0e48e4d5e81ad718bc6" "9dae95cdbed1505d45322ef8b5aa90ccb6cb59e0ff26fef0b8f411dfc416c552" "1e7e097ec8cb1f8c3a912d7e1e0331caeed49fef6cff220be63bd2a6ba4cc365" "756597b162f1be60a12dbd52bab71d40d6a2845a3e3c2584c6573ee9c332a66e" "cdc7555f0b34ed32eb510be295b6b967526dd8060e5d04ff0dce719af789f8e5" "6a37be365d1d95fad2f4d185e51928c789ef7a4ccf17e7ca13ad63a8bf5b922f" default)))
 '(package-selected-packages
   (quote
    (cython-mode company-jedi ein which-key use-package spacemacs-theme spaceline-all-the-icons smex smartparens slime-company rainbow-delimiters paradox ox-reveal org2blog org-plus-contrib olivetti neotree multiple-cursors monokai-theme molokai-theme markdown-mode magit latex-pretty-symbols langtool imenu-list ido-vertical-mode ido-ubiquitous htmlize highlight-symbol highlight-sexp goto-chg fountain-mode flycheck-color-mode-line flx-ido exec-path-from-shell emms define-word company-quickhelp company-math company-auctex color-theme-solarized color-identifiers-mode arch-packer all-the-icons-dired)))
 '(paradox-github-token t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
