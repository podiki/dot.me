(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("3c83b3676d796422704082049fc38b6966bcad960f896669dfc21a7a37a748fa" "e56f1b1c1daec5dbddc50abd00fcd00f6ce4079f4a7f66052cf16d96412a09a9" "b71d5d49d0b9611c0afce5c6237aacab4f1775b74e513d8ba36ab67dfab35e5a" "628278136f88aa1a151bb2d6c8a86bf2b7631fbea5f0f76cba2a0079cd910f7d" "1b8d67b43ff1723960eb5e0cba512a2c7a2ad544ddb2533a90101fd1852b426e" "bb08c73af94ee74453c90422485b29e5643b73b05e8de029a6909af6a3fb3f58" "fc5fcb6f1f1c1bc01305694c59a1a861b008c534cae8d0e48e4d5e81ad718bc6" "9dae95cdbed1505d45322ef8b5aa90ccb6cb59e0ff26fef0b8f411dfc416c552" "1e7e097ec8cb1f8c3a912d7e1e0331caeed49fef6cff220be63bd2a6ba4cc365" "756597b162f1be60a12dbd52bab71d40d6a2845a3e3c2584c6573ee9c332a66e" "cdc7555f0b34ed32eb510be295b6b967526dd8060e5d04ff0dce719af789f8e5" "6a37be365d1d95fad2f4d185e51928c789ef7a4ccf17e7ca13ad63a8bf5b922f" default)))
 '(paradox-github-token t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )


