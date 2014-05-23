;; Using Cask for Package Management
(require 'cask "~/.cask/cask.el")
(cask-initialize)

;; Keeps ~Cask~ file in sync with the packages
;; that you install/uninstall via ~M-x list-packages~
;; https://github.com/rdallasgray/pallet
(require 'pallet)

;; ==================================================
;;                 Basic Settings
;; ==================================================

(push "/usr/local/bin" exec-path)
(set-frame-font "Source Code Pro for Powerline-14")
(global-visual-line-mode t)
(delete-selection-mode t)
(blink-cursor-mode t)
(show-paren-mode t)
(setq backup-directory-alist `(("." . "~/.saves")))
(setq auto-save-default nil)
(setq inhibit-startup-message t)
(setq-default tab-width 4)
(setq-default indent-tabs-mode nil)
(fset 'yes-or-no-p 'y-or-n-p)
(electric-indent-mode t)
(setq redisplay-dont-pause t
      scroll-margin 1
      scroll-step 1
      scroll-conservatively 10000
      scroll-preserve-screen-position 1)
(when (window-system)
  (tooltip-mode -1)
  (set-fringe-style -1)
  (scroll-bar-mode -1)
  (tool-bar-mode -1))

(global-auto-revert-mode 1)
(setq ring-bell-function 'ignore)

;; ==================================================
;;               AUTO MODES
;; ==================================================

;; Web-mode
(add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.hbs\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.handlebars\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.html\\'" . web-mode))

;; Emmet
(add-hook 'html-mode-hook 'emmet-mode)
(add-hook 'web-mode-hook 'emmet-mode)

;; ORG mode
(add-to-list 'auto-mode-alist '("\\.txt\\'" . org-mode))


;; ==================================================
;;             HARMY MODE MAPPINGS
;; ==================================================

;; Define my own keymap
(defvar harmy-mode-map (make-keymap) "my keys")

;; Cursor keys on home row
(define-key harmy-mode-map (kbd "M-j") 'next-line)
(define-key harmy-mode-map (kbd "M-k") 'previous-line)
(define-key harmy-mode-map (kbd "M-h") 'backward-char)
(define-key harmy-mode-map (kbd "M-l") 'forward-char)

;; EXPAND REGION
(define-key harmy-mode-map (kbd "C-=") 'er/expand-region)

;; ACE JUMP MODE
(define-key harmy-mode-map (kbd "C-c SPC") 'ace-jump-mode)

;; CUSTOM FUNCTIONS
(define-key harmy-mode-map (kbd "M-l") 'select-current-line)
(define-key harmy-mode-map (kbd "M-RET") 'line-above)
(define-key harmy-mode-map (kbd "C-S-y") 'duplicate-current-line-or-region)
(define-key harmy-mode-map (kbd "M-'") 'create-snippet)
(define-key harmy-mode-map (kbd "C-c r") 'rename-this-buffer-and-file)

;; PROJECTILE and HELM
(global-set-key (kbd "C-c h") 'helm-projectile)

;; WINDMOVE
(define-key harmy-mode-map (kbd "C-M-n")  'windmove-left)
(define-key harmy-mode-map (kbd "C-M-i") 'windmove-right)
(define-key harmy-mode-map (kbd "C-M-u")    'windmove-up)
(define-key harmy-mode-map (kbd "C-M-e")  'windmove-down)

;; MULTIPLE CURSORS
(define-key harmy-mode-map (kbd "C-'")  'mc/mark-next-like-this)
(define-key harmy-mode-map (kbd "C-\"")  'mc/mark-previous-like-this)

;; MAGIT status
(define-key harmy-mode-map (kbd "C-c C-t")  'magit-status)


;; ==================================================
;;             GLOBAL MAPPINGS
;; ==================================================

;; CUSTOM FUNCTIONS
(global-set-key [remap kill-region] 'cut-line-or-region)
(global-set-key [remap kill-ring-save] 'copy-line-or-region)


;; ==================================================
;;              PLUGINS and PACKAGES
;; ==================================================

;; Path
(require 'exec-path-from-shell)
(when (memq window-system '(mac ns))
  (exec-path-from-shell-initialize))

;; DIRED SETTINGS
(require 'dired)
(setq dired-recursive-deletes (quote top))
(define-key dired-mode-map (kbd "f") 'dired-find-alternate-file)
(define-key dired-mode-map (kbd "^") (lambda ()
                                       (interactive)
                                       (find-alternate-file "..")))

;; YASNIPPET
(yas-global-mode t)

;; PROJECTILE
(projectile-global-mode)

;; IDO MODE
(ido-mode 1)
(ido-everywhere 1)
(flx-ido-mode 1)
(setq ido-use-faces nil)
(ido-vertical-mode 1)

;; SAVEPLACE
(require 'saveplace)
(setq save-place-file (concat user-emacs-directory "saveplace.el"))
(setq-default save-place t)

;; AUTO-COMPLETE
(require 'auto-complete-config)
(ac-config-default)

;; SCSS MODE
(setq scss-compile-at-save nil)
(setq css-indent-offset 2)


;; JS MODE
(setq js-indent-level 2)


;; ==================================================
;;              CUSTOM FUNCTIONS
;; ==================================================

(defun select-current-line ()
  "Selects the current line"
  (interactive)
  (end-of-line)
  (push-mark (line-beginning-position) nil t))

(defun line-above()
  "Inserts line above current one"
  (interactive)
  (move-beginning-of-line nil)
  (newline-and-indent)
  (forward-line -1)
  (indent-according-to-mode))

(defun cut-line-or-region()
  "Kill current line if no region is active, otherwise kills region."
  (interactive)
  (if (region-active-p)
      (kill-region (region-beginning) (region-end))
    (kill-region (line-beginning-position) (line-beginning-position 2))))

(defun copy-line-or-region()
  "Copy current line if no region is active, otherwise copies region."
  (interactive)
  (if (region-active-p)
      (kill-ring-save (region-beginning) (region-end))
    (kill-ring-save (line-beginning-position) (line-beginning-position 2))))

(defun duplicate-current-line-or-region (arg)
  "Duplicates the current line or region ARG times.
If there's no region, the current line will be duplicated. However, if
there's a region, all lines that region covers will be duplicated."
  (interactive "p")
  (let (beg end (origin (point)))
    (if (and mark-active (> (point) (mark)))
        (exchange-point-and-mark))
    (setq beg (line-beginning-position))
    (if mark-active
        (exchange-point-and-mark))
    (setq end (line-end-position))
    (let ((region (buffer-substring-no-properties beg end)))
      (dotimes (i arg)
        (goto-char end)
        (newline)
        ;;(beginning-of-visual-line)
        (insert region)
        (indent-according-to-mode)
        (setq end (point)))
      (goto-char (+ origin (* (length region) arg) arg)))))

(defun create-snippet (filename)
  "Creates snippet file in ~/.emacs.d/snippets/<mode-name> folder"
  (interactive "s")
  (let ((mode (symbol-name major-mode)))
    (find-file (format "~/.emacs.d/snippets/%s/%s" mode filename))
    (snippet-mode)))

(defun rename-this-buffer-and-file ()
  "Renames current buffer and file it is visiting."
  (interactive)
  (let ((name (buffer-name))
        (filename (buffer-file-name)))
    (if (not (and filename (file-exists-p filename)))
        (error "Buffer '%s' is not visiting a file!" name)
      (let ((new-name (read-file-name "New name: " filename)))
        (cond ((get-buffer new-name)
               (error "A buffer named '%s' already exists!" new-name))
              (t
               (rename-file filename new-name 1)
               (rename-buffer new-name)
               (set-visited-file-name new-name)
               (set-buffer-modified-p nil)
               (message "File '%s' successfully renamed to '%s'" name (file-name-nondirectory new-name))))))))


;; Define my own minor mode and activate it
(define-minor-mode harmy-mode
  "A minor mode for my custom keys and functions"
  t " harmy" 'harmy-mode-map)
(harmy-mode t)

;; ==================================================
;;                  ORG MODE
;; ==================================================

(add-hook 'org-mode-hook
          (lambda()
            (set (make-local-variable 'electric-indent-functions)
                 (list (lambda(arg) 'no-indent)))))
(setq org-src-fontify-natively t)
(define-key global-map "\C-cc" 'org-capture)
(global-set-key "\C-ca" 'org-agenda)
(setq org-todo-keywords '((sequence "TODO(t)" "NEXT(n)" "DOING(i)" "|" "DONE(d)" "ARCHIVED")))
(setq org-todo-keyword-faces
  '(("TODO" . org-warning)
   ("DOING" . "yellow")
   ("NEXT" . "orange")
   ("DONE" . "green")
   ("ARCHIVED" . "blue")))
(setq org-agenda-custom-commands
      '(("d" todo "DOING")))
(setq org-log-done 'time)
(setq org-startup-folded 'showeverything)

;; ==================================================
;;               APPEARENCE
;; ==================================================
(load-theme 'flatland t)


(powerline-default-theme)
(setq powerline-color1 "gray30")
(setq powerline-color2 "gray45")
(set-face-attribute 'mode-line nil
                    :background "gray22"
                    :foreground "F0DFAF"
                    :box nil)


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-names-vector ["#212526" "#ff4b4b" "#b4fa70" "#fce94f" "#729fcf" "#ad7fa8" "#8cc4ff" "#eeeeec"])
 '(custom-safe-themes (quote ("86f4407f65d848ccdbbbf7384de75ba320d26ccecd719d50239f2c36bec18628" "4ea594ee0eb3e5741ab7c4b3eeb36066f795c61aeebad843d74f0a28a81a0352" "a3d519ee30c0aa4b45a277ae41c4fa1ae80e52f04098a2654979b1ab859ab0bf" "628278136f88aa1a151bb2d6c8a86bf2b7631fbea5f0f76cba2a0079cd910f7d" default)))
 '(ido-ignore-directories (quote ("\\`CVS/" "\\`\\.\\./" "\\`\\./" "\\'node_modules/"))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(put 'dired-find-alternate-file 'disabled nil)
