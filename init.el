(when (>= emacs-major-version 24)
  (require 'package)
  (setq package-enable-at-startup nil)
  (setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
                     ("marmalade" . "http://marmalade-repo.org/packages/")
                     ("melpa" . "http://melpa.org/packages/")))
  (package-initialize)
)

(unless (package-installed-p 'use-package)
	(package-refresh-contents)
	(package-install 'use-package))

;; start emacs as a server
(server-start)
(add-hook 'server-done-hook
          (defun open-terminal ()
            (shell-command "open -a iTerm")))

;; load all of my Emacs configurations from the org file
(org-babel-load-file (expand-file-name "~/.emacs.d/myinit.org"))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (yaml-mode highlight-indentation magit-todos forge treemacs-persp treemacs-magit treemacs-projectile treemacs magit ace-window multiple-cursors counsel-tramp counsel-projectile ivy-xref ivy-prescient prescient amx projectile counsel org org-dropbox org-bullets use-package))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(aw-leading-char-face ((t ((:inherit ace-jump-face-foreground :height 3.0)))))
 '(ivy-minibuffer-match-face-1 ((t (:inherit font-lock-doc-face :foreground nil))) t))
