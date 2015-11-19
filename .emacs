(require 'package)
(setq package-enable-at-startup nil)   ; To prevent initialising twice
(add-to-list 'package-archives '("melpa" . "https://stable.melpa.org/packages/"))

(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(eval-when-compile
  (require 'use-package))

(org-babel-load-file "~/codemonkey/dot.me/dotemacs.org")
