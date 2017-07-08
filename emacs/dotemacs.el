(custom-set-variables
   ;; custom-set-variables was added by Custom.
   ;; If you edit it by hand, you could mess it up, so be careful.
   ;; Your init file should contain only one such instance.
   ;; If there is more than one, they won't work right.
   '(custom-safe-themes
     (quote
       ("8db4b03b9ae654d4a57804286eb3e332725c84d7cdab38463cb6b97d5762ad26" "b571f92c9bfaf4a28cb64ae4b4cdbda95241cd62cf07d942be44dc8f46c491f4" "f5eb916f6bd4e743206913e6f28051249de8ccfd070eae47b5bde31ee813d55f" "26614652a4b3515b4bbbb9828d71e206cc249b67c9142c06239ed3418eff95e2" "f0b0710b7e1260ead8f7808b3ee13c3bb38d45564e369cbe15fc6d312f0cd7a0" "3c83b3676d796422704082049fc38b6966bcad960f896669dfc21a7a37a748fa" "e56f1b1c1daec5dbddc50abd00fcd00f6ce4079f4a7f66052cf16d96412a09a9" "b71d5d49d0b9611c0afce5c6237aacab4f1775b74e513d8ba36ab67dfab35e5a" "628278136f88aa1a151bb2d6c8a86bf2b7631fbea5f0f76cba2a0079cd910f7d" "1b8d67b43ff1723960eb5e0cba512a2c7a2ad544ddb2533a90101fd1852b426e" "bb08c73af94ee74453c90422485b29e5643b73b05e8de029a6909af6a3fb3f58" "fc5fcb6f1f1c1bc01305694c59a1a861b008c534cae8d0e48e4d5e81ad718bc6" "9dae95cdbed1505d45322ef8b5aa90ccb6cb59e0ff26fef0b8f411dfc416c552" "1e7e097ec8cb1f8c3a912d7e1e0331caeed49fef6cff220be63bd2a6ba4cc365" "756597b162f1be60a12dbd52bab71d40d6a2845a3e3c2584c6573ee9c332a66e" "cdc7555f0b34ed32eb510be295b6b967526dd8060e5d04ff0dce719af789f8e5" "6a37be365d1d95fad2f4d185e51928c789ef7a4ccf17e7ca13ad63a8bf5b922f" default)))
 '(paradox-github-token t))

  ;; Package manager and sources, using Cask
