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
