;; Package manager and sources
;(require 'package)
;(setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
;                         ("marmalade" . "http://marmalade-repo.org/packages/")
;                         ("melpa" . "http://melpa.milkbox.net/packages/")))
;(package-initialize)

(require 'cask "/usr/local/Cellar/cask/0.7.0/cask.el")
(cask-initialize)
(require 'pallet)

;; When running emacs.app in Mac OS X, copy the path from terminal
;; (this avoids problems with finding aspell, latex, etc.)
(when (memq window-system '(mac ns))
  (exec-path-from-shell-initialize)
  (exec-path-from-shell-copy-env "JAVA_HOME"))

;; Themes
(setq ns-use-srgb-colorspace 1) ;; shouldn't be needed in 24.4?
;(load-theme 'solarized-light t)
(load-theme 'sanityinc-tomorrow-eighties 1)
;; Font
(when window-system
  (set-face-attribute 'default nil :font "Sauce Code Powerline"))

;; powerline modeline
;; (display problem with terminal emacs?)
(require 'powerline)
(powerline-default-theme)

;; initial size
(setq default-frame-alist '((width . 90)
			    (height . 45)))

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
(global-rainbow-delimiters-mode)

;; Smartparens
(smartparens-global-mode 1)
(require 'smartparens-config)
(show-smartparens-mode 1)

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
;; (compatibility with current color theme/powerline :()
;; (require 'flycheck-color-mode-line)
;; (eval-after-load "flycheck"
;;   '(add-hook 'flycheck-mode-hook 'flycheck-color-mode-line-mode))

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
(setq langtool-language-tool-jar "/usr/local/Cellar/languagetool/2.4.1/libexec/languagetool.jar"
      langtool-mother-tongue "en-US")

;; magit
(require 'magit)
(global-set-key "\C-xg" 'magit-status)

;; fountain-mode
(add-to-list 'auto-mode-alist '("\\.fountain\\'" . fountain-mode))

;; markdown
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
;; Python
;;
(setq py-install-directory "/Users/john/.emacs.d/.cask/24.3.1/elpa/python-mode-6.1.3/")
(add-to-list 'load-path py-install-directory)
(require 'python-mode)
(when (featurep 'python) (unload-feature 'python t))
;(add-to-list 'auto-mode-alist '("\\.py\\'" . python-mode))
;(add-to-list 'interpreter-mode-alist '("python" . python-mode))
(add-hook 'python-mode-hook 'flyspell-prog-mode)
;; ipython
;; (for some reason this is forcing python.el rather than python-mode.el)
;; (defun python-use-ipython (cmd args)
;;  (setq ipython-command cmd)
;;  (setq py-python-command-args args)
;;  (require 'ipython)
;;  (setq ipython-completion-command-string
;;        "print(';'.join(__IP.Completer.all_completions('%s')))\n"))
;; (python-use-ipython "/usr/local/bin/ipython" '("-colors" "LightBG" "-nobanner"))
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

;; old Skim setup, doesn't seem needed anymore
;; (add-hook 'LaTeX-mode-hook
;;       (lambda()
;;         (add-to-list 'TeX-expand-list
;;              '("%q" skim-make-url))))

;; (defun skim-make-url () (concat
;;         (TeX-current-line)
;;         " "
;;         (expand-file-name (funcall file (TeX-output-extension) t)
;;             (file-name-directory (TeX-master-file)))
;;         " "
;;         (buffer-file-name)))

;; Don't remember what this was for, maybe attempting to set up Skim previously?
;; doesn't seem to cause any problems with it disabled right now

;; (custom-set-variables
;;  ;; custom-set-variables was added by Custom.
;;  ;; If you edit it by hand, you could mess it up, so be careful.
;;  ;; Your init file should contain only one such instance.
;;  ;; If there is more than one, they won't work right.
;;  '(TeX-command-list (quote (("TeX" "%(PDF)%(tex) %`%S%(PDFout)%(mode)%' %t" TeX-run-TeX nil (plain-tex-mode texinfo-mode ams-tex-mode) :help "Run plain TeX") ("LaTeX" "%`%l%(mode)%' %t" TeX-run-TeX nil (latex-mode doctex-mode) :help "Run LaTeX") ("Makeinfo" "makeinfo %t" TeX-run-compile nil (texinfo-mode) :help "Run Makeinfo with Info output") ("Makeinfo HTML" "makeinfo --html %t" TeX-run-compile nil (texinfo-mode) :help "Run Makeinfo with HTML output") ("AmSTeX" "%(PDF)amstex %`%S%(PDFout)%(mode)%' %t" TeX-run-TeX nil (ams-tex-mode) :help "Run AMSTeX") ("ConTeXt" "texexec --once --texutil %(execopts)%t" TeX-run-TeX nil (context-mode) :help "Run ConTeXt once") ("ConTeXt Full" "texexec %(execopts)%t" TeX-run-TeX nil (context-mode) :help "Run ConTeXt until completion") ("BibTeX" "bibtex %s" TeX-run-BibTeX nil t :help "Run BibTeX") ("Biber" "biber %s" TeX-run-Biber nil t :help "Run Biber") ("View" "%V" TeX-run-command t t :help "Run Text viewer") ("Print" "%p" TeX-run-command t t :help "Print the file") ("Queue" "%q" TeX-run-background nil t :help "View the printer queue" :visible TeX-queue-command) ("File" "%(o?)dvips %d -o %f " TeX-run-command t t :help "Generate PostScript file") ("Index" "makeindex %s" TeX-run-command nil t :help "Create index file") ("Check" "lacheck %s" TeX-run-compile nil (latex-mode) :help "Check LaTeX file for correctness") ("Spell" "(TeX-ispell-document \"\")" TeX-run-function nil t :help "Spell-check the document") ("Clean" "TeX-clean" TeX-run-function nil t :help "Delete generated intermediate files") ("Clean All" "(TeX-clean t)" TeX-run-function nil t :help "Delete generated intermediate and output files") ("Other" "" TeX-run-command t t :help "Run an arbitrary command"))))
;;  '(custom-safe-themes (quote ("1b8d67b43ff1723960eb5e0cba512a2c7a2ad544ddb2533a90101fd1852b426e" "1e7e097ec8cb1f8c3a912d7e1e0331caeed49fef6cff220be63bd2a6ba4cc365" "06f0b439b62164c6f8f84fdda32b62fb50b6d00e8b01c2208e55543a6337433a" "bb08c73af94ee74453c90422485b29e5643b73b05e8de029a6909af6a3fb3f58" "fc5fcb6f1f1c1bc01305694c59a1a861b008c534cae8d0e48e4d5e81ad718bc6" "628278136f88aa1a151bb2d6c8a86bf2b7631fbea5f0f76cba2a0079cd910f7d" default))))
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes (quote ("fc5fcb6f1f1c1bc01305694c59a1a861b008c534cae8d0e48e4d5e81ad718bc6" "1e7e097ec8cb1f8c3a912d7e1e0331caeed49fef6cff220be63bd2a6ba4cc365" default))))