;; Package manager and sources, using Cask
(require 'cask "/usr/local/Cellar/cask/0.7.2/cask.el")
(cask-initialize)
(require 'pallet)
(pallet-mode t)

;; When running emacs.app in Mac OS X, copy the path from terminal
;; (this avoids problems with finding aspell, latex, etc.)
(when (memq window-system '(mac ns))
  (exec-path-from-shell-initialize)
  (exec-path-from-shell-copy-env "JAVA_HOME"))

;; Themes
;; temporarily revert to older emacs colorspace for powerline fix
;; and solarized (although can probably use new solarized-broken-srgb instead)
(setq ns-use-srgb-colorspace nil)
(load-theme 'sanityinc-tomorrow-eighties 1)
;(load-theme 'solarized t)
;; Font
(when window-system
  (set-face-attribute 'default nil :font "Inconsolata" :height 130))

;; powerline modeline
;; (display problem with terminal emacs?)
;(require 'powerline)
;(powerline-default-theme)

;; smart-mode-line
(sml/setup)
(sml/apply-theme 'powerline)
;; shorten directories/modes
(setq sml/shorten-directory t)
(setq sml/shorten-modes t)
(setq sml/name-width 40)
(setq sml/mode-width 'full)
;; directory abbreviations
(add-to-list 'sml/replacer-regexp-list '("^~/Dropbox/" ":DB:") t)
(add-to-list 'sml/replacer-regexp-list '("^~/codemonkey/" ":CM:") t)

;; initial size
(setq default-frame-alist '((width . 90)
			    (height . 55)))

;; no system bell or toolbar, scrollbar, delete goes to trash
(setq visible-bell 1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(setq delete-by-moving-to-trash 1)
;; possible display speed up (less responsive typing possible)
(setq redisplay-dont-pause 1)
;; garbage collection every 20MB instead of default 0.76 (from flx)
(setq gc-cons-threshold 20000000)

;; overwrite selections
(delete-selection-mode 1)
;; transient-mark-mode related (commands from masterinemacs)
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

;; smarter move-to-beginning-of-line from emacsredux
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

;; IDO mode
(ido-mode 1)
(setq ido-enable-flex-matching 1)
(setq ido-use-filename-at-point 'guess)
;; show recent files in buffer list
(setq ido-use-virtual-buffers 1)
(setq ido-everywhere 1)
;; Use ido everywhere
(require 'ido-ubiquitous)
(ido-ubiquitous-mode 1)

;; flx-ido (better matching)
(require 'flx-ido)
(flx-ido-mode 1)
;; disable ido faces to see flx highlights.
(setq ido-use-faces nil)

;; vertical ido list
(require 'ido-vertical-mode)
(ido-vertical-mode 1)
;; allow arrow keys also
(setq ido-vertical-define-keys 'C-n-C-p-up-down-left-right)
(setq ido-use-faces 1)

;; smex (ido-like for commands)
(require 'smex)
(smex-initialize) ; Can be omitted. This might cause a (minimal) delay
                  ; when Smex is auto-initialized on its first run.
(global-set-key (kbd "M-x") 'smex)
(global-set-key (kbd "M-X") 'smex-major-mode-commands)
;; The old M-x
(global-set-key (kbd "C-c C-c M-x") 'execute-extended-command)

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


;; discover
(require 'discover)
(global-discover-mode 1)

;; Rainbow parens
(require 'rainbow-delimiters)
(add-hook 'prog-mode-hook 'rainbow-delimiters-mode)
(add-hook 'LaTeX-mode-hook 'rainbow-delimiters-mode)

;; Smartparens
(smartparens-global-mode 1)
(require 'smartparens-config)
(show-smartparens-global-mode 1)
;; paredit-like setup for lisp
(add-hook 'lisp-mode-hook 'turn-on-smartparens-strict-mode)
(setq sp-base-key-bindings 'paredit)
(sp-use-paredit-bindings)
(define-key sp-keymap (kbd "M-J") 'sp-join-sexp)
(sp-local-pair 'lisp-mode "(" ")" :wrap "M-(")
(sp-local-pair 'lisp-mode "\"" "\"" :wrap "M-\"")

;; multiple cursors
(global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)
(global-set-key (kbd "C->") 'mc/mark-next-like-this)
(global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this)

;; Show line-number and column-number in the mode line
(line-number-mode 1)
(column-number-mode 1)

;; 
;; Line number in left margin using linum
;;

;; Fix from EmacsWiki to have space before the line contents with right-
;; aligned numbers padded only to the max number of digits in the buffer
(global-linum-mode 1)
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
(add-hook 'after-init-hook 'global-color-identifiers-mode)

;; highlight symbols in buffer
(global-set-key [(control f3)] 'highlight-symbol-at-point)
(global-set-key [f3] 'highlight-symbol-next)
(global-set-key [(shift f3)] 'highlight-symbol-prev)
(global-set-key [(meta f3)] 'highlight-symbol-query-replace)
(setq highlight-symbol-idle-delay 0)
(add-hook 'prog-mode-hook 'highlight-symbol-mode)

;; auto-complete
(require 'auto-complete-config)
(global-auto-complete-mode 1)
(ac-config-default)
(add-to-list 'ac-dictionary-directories "~/.emacs.d/dict")
(eval-after-load 'auto-complete
  '(ac-flyspell-workaround))

;; flycheck
(require 'flycheck)
(add-hook 'after-init-hook #'global-flycheck-mode)
;; color the modeline by flycheck status
;; (compatibility issue with previous color theme/powerline :()
;; seems okay now with smart-mode-line
(require 'flycheck-color-mode-line)
(eval-after-load "flycheck"
  '(add-hook 'flycheck-mode-hook 'flycheck-color-mode-line-mode))

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

;; languagetool grammar checker
(require 'langtool)
(setq langtool-language-tool-jar
      "/usr/local/Cellar/languagetool/2.7/libexec/languagetool-commandline.jar"
      langtool-mother-tongue "en-US")

;; writegood mode
(global-set-key "\C-cg" 'writegood-mode)
(global-set-key "\C-c\C-gg" 'writegood-grade-level)
(global-set-key "\C-c\C-ge" 'writegood-reading-ease)

;; treat the end of sentence as punctuation plus one space (not two)
(setq sentence-end-double-space nil)

;; magit
(require 'magit)
(global-set-key "\C-xg" 'magit-status)

;; fountain-mode
(add-to-list 'auto-mode-alist '("\\.fountain\\'" . fountain-mode))

;;
;; org-mode
;;

(add-hook 'org-mode-hook 'visual-line-mode)
;; fancy utf-8 bullets
(add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))

;;
;; markdown
;;
(autoload 'markdown-mode "markdown-mode"
   "Major mode for editing Markdown files" 1)
(add-to-list 'auto-mode-alist '("\\.text\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.markdown\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("README\\.md\\'" . gfm-mode))

;; proper encoding for ansi-term (mainly for powerline-shell characters)
(defadvice ansi-term (after advise-ansi-term-coding-system)
    (set-buffer-process-coding-system 'utf-8-unix 'utf-8-unix))
(ad-activate 'ansi-term)

;;
;; lisp/slime
;;
(load (expand-file-name "~/quicklisp/slime-helper.el"))
(setq inferior-lisp-program "/usr/local/bin/sbcl")
(setq slime-contribs '(slime-fancy))
;; ac-slime
(add-hook 'slime-mode-hook 'set-up-slime-ac)
(add-hook 'slime-repl-mode-hook 'set-up-slime-ac)
(eval-after-load "auto-complete"
  '(add-to-list 'ac-modes 'slime-repl-mode))
;; highlight-sexp
(add-hook 'lisp-mode-hook 'highlight-sexp-mode)
(add-hook 'emacs-lisp-mode-hook 'highlight-sexp-mode)


;;
;; Python
;;

;; use python-mode.el
(setq py-install-directory "/Users/john/.emacs.d/.cask/24.4.1/elpa/python-mode-6.1.3/")
(add-to-list 'load-path py-install-directory)
(require 'python-mode)
(when (featurep 'python) (unload-feature 'python t))
(add-hook 'python-mode-hook 'flyspell-prog-mode) ; spell check comments
;; use ipython interpreter
(setq-default py-shell-name "ipython")
(setq py-force-py-shell-name-p 1) ; overrides shebang setting

;; jedi
(add-hook 'python-mode-hook 'jedi:setup)
(setq jedi:complete-on-dot 1)

;; cython
(require 'cython-mode)
(add-to-list 'auto-mode-alist '("\\.pyx\\'" . cython-mode))
(add-to-list 'auto-mode-alist '("\\.pxd\\'" . cython-mode))
(add-to-list 'auto-mode-alist '("\\.pxi\\'" . cython-mode))


;;
;; LaTeX stuff
;;

; Enable AucTeX
(require 'tex-site)
(setq TeX-auto-save 1)
(setq TeX-parse-self 1)
(setq-default TeX-master -1)
(add-hook 'LaTeX-mode-hook 'visual-line-mode)
(add-hook 'LaTeX-mode-hook 'flyspell-mode)
(add-hook 'LaTeX-mode-hook 'LaTeX-math-mode)
(add-hook 'LaTeX-mode-hook 'turn-on-reftex)
(setq reftex-plug-into-AUCTeX 1)

;; some reftex options esp. for big files
(setq reftex-enable-partial-scans 1)
(setq reftex-save-parse-info 1)
(setq reftex-use-multiple-selection-buffers 1)

;; spellcheck in LaTex mode
(add-hook `latex-mode-hook `flyspell-mode)
(add-hook `tex-mode-hook `flyspell-mode)
(add-hook `bibtex-mode-hook `flyspell-mode)

;; use latexmk for compiling, ~/.latexmkrc has options set
(add-hook 'LaTeX-mode-hook (lambda ()
  (push 
    '("Latexmk" "latexmk -pdf %s" TeX-run-TeX nil t
      :help "Run Latexmk on file")
    TeX-command-list)
  (setq TeX-command-default "Latexmk")))

;; latex symbols via unicode (suplement fold-mode)
(require 'latex-pretty-symbols)
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

;;
;; auto-complete for latex
;;
(require 'ac-math)

(add-to-list 'ac-modes 'latex-mode)   ; make auto-complete aware of `latex-mode`

(defun ac-latex-mode-setup ()         ; add ac-sources to default ac-sources
  (setq ac-sources
     (append '(ac-source-math-unicode ac-source-math-latex ac-source-latex-commands)
               ac-sources))
)

(add-hook 'latex-mode-hook 'ac-latex-mode-setup)

(defvar ac-source-math-latex-everywere
'((candidates . ac-math-symbols-latex)
  (prefix . "\\\\\\(.*\\)")
  (action . ac-math-action-latex)
  (symbol . "l")
 ))

; Set pdf mode
(setq TeX-PDF-mode 1)

;; use Skim as default pdf viewer
;; Skim's displayline is used for forward search (from .tex to .pdf)
;; option -b highlights the current line; option -g opens Skim in the background  
(setq TeX-view-program-selection '((output-pdf "PDF Viewer")))
(setq TeX-view-program-list
     '(("PDF Viewer" "/Applications/Skim.app/Contents/SharedSupport/displayline -b -g %n %o %b")))

(server-start); start emacs in server mode so that skim can talk to it

; Enable synctex
(setq TeX-source-correlate-mode 1)
(setq TeX-source-correlate-method 'synctex)
