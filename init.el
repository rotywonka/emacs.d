(require 'package)
(setq package-enable-at-startup nil)

;; https://emacs.stackexchange.com/a/2989
(setq package-archives
      '(("elpa"     . "https://elpa.gnu.org/packages/")
        ("melpa-stable" . "https://stable.melpa.org/packages/")
        ("melpa"        . "https://melpa.org/packages/"))
      package-archive-priorities
      '(("melpa-stable" . 10)
        ("elpa"     . 5)
        ("melpa"        . 0)))

(package-initialize)
(server-start)

;; Bootstrap `use-package`
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(require 'use-package)

;;
(add-hook 'after-init-hook 'global-company-mode)

;; visual line mode
(setq line-move-visual nil)
;; enable TRAMP
(setq tramp-default-method "ssh")

;;alias for y or no
(defalias 'yes-or-no-p 'y-or-n-p)

;; Don't litter my init file with all of those custom definitions
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(load custom-file 'noerror)

;;save auto-save files in one directory
(setq backup-directory-alist
      `(("." . ,(concat user-emacs-directory "backups"))))


;; code folding using hideShow
(load-library "hideshow")
(add-hook 'c-mode-common-hook
  (lambda()
    (local-set-key (kbd "C-c DEL") 'hs-hide-block)
    (local-set-key (kbd "C-c <S-backspace>")  'hs-show-block)
    (hs-minor-mode t))
    )

;; (add-hook 'c-mode-common-hook   'hs-minor-mode)
;; (add-hook 'emacs-lisp-mode-hook 'hs-minor-mode)
;; (add-hook 'java-mode-hook       'hs-minor-mode)
;; (add-hook 'lisp-mode-hook       'hs-minor-mode)
;; (add-hook 'perl-mode-hook       'hs-minor-mode)
;; (add-hook 'sh-mode-hook         'hs-minor-mode)
;;relative line numbers package
(setq-default display-line-numbers 'relative)
(setq-default display-line-numbers-type 'relative)
(face-spec-set 'line-number-current-line
               '((t (:foreground "firebrick" :background "orange"))))
;;fixes the weird fringe problem for line numbers
(setq nlinum-format "%4d ")

;;disable tool bar/menu bar up TOP NI🅱️🅱️a
(tool-bar-mode -1)

;;disable emacs startup buffer
;; no startup msg
(setq inhibit-startup-message t)
;;disable tabs globally
(setq-default indent-tabs-mode nil)

;;fixes the weird bug that python-mode has with adding 6 spaces as opposed
;;to 4 spaces
(eval-after-load "python" `(progn
    (add-hook 'python-mode-hook #'(lambda ()
    (setq indent-tabs-mode nil)
    ;(auto-complete-mode 0)
    (setq tab-width 4)
		(setq python-indent-offset 4)
		(setq python-indent-guess-indent-offset nil)))))

;; adds function header to the top UI element
;; (add-to-list 'semantic-default-submodes 'global-semantic-stickyfunc-mode)
;; (semantic-mode 1)
;; (load-file "~/.emacs.d/stickyfunc-enhance.el")
;; (require 'stickyfunc-enhance)

;;deletes unnecessary whitespace when you hit delete
;; (use-package hungry-delete
;;   :ensure t
;;   :config
;;   (global-hungry-delete-mode))

;;highlights the current cursor line
;;(global-hl-line-mode t)
;;smart-tabs

(use-package inf-ruby
  :ensure t
  :config
  (autoload 'inf-ruby-minor-mode "inf-ruby" "Run an inferior Ruby process" t)
  (add-hook 'ruby-mode-hook 'inf-ruby-minor-mode)
  )


(use-package ruby-electric
 :ensure t
 :init
 (add-hook 'ruby-mode-hook '(lambda () (ruby-electric-mode t)))
 :config
 (setq ruby-electric-expand-delimiters-list nil)
)

(use-package smart-tabs-mode
  :ensure t
  :init
  (progn
    (smart-tabs-insinuate 'c 'c++)
    )
  )
;;disable M-h in org-mode
(add-hook 'org-mode-hook
             '(lambda ()
                (define-key org-mode-map "\M-h" nil)))

(use-package molokai-theme 
  :ensure t
  :init (load-theme 'molokai t)
  :config (setq molokai-theme-kit t)
  )

;;source code pro font
(set-face-attribute 'default nil
                    :family "Source Code Pro"
                    :height 90
                    :weight 'normal
                    :width 'normal)

;;connection fix for emacs packages because sometimes u can't refresh package contents
(require 'gnutls)
(add-to-list 'gnutls-trustfiles "/usr/local/etc/openssl/cert.pem")

;;Bootstrap use-package
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

;;tab width
(setq-default tab-width 2)



;;insert new-line if ur at end of buffer
(setq next-line-add-newlines t)

;; Snippets
(use-package yasnippet
  :ensure t
  :diminish yas-minor-mode
  :init (yas-global-mode 1)
)

(define-key yas-minor-mode-map (kbd "<tab>") nil)
(define-key yas-minor-mode-map (kbd "TAB") nil)
(define-key yas-minor-mode-map (kbd "<C-tab>") 'yas-expand)

;; Autocomplete
(use-package company
  :defer 10
  :diminish company-mode
  :bind (:map company-active-map
              ("M-j" . company-select-next)
              ("M-k" . company-select-previous))
  :preface
  ;; enable yasnippet everywhere
  (defvar company-mode/enable-yas t
    "Enable yasnippet for all backends.")
  (defun company-mode/backend-with-yas (backend)
    (if (or 
         (not company-mode/enable-yas) 
         (and (listp backend) (member 'company-yasnippet backend)))
        backend
      (append (if (consp backend) backend (list backend))
              '(:with company-yasnippet))))
  :config
  
  ;; no delay no autocomplete
  (setq
   company-idle-delay 0
   company-minimum-prefix-length 2
   company-tooltip-limit 20)

  (setq company-backends 
        (mapcar #'company-mode/backend-with-yas company-backends)))

(defun check-expansion ()
    (save-excursion
      (if (looking-at "\\_>") t
        (backward-char 1)
        (if (looking-at "\\.") t
          (backward-char 1)
          (if (looking-at "->") t nil)))))

  (defun do-yas-expand ()
    (let ((yas/fallback-behavior 'return-nil))
      (yas/expand)))

  (defun tab-indent-or-complete ()
    (interactive)
    (if (minibufferp)
        (minibuffer-complete)
      (if (or (not yas/minor-mode)
              (null (do-yas-expand)))
          (if (check-expansion)
              (company-complete-common)
            (indent-for-tab-command)))))

(global-set-key [tab] 'tab-indent-or-complete)

;; ws-butler
(add-hook 'c-mode-common-hook 'ws-butler-mode)


; Code-comprehension server
(use-package ycmd
  :ensure t
  :init (add-hook 'c++-mode-hook #'ycmd-mode 'c-mode-hook)
  :config
  (set-variable 'ycmd-server-command '("python2" "/Users/tommytan/.vim/bundle/YouCompleteMe/third_party/ycmd/ycmd"))
  (set-variable 'ycmd-global-config (expand-file-name "~/Users/tommytan/.vim/bundle/YouCompleteMe/third_party/ycmd/.ycm_extra_conf.py"))

  (set-variable 'ycmd-extra-conf-whitelist '("~/Repos/*"))

  (use-package company-ycmd
    :ensure t
    :init (company-ycmd-setup)
    :config (add-to-list 'company-backends (company-mode/backend-with-yas 'company-ycmd))))
  ;; Default colors are awful - borrowed these from gocode (thanks!):
  ;; https://github.com/nsf/gocode/tree/master/emacs-company#color-customization
;;Auto completion for C/C++ headers
(use-package company-c-headers
  :defer t
  :init
  (add-hook 'c-mode-common-hook 'ycmd-mode-hook 'c++-mode-hook
            (lambda ()
              (when (derived-mode-p 'c-mode 'c++-mode)
                  (add-to-list 'company-backends 'company-c-headers)))))

(eval-when-compile
  (require 'use-package))
(require 'diminish)
(require 'bind-key)

;;Pairs braces and quotes
(require 'autopair)
(autopair-global-mode)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require 'org)
(define-key global-map "\C-cl" 'org-store-link)
(define-key global-map "\C-ca" 'org-agenda)
(setq org-log-done t)

;;(ac-config-default)

(show-paren-mode 1)
(delete-selection-mode 1)

(global-set-key (kbd "C-z") 'undo)
(setq ns-function-modifier 'control)
(set-face-attribute 'default nil :height 140)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;syntax check
(use-package flycheck
  :ensure t
  :diminish flycheck-mode
  :config (set-face-attribute 'flycheck-error nil :foreground "black" :background "red") (set-face-attribute 'flycheck-warning nil :foreground "black" :background "yellow")
  (add-hook 'c++-mode-hook
            (lambda () (setq flycheck-clang-language-standard "c++11")))
  (add-hook 'c++-mode-hook 'flycheck-mode)
(add-hook 'python-mode-hook 'flycheck-mode))

(use-package flycheck-ycmd
  :ensure t
  :commands (flycheck-ycmd-setup)
  :init (add-hook 'ycmd-mode-hook 'flycheck-ycmd-setup))

;;helm package
(use-package helm
  :ensure t
  :config (progn
            (setq helm-buffers-fuzzy-matching t)
            (helm-mode 1)))

;;helm g-tags
(use-package helm-gtags
  :ensure t
  :commands (helm-gtags-mode helm-gtags-dwim)
  :diminish "HGt"
  :config
  (progn
    ;; keys
    (setq
     helm-gtags-ignore-case t
     helm-gtags-auto-update t
     helm-gtags-use-input-at-cursor t
     helm-gtags-pulse-at-cursor t
     helm-gtags-prefix-key "\C-cg"
     helm-gtags-suggested-key-mapping t
     )    
    (define-key helm-gtags-mode-map (kbd "C-c f") 'helm-gtags-dwim)
    (define-key helm-gtags-mode-map (kbd "M-t") 'helm-gtags-find-tag)
    (define-key helm-gtags-mode-map (kbd "M-r") 'helm-gtags-find-rtag)
    (define-key helm-gtags-mode-map (kbd "M-s") 'helm-gtags-find-symbol)
    (define-key helm-gtags-mode-map (kbd "C-c <") 'helm-gtags-previous-history)
    (define-key helm-gtags-mode-map (kbd "C-c >") 'helm-gtags-next-history)
    (define-key helm-gtags-mode-map (kbd "M-,") 'helm-gtags-pop-stack)))

;; ;; Enable helm-gtags-mode in code
;;(add-hook 'c-mode-hook 'helm-gtags-mode)
;;(add-hook 'c++-mode-hook 'helm-gtags-mode)
;;(add-hook 'asm-mode-hook 'helm-gtags-mode)

;;ggtags test
(add-hook 'c-mode-common-hook
              (lambda ()
                (when (derived-mode-p 'c-mode 'c++-mode 'java-mode 'python-mode)
                  (ggtags-mode 1))))



;;ggtags
;; GNU Global Tags
;; (use-package ggtags
;;   :ensure t
;;   :commands ggtags-mode
;;   :diminish ggtags-mode
;;   :bind (("M-*" . pop-tag-mark)
;;          ("C-c t s" . ggtags-find-other-symbol)
;;          ("C-c t h" . ggtags-view-tag-history)
;;          ("C-c t r" . ggtags-find-reference)
;;          ("C-c t f" . ggtags-find-file)
;;          ("C-c t c" . ggtags-create-tags))
;;   :init(add-hook 'c-mode-common-hook
;;           (lambda ()
;;             (when (derived-mode-p 'c-mode 'c++-mode 'java-mode)
;;               (ggtags-mode 1)))))

(setq flycheck-highlighting-mode 'lines)
;;(add-hook 'prog-mode-hook 'flycheck-mode)
(add-hook 'text-mode-hook 'flycheck-mode)
;;(setq flycheck-check-syntax-automatically '(save idle-change
;; new-line mode-enabled))
;; the default value was '(save idle-change new-line mode-enabled)
;; (setq flycheck-check-syntax-automatically '(save
;;                                               idle-change
;;
;;        mode-enabled))
;;disables the scroll-bar ui

(scroll-bar-mode -1)

;; ONLY FOR MacOS/OSX devices
;(when (memq window-system '(mac ns x))
;  (exec-path-from-shell-initialize))

(use-package ace-window
  :ensure t
  :init
  (progn
    (global-set-key [remap other-window] 'ace-window)
    (custom-set-faces
     '(aw-leading-char-face
     ((t (:inherit ace-jump-face-foreground :height 3.0)))))
    ))


;;ycmd mode
(add-to-list 'load-path "~/.emacs.d/emacs-ycmd")
(require 'ycmd)
(add-hook 'c++-mode-hook 'ycmd-mode)

;;ruby seeing-is-believing
(use-package seeing-is-believing
  :ensure t
  :config (add-hook 'ruby-mode-hook 'seeing-is-believing)
  )


;;search navigation SWIPER
(use-package counsel
  :ensure t
  )

(use-package swiper
  :ensure t
  :config
  (progn
        (ivy-mode 1)
	(setq ivy-use-virtual-buffers t)
	(setq enable-recursive-minibuffers t)
	(global-set-key "\C-s" 'swiper)
	(define-key minibuffer-local-map (kbd "C-r") 'counsel-minibuffer-history)))

;;org-mode stuff
(use-package org-bullets
  :ensure t
  :config
  (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))
  )

;; so if ur experiencing ur mode-line to have a whitish transparent color overlapping the 
;; arrows then just use this command, it might look un-aesthetic tho :/
;;(setq powerline-default-separator 'utf-8)

;;mode-line customization
(use-package spaceline :ensure t
  :config
  (use-package spaceline-config
    :config
    (spaceline-toggle-minor-modes-off)
    (spaceline-toggle-buffer-encoding-off)
    (spaceline-toggle-buffer-encoding-abbrev-off)
    (setq powerline-default-separator 'arrow)
    (spaceline-define-segment line-column
      "The current line and column numbers."
      "l:%l c:%2c")
    (spaceline-define-segment time
      "The current time."
      (format-time-string "%I:%M"))
    (spaceline-define-segment date
      "The current date."
      (format-time-string "%h %d"))
    (spaceline-toggle-time-on)
    (spaceline-emacs-theme 'date 'time)))

;;molokai-theme for emacs
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes")

;;rebind movement keys to alt-hjkl
(global-set-key (kbd "M-h") 'backward-word)
(global-set-key (kbd "M-j") 'scroll-down-command)
(global-set-key (kbd "M-k") 'scroll-up-command)
(global-set-key (kbd "M-l") 'forward-word)

;;rename buffer and file
(defun rename-file-and-buffer ()
  "Rename the current buffer and file it is visiting."
  (interactive)
  (let ((filename (buffer-file-name)))
    (if (not (and filename (file-exists-p filename)))
        (message "Buffer is not visiting a file!")
      (let ((new-name (read-file-name "New name: " filename)))
        (cond
         ((vc-backend filename) (vc-rename-file filename new-name))
         (t
          (rename-file filename new-name t)
          (set-visited-file-name new-name t t)))))))
(global-set-key (kbd "C-c r")  'rename-file-and-buffer)


(setq powerline-image-apple-rgb t)
(setq ns-use-srgb-colorspace nil)
(set-face-attribute 'fringe nil :background nil)

;;;;Python setup
;;jedi setup
(add-hook 'python-mode-hook 'jedi:setup)
(setq jedi:complete-on-dot t)    
(elpy-enable)
(setq elpy-rpc-timeout 10)
;;removes flymake from elpy since I'm running flycheck already lel
(remove-hook 'elpy-modules 'elpy-module-flymake)
;; keybinding to change go-to definition from jedi
(eval-after-load 'jedi
  '(progn
     (define-key jedi-mode-map (kbd "C-c .") nil)
     ))
(setq jedi:key-goto-definition (kbd "M-."))

;;autopep
(add-hook 'python-mode-hook 'py-autopep8-enable-on-save)
(setq py-autopep8-options '("--max-line-length=100"))

;;Setting Tab to indent region if anything is selected
(defun tab-indents-region () (local-set-key [(tab)] 'fledermaus-maybe-tab))
   (add-hook 'c-mode-common-hook   'tab-indents-region)
    ;;fledermaus came up with this
(defun fledermaus-maybe-tab ()
    (interactive)
    (if (and transient-mark-mode mark-active)
    (indent-region (region-beginning) (region-end) nil)
    (c-indent-command)))



;;fixes scrolling lag
(setq jit-lock-defer-time 0.05)
;;default minibuffer message
(defun display-startup-echo-area-message ()
  (message "Let the hacking begin, my Lord!"))
