
;; -*- mode: emacs-lisp -*-
;; Simple .emacs configuration

;; ---------------------
;; -- Global Settings --
;; ---------------------
(add-to-list 'load-path "~/.emacs.d/lisp")   
(add-to-list 'load-path "~/.emacs.d/elpa/")
(require 'cl)
(require 'ido)
(require 'ffap)
(require 'uniquify)
(require 'ansi-color)
(require 'recentf)
(require 'linum)
(require 'smooth-scrolling)
(require 'whitespace)
(require 'dired-x)
(require 'compile)

(ido-mode t)
(menu-bar-mode -1)
(normal-erase-is-backspace-mode 0)
(put 'downcase-region 'disabled nil)
(put 'upcase-region 'disabled nil)
(setq column-number-mode t)
(setq inhibit-startup-message t)
(setq save-abbrevs nil)
(setq show-trailing-whitespace t)
(setq suggest-key-bindings t)
(setq vc-follow-symlinks t)
(setq backup-directory-alist `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms `((".*" ,temporary-file-directory t)))
(setq create-lockfiles nil)
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)


;; (setenv
;;  "PATH" (concat
;;          "$HOME/.node/bin:"
;;          "/usr/bin:"
;;          "/bin:"
;;          "/usr/sbin:"
;;          "/sbin:"
;;          "/usr/local/bin:"
;;          "/usr/local/git/bin"

(require 'package)
(add-to-list 'package-archives
	     '("melpa" . "http://melpa.milkbox.net/packages/"))
(setq package-enable-at-startup nil)
(package-initialize)

(load-theme 'zenburn t)

;; Copy PATH variable using exec-path-from-shell package.
;; This will allow the Mac OSX Emacs version to have access to PATH.
(when (memq window-system '(mac ns))
  (exec-path-from-shell-initialize))
(set-variable 'magit-emacsclient-executable "/usr/local/bin/emacsclient")
(setq magit-last-seen-setup-instructions "1.4.0")

;; enables showing the matching parentheses
(setq show-paren-delay 0)
(show-paren-mode t)
(setq show-paren-style 'expression)
(set-face-attribute 'show-paren-match-face nil
		    :weight 'bold :underline t :overline nil :slant 'normal)

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:inherit autoface-default :strike-through nil :underline nil :slant normal :weight normal :height 120 :width normal :family "monaco"))))
 '(column-marker-1 ((t (:background "red"))))
 '(diff-added ((t (:foreground "cyan"))))
 '(flymake-errline ((((class color) (background light)) (:background "Red"))))
 '(font-lock-comment-face ((((class color) (min-colors 8) (background light)) (:foreground "red"))))
 '(fundamental-mode-default ((t (:inherit default))))
 '(highlight ((((class color) (min-colors 8)) (:background "white" :foreground "magenta"))))
 '(isearch ((((class color) (min-colors 8)) (:background "yellow" :foreground "black"))))
 '(linum ((t (:foreground "black" :weight bold))))
 '(region ((((class color) (min-colors 8)) (:background "white" :foreground "magenta"))))
 '(secondary-selection ((((class color) (min-colors 8)) (:background "gray" :foreground "cyan"))))
 '(show-paren-match ((((class color) (background light)) (:background "black"))))
 '(vertical-border ((t nil))))


;; ------------
;; -- Macros --
;; ------------
(load "defuns-config.el")
(fset 'align-equals "\C-[xalign-regex\C-m=\C-m")
(global-set-key "\M-=" 'align-equals)
(global-set-key "\C-x\C-m" 'execute-extended-command)
(global-set-key "\C-c;" 'comment-or-uncomment-region)
(global-set-key "\M-n" 'next5)
(global-set-key "\M-p" 'prev5)
(global-set-key "\M-o" 'other-window)
(global-set-key "\M-i" 'back-window)
(global-set-key "\C-z" 'zap-to-char)
(global-set-key "\M-d" 'delete-word)
(global-set-key "\M-h" 'backward-delete-word)
(global-set-key "\M-u" 'zap-to-char)
(global-set-key "\C-cf" 'rgrep)
(global-set-key "\C-c\C-l" 'locate)


;; --------------
;; -- Org Mode --
;; --------------
(require 'org)
(global-set-key "\C-cs" 'org-store-link)
(global-set-key "\C-ca" 'org-agenda)
(setq org-log-done t)

;; --------------
;; -- Helm --
;; --------------
(require 'helm)
(require 'helm-config)
;; The default "C-x c" is quite close to "C-x C-c", which quits Emacs.
;; Changed to "C-c h". Note: We must set "C-c h" globally, because we
;; cannot change 'helm-command-prefix-key' once 'helm-config' is loaded.
(global-set-key (kbd "C-c h") 'helm-command-prefix-key)
(global-unset-key (kbd "C-x c"))
(global-set-key (kbd "M-x") 'helm-M-x) ; replace default M-x with helm-M-x
(global-set-key (kbd "M-y") 'helm-show-kill-ring)
(global-set-key (kbd "C-x b") 'helm-mini)
(global-set-key (kbd "C-x C-f") 'helm-find-files)
;; (when (executable-find "ack-grep")
;;   (setq helm-grep-default-command "ack-grep -Hn --no-group --no-color %e %p %f"
;;         helm-grep-default-recurse-command "ack-grep -H --no-group --no-color %e %p %f"))

(define-key helm-map (kbd "<tab>") 'helm-execute-persistent-action) ; rebind tab to run persistent action
(define-key helm-map (kbd "C-i") 'helm-execute-persistent-action) ; make TAB works in terminal
(define-key helm-map (kbd "C-z") 'helm-select-action) ; list actions using C-z

(when (executable-find "curl")
  (setq helm-google-suggest-use-curl-p t))

(setq helm-split-window-in-side-p            t ; open helm buffer inside current window, not occupy whole other window.
      helm-move-to-line-cycle-in-source      t ; move to end or beginning of source when reaching top or bottom of source.
      helm-ff-search-library-in-sexp         t ; search for library in 'require' and 'declare-function' sexp.
      helm-scroll-amount                     8 ; scroll 8 lines other window using M-<next>/M-<prior>.
      helm-ff-file-name-histry-use-recentf   t)

(helm-mode 1)

;; ---------------------------
;; -- Helm Projectile --
;; ---------------------------
(projectile-global-mode)
(setq projectile-completion-system 'helm)
(helm-projectile-on)

;; ---------------------------
;; -- JS Mode configuration --
;; ---------------------------
(load "js-config.el")
;; (add-to-list 'load-path "~/.emacs.d/jade-mode") ;; github.com/brianc/jade-mode
;; (require 'sws-mode)
;; (require 'jade-mode)    
;; (add-to-list 'auto-mode-alist '("\\.styl$" . sws-mode))
;; (add-to-list 'auto-mode-alist '("\\.jade$" . jade-mode))


;; --------------------------
;; -- Web Mode Config --
;; --------------------------
(require 'web-mode)
(add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.handlebars\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.hbs\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.eex\\'" . web-mode))
;; (add-hoook 'web-mode-hook (lambda () (ember-mode t)))


;; -------------------------
;; -- auto-complete Config --
;; -------------------------
;; (add-to-list 'load-path "~/.emacs.d/elpa/auto-complete-20141111.2346")
(require 'auto-complete)
(global-auto-complete-mode t)


;; -------------------------
;; -- SCSS Mode Config --
;; -------------------------
(setq scss-compile-at-save nil)


;; --------------------------
;; -- JS2 Config --
;; --------------------------
;; (autoload 'js2-mode "js2" nil t)
(add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))
;; (add-hook 'js2-mode-hook' (lambda () (ember-mode t)))
;; (add-hook 'js-mode-hook 'js2-minor-mode)
;; (add-hook 'js2-mode-hook 'ac-js2-mode)

;; --------------------------
;; -- JS Comint Config --
;; --------------------------
;; (require 'js-comint)
;; (add-hook 'js2-mode-hook '(lambda ()
;; 			    (local-set-key "\C-x\C-e" 'js-send-last-sexp)
;; 			    (local-set-key "\C-\M-x" 'js-send-last-sexp-and-go)
;; 			    (local-set-key "\C-cb" 'js-send-buffer)
;; 			    (local-set-key "\C-c\C-b" 'js-send-buffer-and-go)
;; 			    (local-set-key "\C-cl" 'js-load-file-and-go)
;; 			    ))

;; --------------------------
;; -- Tern Config --
;; --------------------------
;; (add-hook 'js-mode-hook (lambda () (tern-mode t)))
;; (add-hook 'js2-mode-hook (lambda () (tern-mode t)))
;; (eval-after-load 'tern
;;   '(progn
;;      (require 'tern-auto-complete)
;;      (tern-ac-setup)))


;; -------------------------
;; -- Ediff Config
;; -------------------------
;; http://emacswiki.org/emacs/EdiffMode
;; This should restore window configuration when exiting ediff mode
(add-hook 'ediff-load-hook
          (lambda ()
            
            (add-hook 'ediff-before-setup-hook
                      (lambda ()
                        (setq ediff-saved-window-configuration (current-window-configuration))))
            
            (let ((restore-window-configuration
                   (lambda ()
                     (set-window-configuration ediff-saved-window-configuration))))
              (add-hook 'ediff-quit-hook restore-window-configuration 'append)
              (add-hook 'ediff-suspend-hook restore-window-configuration 'append))))

;; --------------------------
;; -- Custom Config --
;; --------------------------
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("e80932ca56b0f109f8545576531d3fc79487ca35a9a9693b62bf30d6d08c9aaf" "8db4b03b9ae654d4a57804286eb3e332725c84d7cdab38463cb6b97d5762ad26" "31a01668c84d03862a970c471edbd377b2430868eccf5e8a9aec6831f1a0908d" "1297a022df4228b81bc0436230f211bad168a117282c20ddcba2db8c6a200743" default)))
 '(ediff-window-setup-function (quote ediff-setup-windows-plain))
 '(helm-split-window-in-side-p t)
 '(js-curly-indent-offset 0)
 '(js-expr-indent-offset 4)
 '(js2-basic-offset 4)
 '(js2-bounce-indent-p nil)
 '(web-mode-code-indent-offset 4)
 '(web-mode-markup-indent-offset 4))