;;  (when (memq window-system '(mac ns))
;;    (let ((default-directory "/usr/local/share/emacs/site-lisp/"))
;;      (normal-top-level-add-subdirs-to-load-path))
;;    (require 'cask "cask.el"))
;;  (when (memq window-system '(w32))
;;    (require 'cask "~/.cask/cask.el"))
;;  (cask-initialize)
;;  (require 'pallet)
;;  (pallet-mode t)

(when (memq window-system '(w32))
  (defvar dropbox "c:/Users/John/Desktop/Dropbox/"))

(when (memq window-system '(mac ns))
  (defvar dropbox "/Users/john/Desktop/Dropbox/"))

(when (memq window-system '(x))
  (defvar dropbox "/home/john/Dropbox/"))

;; initial size
(setq default-frame-alist '((width . 100)
                            (height . 50)))

;; no system bell or toolbar, scrollbar, delete goes to trash
(setq visible-bell 1)
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(setq delete-by-moving-to-trash 1)
;; possible display speed up (less responsive typing possible)
(setq redisplay-dont-pause 1)
;; garbage collection every 20MB instead of default 0.76 (from flx)
(setq gc-cons-threshold 20000000)
;; no goddamn tabs
(setq-default indent-tabs-mode nil)

;; Windows key bindings
(when (memq window-system '(w32))
  (setq w32-pass-lwindow-to-system nil)
  (setq w32-lwindow-modifier 'super))

;; all prompts use only y or n
(fset 'yes-or-no-p 'y-or-n-p)

;; overwrite selections
(delete-selection-mode 1)

;; treat the end of sentence as punctuation plus one space (not two)
(setq sentence-end-double-space nil)

;; always blink that cursor (easier to find and I like it)
(setq blink-cursor-blinks 0)

;; proper encoding for ansi-term (mainly for powerline-shell characters)
(defadvice ansi-term (after advise-ansi-term-coding-system)
    (set-buffer-process-coding-system 'utf-8-unix 'utf-8-unix))
(ad-activate 'ansi-term)

(add-hook 'text-mode-hook 'turn-on-visual-line-mode)

;  (setq visual-line-fringe-indicators '(left-curly-arrow right-curly-arrow))

(defun push-mark-no-activate ()
  "Pushes `point' to `mark-ring' and does not activate the region
Equivalent to \\[set-mark-command] when \\[transient-mark-mode] is disabled"
  (interactive)
  (push-mark (point) t nil)
  (message "Pushed mark to ring"))
(global-set-key (kbd "C-`") 'push-mark-no-activate)
(defun jump-to-mark ()
  "Jumps to the local mark, respecting the `mark-ring' order.
This is the same as using \\[set-mark-command] with the prefix argument."
  (interactive)
  (set-mark-command 1))
(global-set-key (kbd "M-`") 'jump-to-mark)
(defun exchange-point-and-mark-no-activate ()
  "Identical to \\[exchange-point-and-mark] but will not activate the region."
  (interactive)
  (exchange-point-and-mark)
  (deactivate-mark nil))
(define-key global-map [remap exchange-point-and-mark] 'exchange-point-and-mark-no-activate)

(defun smarter-move-beginning-of-line (arg)
  "Move point back to indentation of beginning of line.

Move point to the first non-whitespace character on this line.
If point is already there, move to the beginning of the line.
Effectively toggle between the first non-whitespace character and
the beginning of the line.

If ARG is not nil or 1, move forward ARG - 1 lines first.  If
point reaches the beginning or end of the buffer, stop there."
  (interactive "^p")
  (setq arg (or arg 1))

  ;; Move lines first
  (when (/= arg 1)
    (let ((line-move-visual nil))
      (forward-line (1- arg))))

  (let ((orig-point (point)))
    (back-to-indentation)
    (when (= orig-point (point))
      (move-beginning-of-line 1))))

;; remap C-a to `smarter-move-beginning-of-line'
(global-set-key [remap move-beginning-of-line]
                'smarter-move-beginning-of-line)

(use-package goto-chg
  :bind (("C-c b ," . goto-last-change)
         ("C-c b ." . goto-last-change-reverse)))

;; When popping the mark, continue popping until the cursor
;; actually moves
(defadvice pop-to-mark-command (around ensure-new-position activate)
  (let ((p (point)))
    (dotimes (i 10)
      (when (= p (point)) ad-do-it))))

;; Allow pressing C-u C-SPC C-SPC etc. instead
(setq set-mark-command-repeat-pop t)

(when (memq window-system '(w32))
  (defun smooth-scroll (increment)
    (scroll-up increment) (sit-for 0.05)
    (scroll-up increment) (sit-for 0.02)
    (scroll-up increment) (sit-for 0.02)
    (scroll-up increment) (sit-for 0.05)
    (scroll-up increment) (sit-for 0.06)
    (scroll-up increment))

  (global-set-key [(wheel-down)] '(lambda () (interactive) (smooth-scroll 1)))
  (global-set-key [(wheel-up)] '(lambda () (interactive) (smooth-scroll -1))))

(when (memq window-system '(x))
  (defun smooth-scroll (increment)
    (scroll-up increment) (sit-for 0.04)
    (scroll-up increment) (sit-for 0.01)
    (scroll-up increment) (sit-for 0.01)
    (scroll-up increment) (sit-for 0.04)
    (scroll-up increment) (sit-for 0.05)
    (scroll-up increment))

  (setq redisplay-dont-pause t
        scroll-margin 1
        scroll-step 1
        scroll-conservatively 10000
        scroll-preserve-screen-position 1)

  (global-set-key [(mouse-5)] '(lambda () (interactive) (smooth-scroll 1)))
  (global-set-key [(mouse-4)] '(lambda () (interactive) (smooth-scroll -1))))

(use-package server
  :config
  (unless (server-running-p)
  (server-start)))

(use-package paradox)

(use-package exec-path-from-shell
  :config
  (exec-path-from-shell-initialize))

;; temporarily revert to older emacs colorspace for powerline fix
;; and solarized (although can probably use new solarized-broken-srgb instead)
;;(setq ns-use-srgb-colorspace nil)
;;(load-theme 'leuven)
;;(load-theme 'zenburn)
;(load-theme 'sanityinc-tomorrow-eighties 1)

(use-package color-theme-solarized
  :defer t
  :config
  ;; for light version (default is dark)
  (setq frame-background-mode 'light))

(use-package molokai-theme
  :defer t
  :config
  (setq frame-background-mode 'dark))

(use-package monokai-theme
  :defer t
  :config
  (setq frame-background-mode 'dark))

(use-package spacemacs-theme
  :defer t
  :config
  (setq frame-background-mode 'light))

(setq frame-background-mode 'light)
(load-theme 'spacemacs-light t)

(defadvice load-theme 
  (before theme-dont-propagate activate)
  (mapc #'disable-theme custom-enabled-themes)
  (when (package-installed-p 'powerline)
    (powerline-reset)))

(defun toggle-day-night-theme ()
  "Switch between two (day/night) themes."
  (interactive)
  (if (eq frame-background-mode 'light)
      (progn (setq frame-background-mode 'dark)
             (load-theme 'spacemacs-dark t))
      (progn (setq frame-background-mode 'light)
             (load-theme 'spacemacs-light t)))
  ;; reload highlight-sexp-mode to update highlight color
  ;; but seems to leave some parts highlighted incorrectly
  (if (bound-and-true-p highlight-sexp-mode)
      (progn (highlight-sexp-mode)
             (highlight-sexp-mode))))

(when (memq window-system '(mac ns))
  (set-face-attribute 'default nil :family "Input Mono Narrow" :height 120)
  ; extra unicode characters via:
  ; https://github.com/joodie/emacs-literal-config/blob/master/emacs.org
  ; http://endlessparentheses.com/manually-choose-a-fallback-font-for-unicode.html
  (set-fontset-font "fontset-default" nil (font-spec :name "Symbola")))

(when (memq window-system '(w32))
  (set-face-attribute 'default nil :font "InputMono" :height 85)
  (when (functionp 'set-fontset-font)
    (set-fontset-font "fontset-default"
                   'unicode
                   (font-spec :family "DejaVu Sans Mono"
                              :width 'normal
                              ;; :size 12.2
                              :height 85
                              :weight 'normal))))

(when (memq window-system '(x))
  (set-face-attribute 'default nil :family "M+ 1m" :weight 'normal :height 110)
  (set-fontset-font "fontset-default" nil (font-spec :name "Symbola")))

;; powerline modeline
;; (display problem with terminal emacs?)
;(require 'powerline)
;(powerline-default-theme)

;; smart-mode-line
;(sml/setup)
;(sml/apply-theme 'powerline)
;; shorten directories/modes
;(setq sml/shorten-directory t)
;(setq sml/shorten-modes t)
;(setq sml/name-width 40)
;(setq sml/mode-width 'full)
;; directory abbreviations
;(add-to-list 'sml/replacer-regexp-list '("^~/Dropbox/" ":DB:") t)
;(add-to-list 'sml/replacer-regexp-list '("^~/codemonkey/" ":CM:") t)

;; powerline modeline, also required for spaceline
(use-package powerline
  :ensure t)

(use-package spaceline-config
  :ensure spaceline
  :config
  (spaceline-spacemacs-theme)
  (setq powerline-default-separator 'wave))

(use-package spaceline-all-the-icons 
  :after spaceline
  :config (spaceline-all-the-icons-theme)
  (spaceline-all-the-icons--setup-package-updates)
  (spaceline-all-the-icons--setup-paradox)
  (spaceline-all-the-icons--setup-neotree))

;; IDO mode
(use-package ido
  :config
  (ido-mode 1)
  (setq ido-enable-flex-matching 1)
  (setq ido-use-filename-at-point 'guess)
  ;; show recent files in buffer list
  (setq ido-use-virtual-buffers 1)
  (setq ido-everywhere 1)
  (defadvice ido-find-file (after find-file-sudo activate)
  "Find file as root if necessary."
  (unless (and buffer-file-name
               (file-writable-p buffer-file-name))
    (find-alternate-file (concat "/sudo:root@localhost:" buffer-file-name)))))
;; Use ido everywhere
(use-package ido-completing-read+
  :ensure t
  :config
  (ido-ubiquitous-mode 1))

;; flx-ido (better matching)
(use-package flx-ido
  :ensure t
  :config
  (flx-ido-mode 1)
  ;; disable ido faces to see flx highlights.
  (setq ido-use-faces nil))

;; vertical ido list
(use-package ido-vertical-mode
  :ensure t
  :config
  (ido-vertical-mode 1)
  ;; allow arrow keys also
  (setq ido-vertical-define-keys 'C-n-C-p-up-down-left-right)
  (setq ido-use-faces 1))

;; smex (ido-like for commands)
(use-package smex
  :ensure t
  :init
  (smex-initialize) ; Can be omitted. This might cause a (minimal) delay
                    ; when Smex is auto-initialized on its first run.
  :bind (("M-x" . smex)
         ("M-X" . smex-major-mode-commands)
         ;; The old M-x
         ("C-c C-c M-x" . execute-extended-command)))

;; discover
(use-package discover
  :ensure nil
  :config
  (global-discover-mode 1))

;; expand region intelligently
(global-set-key (kbd "C-=") 'er/expand-region)

;; multiple cursors
(use-package multiple-cursors
  :bind (("C-S-c C-S-c" . mc/edit-lines)
         ("C->"         . mc/mark-next-like-this)
         ("C-<"         . mc/mark-previous-like-this)
         ("C-c C-<"     . mc/mark-all-like-this)))

(use-package which-key
  :config
  (setq which-key-idle-delay 0.5)
  (which-key-mode))

;; Show line-number and column-number in the mode line
(line-number-mode 1)
(column-number-mode 1)

;; 
;; Line number in left margin using linum
;;

(global-linum-mode 1)
;; (set-face-attribute 'linum nil :height 100)

;; Fix from EmacsWiki to have space before the line contents with right-
;; aligned numbers padded only to the max number of digits in the buffer
(unless window-system
  (add-hook 'linum-before-numbering-hook
                (lambda ()
                        (setq-local linum-format-fmt
                                      (let ((w (length (number-to-string
                                                            (count-lines (point-min) (point-max))))))
                                            (concat "%" (number-to-string w) "d"))))))

(defun linum-format-func (line)
  (concat
   (propertize (format linum-format-fmt line) 'face 'linum)
   (propertize " " 'face 'mode-line)))

(unless window-system
  (setq linum-format 'linum-format-func))

;; Select lines by click-dragging on the margin (where the line numbers are)
;; from EmacsWiki
;; DOESN'T WORK, but at least clicking on a number goes to that line
;; (e.g. can select by clicking a second time while pressing shift)
;; ACTUALLY: works in windowed mode it seems, but not so in terminal
(defvar *linum-mdown-line* nil)

(defun line-at-click ()
  (save-excursion
    (let ((click-y (cdr (cdr (mouse-position))))
          (line-move-visual-store line-move-visual))
      (setq line-move-visual t)
      (goto-char (window-start))
      (next-line (1- click-y))
      (setq line-move-visual line-move-visual-store)
      ;; If you are not using tabbar substitute the next line with
      ;; (1+ (line-number-at-pos)))))
      (line-number-at-pos))))

(defun md-select-linum ()
  (interactive)
  (goto-line (line-at-click))
  (set-mark (point))
  (setq *linum-mdown-line* (line-number-at-pos)))

(defun mu-select-linum ()
  (interactive)
  (when *linum-mdown-line*
    (let (mu-line)
      (setq mu-line (line-at-click))
      (if (> mu-line *linum-mdown-line*)
          (progn
            (goto-line *linum-mdown-line*)
            (set-mark (point))
            (goto-line mu-line)
            (end-of-line))
          (progn
            (goto-line *linum-mdown-line*)
            (set-mark (line-end-position))
            (goto-line mu-line)
            (beginning-of-line)))
      (setq *linum-mdown* nil))))

(global-set-key (kbd "<left-margin> <down-mouse-1>") 'md-select-linum)
(global-set-key (kbd "<left-margin> <mouse-1>") 'mu-select-linum)
(global-set-key (kbd "<left-margin> <drag-mouse-1>") 'mu-select-linum)

;; highlight current line
(global-hl-line-mode 1)

;; color-identifiers-mode
(use-package color-identifiers-mode
  :init
  (add-hook 'after-init-hook 'global-color-identifiers-mode))

;; highlight symbols in buffer
(use-package highlight-symbol
  :bind (("C-<F3>" . highlight-symbol-at-point)
         ("<F3>"   . highlight-symbol-next)
         ("S-<F3>" . highlight-symbol-prev)
         ("M-<F3>" . highlight-symbol-query-replace))
  :config
  (setq highlight-symbol-idle-delay 0)
  (add-hook 'prog-mode-hook 'highlight-symbol-mode))

;; Enable mouse support in terminal
(unless window-system
  (require 'mouse)
  (xterm-mouse-mode t)
  (global-set-key [mouse-4] '(lambda ()
                              (interactive)
                              (scroll-down 1)))
  (global-set-key [mouse-5] '(lambda ()
                              (interactive)
                              (scroll-up 1)))
  (defun track-mouse (e))
  (setq mouse-sel-mode t)
)
(setq mac-emulate-three-button-mouse 1)

;;
;; Mac copy/cut command (iterm2 set to send command-c/x to ESC-p/])
;; probably only needed when in terminal?
;;
(defvar osx-pbpaste-cmd "/usr/bin/pbpaste"
  "*command-line paste program")

(defvar osx-pbcopy-cmd "/usr/bin/pbcopy"
  "*command-line copy program")

(defun osx-pbpaste ()
  "paste the contents of the os x clipboard into the buffer at point."
  (interactive)
  (call-process osx-pbpaste-cmd nil t t))

(defun osx-pbcopy ()
  "copy the contents of the region into the os x clipboard."
  (interactive)
  (if (use-region-p)
    (call-process-region 
     (region-beginning) (region-end) osx-pbcopy-cmd nil t t)
    (error "region not selected")))

(defun osx-pbcut ()
  "cut the contents of the region; put in os x clipboard."
  (interactive)
  (if (use-region-p)
    (call-process-region 
     (region-beginning) (region-end) osx-pbcopy-cmd t t t)
    (error "region not selected")))

;; Paste already works fine
;;(define-key global-map "\C-c\M-v" 'osx-pbpaste)
(define-key global-map "\M-p" 'osx-pbcopy)
(define-key global-map "\M-]" 'osx-pbcut)

;; flyspell
;; checks all buffers on opening, too slow
;;(add-hook 'flyspell-mode-hook 'flyspell-buffer)
(add-hook 'text-mode-hook 'flyspell-mode)
(add-hook 'prog-mode-hook 'flyspell-prog-mode)
(eval-after-load "flyspell"
    '(progn
       (define-key flyspell-mouse-map [down-mouse-3] #'flyspell-correct-word)
       (define-key flyspell-mouse-map [mouse-3] #'undefined)))

;; dictionary look up
(use-package define-word
  :bind (("C-c d" . define-word-at-point)
         ("C-c D" . define-word)))

;; languagetool grammar checker
(use-package langtool
  :config
  (when (memq window-system '(mac ns))
    (setq langtool-language-tool-jar
      "/usr/local/Cellar/languagetool/2.7/libexec/languagetool-commandline.jar"))
  (when (memq window-system '(w32))
    (setq langtool-language-tool-jar
      "~/LanguageTool-3.1/languagetool-commandline.jar"))
  (setq langtool-default-language "en-US"
    langtool-mother-tongue "en")
  (defun langtool-autoshow-detail-popup (overlays)
    (when (require 'popup nil t)
      ;; Do not interrupt current popup
      (unless (or popup-instances
                  ;; suppress popup after type `C-g` .
                  (memq last-command '(keyboard-quit)))
        (let ((msg (langtool-details-error-message overlays)))
          (popup-tip msg)))))
  (setq langtool-autoshow-message-function
    'langtool-autoshow-detail-popup))

;; writegood mode
(global-set-key "\C-cg" 'writegood-mode)
(global-set-key "\C-c\C-gg" 'writegood-grade-level)
(global-set-key "\C-c\C-ge" 'writegood-reading-ease)

(use-package neotree
  :bind ("<f8>" . neotree-toggle)
  :config
  (setq neo-theme (if window-system 'icons 'arrow))
  (setq neo-smart-open t))

;; show path info for buffers with same name
(require 'uniquify)

;; save position on buffer kill
(require 'saveplace)
(setq-default save-place 1)
(setq save-place-file "~/.emacs.d/saved-places")

;; use ibuffer (like dired) for buffer list
(global-set-key (kbd "C-x C-b") 'ibuffer)

;;
;; recent files list with ido completion (via masteringemacs)
;;
(require 'recentf)

;; get rid of `find-file-read-only' and replace it with something
;; more useful.
(global-set-key (kbd "C-x C-r") 'ido-recentf-open)

;; enable recent files mode.
(recentf-mode 1)

; 50 files ought to be enough.
(setq recentf-max-saved-items 50)

(defun ido-recentf-open ()
  "Use `ido-completing-read' to \\[find-file] a recent file"
  (interactive)
  (if (find-file (ido-completing-read "Find recent file: " recentf-list))
      (message "Opening file...")
    (message "Aborting")))

(use-package org
  :ensure org-plus-contrib
  :pin org
  :defer t
  :config
  (setq org-directory (concat dropbox "org"))
  (add-hook 'org-mode-hook 'visual-line-mode)
  ;; use indented view by default
  (setq org-startup-indented t)
  ;; syntax highlight code blocks
  (setq org-src-fontify-natively t)
  ;; use UTF-8 characters for e.g. \alpha and subscripts
  (setq org-pretty-entities t)
  ;; replace the folded section "..."s
  (setq org-ellipsis "…")
  ;; export backends
  (setq org-export-backends (append org-export-backends '(md)))
  ;; org-babel languages
  (org-babel-do-load-languages
    'org-babel-load-languages
    '((sh . t)
      (python . t)
      (gnuplot . t)
      (lisp . t)
      (latex . t)
      (maxima . t)))
  ;; To partially italic/bold/underline/strikethrough
  ;; from http://stackoverflow.com/a/24540651
  (setcar org-emphasis-regexp-components " \t('\"{[:alpha:]")
  (setcar (nthcdr 1 org-emphasis-regexp-components) "[:alpha:]- \t.,:!?;'\")}\\")
  (org-set-emph-re 'org-emphasis-regexp-components org-emphasis-regexp-components)
  ;; LaTeX customization
  (require 'ox-latex)
  (setq org-latex-pdf-process (list "latexmk -f -lualatex -pdf %f"))
  (add-to-list 'org-latex-classes
               '("latex-general"
                 "\\documentclass[11pt, letterpaper]{article}
                  \\usepackage[hmargin = 1in, vmargin = 1in]{geometry}
                  \\usepackage{fontspec}
                  \\usepackage{unicode-math}
                  \\setmainfont{TeX Gyre Pagella}
                  \\setmathfont{TeX Gyre Pagella Math}
                  \\usepackage[pdftex, colorlinks=true, plainpages=false, pdfpagelabels]{hyperref}
                  \\title{}
                  [NO-DEFAULT-PACKAGES]
                  [PACKAGES]"
                 ("\\section{%s}"       . "\\section*{%s}")
                 ("\\subsection{%s}"    . "\\subsection*{%s}")
                 ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
                 ("\\paragraph{%s}"     . "\\paragraph*{%s}")
                 ("\\subparagraph{%s}"  . "\\subparagraph*{%s}")))
  ;; todo and agenda customization
  ;; warn of upcoming deadlines in next week
  (setq org-deadline-warning-days 7)
  ;; show tasks for next fornight
  (setq org-agenda-span 'fortnight)
  ;;don't show tasks as scheduled if they are already shown as a deadline
  (setq org-agenda-skip-scheduled-if-deadline-is-shown t)
  ;;don't give awarning colour to tasks with impending deadlines
  ;;if they are scheduled to be done
  (setq org-agenda-skip-deadline-prewarning-if-scheduled (quote pre-scheduled))
  ;;don't show tasks that are scheduled or have deadlines in the
  ;;normal todo list
  (setq org-agenda-todo-ignore-deadlines (quote all))
  (setq org-agenda-todo-ignore-scheduled (quote all))
  ;; sort tasks in order of when they are due and then by priority
  (setq org-agenda-sorting-strategy
    (quote
     ((agenda deadline-up priority-down)
      (todo priority-down category-keep)
      (tags priority-down category-keep)
      (search category-keep))))
  ;; set priority range from (default) A to C
  (setq org-highest-priority ?A)
  (setq org-lowest-priority ?C)
  (setq org-default-priority ?A)
  ;; todo file(s)
  (setq org-agenda-files (list (concat org-directory "/todoes.org")))
  ;; todo capture template with default priority and scheduled for today
  (setq org-capture-templates
    '(("t" "todo" entry (file+headline (concat org-directory "/todoes.org") "Tasks")
       "* TODO [#A] %?\nSCHEDULED: %(org-insert-time-stamp
                                     (org-read-date nil t \"+0d\"))\n")))
  :bind (("C-c a" . org-agenda))
  :bind  (:map global-map
        ("C-c c" . org-capture)))

;; fancy utf-8 bullets
(use-package org-bullets
  :ensure nil ; included in org-plus-contrib
  :config
  (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1))))

;; htmlize for nicer html output
(use-package htmlize)

(use-package ox-reveal
  :config
  ;; use CDN copy by default
  (setq org-reveal-root "http://cdn.jsdelivr.net/reveal.js/3.0.0/"))

(use-package org2blog-autoloads
  :ensure org2blog
  :defer t
  :config
  (require 'auth-source)
  (setq org2blog/wp-blog-alist
        `(("stuff-blog"
           :url "http://stuff.9bladed.com/xmlrpc.php"
           :username ,(getf (car (auth-source-search :host "stuff-blog"))
                            :user)))))

(use-package magit
  :pin melpa-stable
  :config
  (setq magit-last-seen-setup-instructions "1.4.0")
  :bind (("\C-xg" . magit-status)))

;; for windows paths in msys2 with default install directory
;; modified from solutions in https://github.com/magit/magit/issues/1318
;; Doesn't seem to be needed anymore, not sure since when (on magit 2.3.1)
;; (defun magit-expand-git-file-name--msys2 (args)
;;   "Handle msys2 directory names starting with /home by prefixing with c:/msys2"
;;   (let ((filename (car args)))
;;         (when (string-match "^\\(/home\\)\\(.*\\)" filename)
;;           (setq filename (concat  "c:/msys64/home" (match-string 2 filename))))
;;         (list filename)))
;; (when (memq window-system '(w32))
;;   (advice-add 'magit-expand-git-file-name :filter-args
;;               #'magit-expand-git-file-name--msys2))

;; work around for https git on windows
;; https://github.com/magit/magit/wiki/FAQ#windows-cannot-push-via-https
(when (memq window-system '(w32))
  (setenv "GIT_ASKPASS" "git-gui--askpass"))

;; auto-complete
;; (require 'auto-complete-config)
;; (global-auto-complete-mode 1)
;; (ac-config-default)
;; (add-to-list 'ac-dictionary-directories "~/.emacs.d/dict")
;; (eval-after-load 'auto-complete
;;   '(ac-flyspell-workaround))

(use-package company
  :init
  (add-hook 'after-init-hook 'global-company-mode))

(use-package company-quickhelp
  :config
  (company-quickhelp-mode 1))

(use-package company
  :bind (:map company-active-map
        ("TAB"       . company-complete-common-or-cycle)
        ("<tab>"     . company-complete-common-or-cycle)
        ("S-TAB"     . company-select-previous)
        ("<backtab>" . company-select-previous)))

;; flycheck
(use-package flycheck
  :init
  (add-hook 'after-init-hook #'global-flycheck-mode))
;; color the modeline by flycheck status
;; (compatibility issue with previous color theme/powerline :()
;; seems okay now with smart-mode-line
(use-package flycheck-color-mode-line
  :config
  (eval-after-load "flycheck"
    '(add-hook 'flycheck-mode-hook 'flycheck-color-mode-line-mode)))

;; Rainbow parens
(use-package rainbow-delimiters
  :config
  (add-hook 'prog-mode-hook 'rainbow-delimiters-mode)
  (add-hook 'LaTeX-mode-hook 'rainbow-delimiters-mode))

;; Smartparens
(use-package smartparens-config
  :ensure smartparens
  :config
  (smartparens-global-mode 1)
  (show-smartparens-global-mode 1)
  ;; for some (e.g. molokai) themes this is the wrong color
  ;(setq sp-highlight-pair-overlay nil)
  ;; paredit-like setup for lisp
  (add-hook 'lisp-mode-hook 'turn-on-smartparens-strict-mode)
  (add-hook 'emacs-lisp-mode-hook 'turn-on-smartparens-strict-mode)
  (setq sp-base-key-bindings 'paredit)
  (sp-use-paredit-bindings)
  (define-key sp-keymap (kbd "M-J") 'sp-join-sexp)
  (sp-local-pair 'lisp-mode "(" ")" :wrap "M-(")
  (sp-local-pair 'lisp-mode "\"" "\"" :wrap "M-\""))

;;; From quicklisp, but prefer current slime in melpa
;; (load (expand-file-name "~/quicklisp/slime-helper.el"))
(use-package slime
  :init
  (setq inferior-lisp-program "sbcl")
  (setq slime-contribs '(slime-fancy slime-indentation slime-banner))
  ;; Use Common Lisp indenting
  (setq lisp-indent-function 'common-lisp-indent-function)
  (add-hook 'lisp-mode-hook (lambda () (slime-mode t)))
  (add-hook 'inferior-lisp-mode-hook (lambda () (inferior-slime-mode t))))

;; ac-slime
;; now using company-mode instead
;; (add-hook 'slime-mode-hook 'set-up-slime-ac)
;; (add-hook 'slime-repl-mode-hook 'set-up-slime-ac)
;; (eval-after-load "auto-complete"
;;   '(add-to-list 'ac-modes 'slime-repl-mode))

(use-package slime-company
  :config
  (add-to-list 'slime-contribs 'slime-company))

;; highlight-sexp
(use-package highlight-sexp
  :config
  ;; turn off hl-line-mode locally
  ;; (add-hook 'lisp-mode-hook (lambda ()
  ;;                             (setq-local global-hl-line-mode nil)))
  ;; (add-hook 'emacs-lisp-mode-hook (lambda ()
  ;;                                   (setq-local global-hl-line-mode nil)))

  ;; for light themes, set to be just darker than background
  ;; (otherwise (re)set to default purple)
  (add-hook 'highlight-sexp-mode-hook (lambda ()
                                        (if (equal frame-background-mode 'light)
                                            (setq hl-sexp-background-color
                                                  (color-darken-name
                                                   (face-background 'default) 10))
                                            (setq hl-sexp-background-color "#4b3b4b"))))
  (add-hook 'lisp-mode-hook 'highlight-sexp-mode)
  (add-hook 'emacs-lisp-mode-hook 'highlight-sexp-mode))
;; for leuven theme, default purple is unreadable
;;(setq hl-sexp-background-color "#EAF2F5")

(use-package info-look
  :config
  (info-lookup-add-help
    :mode 'lisp-mode
    :regexp "[^][()'\" \t\n]+"
    :ignore-case t
    :doc-spec '(("(ansicl)Symbol Index" nil nil nil))))

(use-package company-jedi
  :config
  (add-hook 'python-mode-hook 'jedi:setup)
  (setq jedi:complete-on-dot t)
  (add-hook 'python-mode-hook
            (lambda () (add-to-list 'company-backends 'company-jedi))))

(use-package ein
  :config
  (require 'ein-dev)
  (add-hook 'ein:connect-mode-hook 'ein:jedi-setup)
  ;; Doesn't seem like jedi is loaded without running jedi:setup,
  ;; so as a hack add it to notebook-mode, but only after the list is opened
  ;; or else there is an error.
  ;; See issue #204 in emacs-ipython-notebook
  (add-hook 'ein:notebooklist-first-open-hook
            (lambda () (add-hook 'ein:notebook-mode-hook 'jedi:setup)))
  (setq ein:jupyter-default-server-command "/usr/bin/jupyter"
        ein:jupyter-default-notebook-directory "~/")
  (add-to-list 'company-backends 'ein:company-backend))

;; use python-mode.el
;; err...doesn't seem to work, loads python.el (Python vs py mode), fix later
;; (setq py-install-directory "~/.emacs.d/.cask/24.5.1/elpa/python-mode-20150512.353/")
;; (add-to-list 'load-path py-install-directory)
;; (require 'python-mode)
;; (when (featurep 'python) (unload-feature 'python t))
;; (add-hook 'python-mode-hook 'flyspell-prog-mode) ; spell check comments
;; use ipython interpreter
;; (setq-default py-shell-name "ipython")
;; (setq py-force-py-shell-name-p 1) ; overrides shebang setting

;; jedi
;; (add-hook 'python-mode-hook 'jedi:setup)
;; (setq jedi:complete-on-dot 1)

;; cython
;; (require 'cython-mode)
;; (add-to-list 'auto-mode-alist '("\\.pyx\\'" . cython-mode))
;; (add-to-list 'auto-mode-alist '("\\.pxd\\'" . cython-mode))
;; (add-to-list 'auto-mode-alist '("\\.pxi\\'" . cython-mode))

(use-package fountain-mode
  :mode "\\.fountain\\'")

(use-package markdown-mode
  :demand markdown-edit-indirect
  :commands (markdown-mode gfm-mode)
  :mode (("README\\.md\\'" . gfm-mode)
         ("\\.md\\'"       . markdown-mode)
         ("\\.markdown\\'" . markdown-mode))
  :init (setq markdown-command "multimarkdown")
  :bind (:markdown-mode-map
         ("C-c '" . markdown-edit-indirect)))

(use-package olivetti)

(use-package imaxima
  :if (memq window-system '(mac ns))
  :load-path "/usr/local/Cellar/maxima/5.37.2/share/maxima/5.37.2/emacs/"
  :ensure nil
  :config
  (setq imaxima-use-maxima-mode-flag t))
(use-package imath
  :if (memq window-system '(mac ns))
  :load-path "/usr/local/Cellar/maxima/5.37.2/share/maxima/5.37.2/emacs/"
  :ensure nil)

(when (memq window-system '(w32))
  (load-file "~/codemonkey/setup-imaxima-imath.el")
  (setq imaxima-use-maxima-mode-flag t))

; Enable AucTeX
(use-package tex
  :ensure auctex
  :config
  (setq TeX-auto-save 1)
  (setq TeX-parse-self 1)
  (setq-default TeX-master -1)
  (add-hook 'LaTeX-mode-hook 'visual-line-mode)
  (add-hook 'LaTeX-mode-hook 'flyspell-mode)
  (add-hook 'LaTeX-mode-hook 'LaTeX-math-mode)
  (add-hook 'LaTeX-mode-hook 'turn-on-reftex)
  (add-hook 'LaTeX-mode-hook 'turn-on-cdlatex)
  (setq reftex-plug-into-AUCTeX 1)

  ;; some reftex options esp. for big files
  (setq reftex-enable-partial-scans 1)
  (setq reftex-save-parse-info 1)
  (setq reftex-use-multiple-selection-buffers 1)

  ;; spellcheck in LaTex mode
  (add-hook `latex-mode-hook `flyspell-mode)
  (add-hook `tex-mode-hook `flyspell-mode)
  (add-hook `bibtex-mode-hook `flyspell-mode)

  ;; use latexmk for compiling, ~/. latexmkrc has options set
  (add-hook 'LaTeX-mode-hook (lambda ()
    (push
      '("Latexmk" "latexmk -pdf %s" TeX-run-TeX nil t
        :help "Run Latexmk on file")
      TeX-command-list)
  (setq TeX-command-default "Latexmk")))

  ;; force load on file open (still need to edit
  ;; something in math mode for it to kick in though)
  (add-hook 'find-file-hook
            (lambda () (when (eq major-mode 'latex-mode)
                             (latex-unicode-simplified))))


  ;; Automatically activate TeX-fold-mode and fold after opening
  (add-hook 'find-file-hook
            (lambda () (when (eq major-mode 'latex-mode)
                             (TeX-fold-mode 1)
                             (TeX-fold-buffer))))

  ;; Automatically fold new input, run after $ or }
  (add-hook 'LaTeX-mode-hook 
        (lambda () 
          (TeX-fold-mode 1)
          (add-hook 'find-file-hook 'TeX-fold-buffer t t)
          (add-hook 'after-change-functions 
                (lambda (start end oldlen) 
                  (when (= (- end start) 1)
                    (let ((char-point 
                                   (buffer-substring-no-properties 
                                    start end)))
                     (when (or (string= char-point "}")
                           (string= char-point "$"))
                      (TeX-fold-paragraph)))))
                 t t)))
  ; Set pdf mode
  (setq TeX-PDF-mode 1)

  ;; use Skim as default pdf viewer on Mac
  ;; Skim's displayline is used for forward search (from .tex to .pdf)
  ;; option -b highlights the current line; option -g opens Skim in the background  
  (when (memq window-system '(mac ns))
    (setq TeX-view-program-selection '((output-pdf "PDF Viewer")))
    (setq TeX-view-program-list
          '(("PDF Viewer" "/Applications/Skim.app/Contents/SharedSupport/displayline -b -g %n %o %b"))))

  ;; use Sumatra as pdf viewer on Windows
  (when (memq window-system '(w32))
    (setq TeX-view-program-selection '((output-pdf "Sumatra PDF")))
    (setq TeX-view-program-list
          '(("Sumatra PDF" ("\"C:/Program Files (x86)/SumatraPDF/SumatraPDF.exe\" -reuse-instance" (mode-io-correlate " -forward-search %b %n") " %o")))))

  ; Enable synctex
  (setq TeX-source-correlate-mode 1)
  (setq TeX-source-correlate-method 'synctex))

;; latex symbols via unicode (suplement fold-mode)
(use-package latex-pretty-symbols)

;; auto-complete using company-mode auctex and math backends
(use-package company-auctex
  :config
  (company-auctex-init))
(use-package company-math
  :config
  (add-to-list 'company-backends 'company-math-symbols-unicode))

;;
;; auto-complete for latex
;;
;; switched to company-mode
;; (require 'ac-math)
;; (add-to-list 'ac-modes 'latex-mode)   ; make auto-complete aware of `latex-mode`
;; (defun ac-latex-mode-setup ()         ; add ac-sources to default ac-sources
;;   (setq ac-sources
;;      (append '(ac-source-math-unicode ac-source-math-latex ac-source-latex-commands)
;;                ac-sources)))
;; (add-hook 'latex-mode-hook 'ac-latex-mode-setup)
;; (defvar ac-source-math-latex-everywere
;; '((candidates . ac-math-symbols-latex)
;;   (prefix . "\\\\\\(.*\\)")
;;   (action . ac-math-action-latex)
;;   (symbol . "l")
;;  ))

(use-package emms-setup
  :ensure emms
  :config
  (emms-devel)
  (emms-default-players)
  ;; for Mac use built-in afplay
  (when (memq window-system '(mac ns))
        (define-emms-simple-player afplay '(file)
          (regexp-opt '(".mp3" ".m4a" ".aac"))
          "afplay")
        (setq emms-player-list `(,emms-player-afplay))
        (setq emms-source-file-default-directory
              "~/Music/iTunes/iTunes Media/Music/")))

(use-package all-the-icons)

(use-package all-the-icons-dired
 :config
 (add-hook 'dired-mode-hook 'all-the-icons-dired-mode))
