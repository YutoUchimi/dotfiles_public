;;; init.el --- Initial settings for Emacs

;;; Commentary:
;;;   Copyright: Yuto Uchimi (2018)
;;;   This file should be placed at "$HOME/.emacs.d/init.el".
;;;   Please edit this so that you will have a happy hacking time.

;;; Code:

;; Package archives
(require 'package)
(add-to-list 'package-archives
             '("marmalade" . "http://marmalade-repo.org/packages/"))
(add-to-list 'package-archives
             '("melpa" . "http://melpa.milkbox.net/packages/"))
(package-initialize)

;; Automatically install packages
(defvar package-list
  '(
    anzu
    auto-complete
    cmake-mode
    diminish
    dockerfile-mode
    fill-column-indicator
    flycheck
    flycheck-popup-tip
    flycheck-pos-tip
    fuzzy
    gitconfig-mode
    gitignore-mode
    hlinum
    ido-ubiquitous
    ido-vertical-mode
    matlab-mode
    mozc
    package-utils
    powerline
    rainbow-delimiters
    rainbow-mode
    smex
    trr
    yaml-mode
    yasnippet
    yasnippet-snippets
    ))
(when (version<= "24.4" emacs-version)
  (setq package-list
        (append package-list
                '(
                  deferred
                  epc
                  jedi
                  markdown-mode
                  ))))
(when (version<= "25" emacs-version)
  (setq package-list
        (append package-list
                '(
                  hl-todo
                  ))))
(unless package-archive-contents
  (package-refresh-contents))
(dolist (package package-list)
  (unless (package-installed-p package)
    (package-install package)))

;; Package required from function (string-trim ...)
(when (version<= "24.4" emacs-version)
  (require 'subr-x))

;; Setting for Japanese
(require 'mozc)
(set-language-environment "Japanese")
(setq default-input-method "japanese-mozc")
(prefer-coding-system 'utf-8)

;; Auto-complete
(require 'auto-complete-config)
(ac-config-default)
(add-to-list 'ac-modes 'cmake-mode)
(add-to-list 'ac-modes 'dockerfile-mode)
(add-to-list 'ac-modes 'markdown-mode)
(add-to-list 'ac-modes 'nxml-mode)
(add-to-list 'ac-modes 'shell-mode)
(setq ac-delay 0.02)  ;; time to auto-complete
(setq ac-auto-show-menu 0.05) ;; time to show menu

(require 'fuzzy)
(setq ac-use-fuzzy t)

;; Auto complete for python
(when (package-installed-p 'jedi)
  (require 'jedi)
  (add-hook 'python-mode-hook
            '(lambda ()
               (jedi:setup)
               (setq jedi:complete-on-dot t)
               ;; (setq jedi:get-in-function-call-delay 50)
               ;; (jedi:install-server)
               )))

;; TRR
(require 'trr)
;(setq TRR:japanese t) ; this line is unnecessary?

;; Flycheck
(require 'flycheck)
(add-hook 'after-init-hook #'global-flycheck-mode)
(add-hook 'python-mode-hook '(lambda ()
                               (flycheck-select-checker 'python-flake8)))

;; Flycheck-cpplint
;; If roslint/cpplint exists, use that script
;; If not, use manually installed script
(when (file-exists-p "~/.local/lib/flycheck-google-cpplint.el")
  (eval-after-load 'flycheck
    '(progn
       (load "~/.local/lib/flycheck-google-cpplint.el")
       (defun enable-cpplint ()
         (flycheck-select-checker 'c/c++-googlelint))
       (add-hook 'c-mode-hook 'enable-cpplint)
       (add-hook 'c++-mode-hook 'enable-cpplint)
       (custom-set-variables
        '(flycheck-c/c++-googlelint-executable "~/.local/bin/cpplint.py")
        '(flycheck-googlelint-verbose "0")
        '(flycheck-googlelint-filter "-whitespace,+whitespace/braces")
        '(flycheck-googlelint-linelength "80")
        ;; headers is not implemented in some cpplint version.
        ;; '(flycheck-googlelint-headers "hpp")
        '(flycheck-googlelint-extensions "c,cpp,h,hpp"))
       (defun select-ros-cpplint ()
         (if (version<= "24.4" emacs-version)
             (when (file-exists-p
                    (concat "/opt/ros/"
                            (string-trim
                             (shell-command-to-string "rosversion -d"))
                            "/lib/roslint/cpplint"))
               (custom-set-variables
                '(flycheck-c/c++-googlelint-executable
                  (concat "/opt/ros/"
                          (string-trim
                           (shell-command-to-string "rosversion -d"))
                          "/lib/roslint/cpplint"))
                '(flycheck-googlelint-linelength "120")))
           (when (file-exists-p "/opt/ros/indigo/lib/roslint/cpplint")
             (custom-set-variables
              '(flycheck-c/c++-googlelint-executable
                "/opt/ros/indigo/lib/roslint/cpplint")
              '(flycheck-googlelint-linelength "120")))
           ))
       (select-ros-cpplint)
       )))

;; Display flycheck errors
(eval-after-load 'flycheck
  (flycheck-pos-tip-mode))
(eval-after-load 'flycheck
  (flycheck-popup-tip-mode))

;; Flyspell-mode
(mapc
 (lambda (hook)
   (add-hook hook 'flyspell-prog-mode))
 '(
   ;; Enable flyspell-mode only in comment region
   ;; python-mode-hook
   ))
(mapc
   (lambda (hook)
     (add-hook hook '(lambda () (flyspell-mode 1))))
   '(
     ;; Enable flyspell-mode
     ;; c-mode-common-hook
     ;; emacs-lisp-mode-hook
     ;; yatex-mode-hook
     ))

;; YASnippet
(require 'yasnippet)
(define-key yas-minor-mode-map (kbd "C-x i i") 'yas-insert-snippet)
(define-key yas-minor-mode-map (kbd "C-x i n") 'yas-new-snippet)
(define-key yas-minor-mode-map (kbd "C-x i v") 'yas-visit-snippet-file)
(define-key yas-minor-mode-map (kbd "<tab>") nil)
(define-key yas-minor-mode-map (kbd "TAB") nil)
(define-key yas-minor-mode-map (kbd "<backtab>") 'yas-expand)
(yas-global-mode 1)

;; Fix for warnings in emacs25
(unless (boundp 'ido-cur-list)
  (setq-default ido-cur-item nil))
(unless (boundp 'ido-default-item)
  (setq-default ido-default-item nil))
(unless (boundp 'ido-cur-list)
  (setq-default ido-cur-list nil))
(unless (boundp 'predicate)
  (setq-default predicate nil))
(unless (boundp 'inherit-input-method)
  (setq-default inherit-input-method nil))

;; Settigs for IDO
(require 'ido)
(require 'ido-vertical-mode)
(require 'smex)
(ido-mode 1)
(ido-everywhere 1)
(setq ido-enable-flex-matching t)
(ido-ubiquitous-mode 1)
(ido-vertical-mode 1)
(global-set-key (kbd "M-x") 'smex)
(global-set-key (kbd "M-X") 'smex-major-mode-commands)

;; Theme
(when (package-installed-p 'color-theme)
  (require 'color-theme)
  (color-theme-initialize))
(load-theme 'manoj-dark t)

;; Ignore start message
(setq inhibit-startup-message t)
(setq inhibit-startup-screen t)
(setq inhibit-splash-screen t)

;; Share clipboard with system
(case system-type
  ('darwin
   (unless window-system
     (setq interprogram-cut-function
           (lambda (text &optional push)
             (let* ((process-connection-type nil)
                    (pbproxy
                     (start-process "pbcopy" "pbcopy" "/usr/bin/pbcopy")))
               (process-send-string pbproxy text)
               (process-send-eof pbproxy))))))
  ('gnu/linux
   (progn
     (setq-default x-select-enable-clipboard t)
     (defun xsel-cut-function (text &optional push)
       (with-temp-buffer
         (insert text)
         (call-process-region (point-min) (point-max)
                              "xsel" nil 0 nil "--clipboard" "--input")))
     (defun xsel-paste-function()
       (let ((xsel-output
              (shell-command-to-string "xsel --clipboard --output")))
         (unless (string= (car kill-ring) xsel-output)
           xsel-output)))
     (setq interprogram-cut-function 'xsel-cut-function)
     (setq interprogram-paste-function 'xsel-paste-function))))

;; Set key bind for "C-h" as backspace
(global-set-key (kbd "C-h") 'delete-backward-char)

;; Disable TAB for indent
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)

;; Settings for c/c++ mode
(add-hook 'c-mode-hook '(lambda () (setq c-basic-offset 2)))
(add-hook 'c++-mode-hook '(lambda () (setq c-basic-offset 2)))

;; Colorize TAB, zennkaku space, whitespace at end of line
(progn
  (require 'whitespace)
  (setq whitespace-style
        '(
          face
          trailing  ;; end of line
          tabs  ;; TAB
          spaces  ;; zennkaku space
          space-mark
          tab-mark
          ))
  (setq whitespace-display-mappings
        '(
          (space-mark ?\u3000 [?\u2423])
          (tab-mark ?\t [?\u00BB ?\t] [?\\ ?\t])
          ))
  (setq whitespace-trailing-regexp  "\\([ \u00A0]+\\)$")
  (setq whitespace-space-regexp "\\(\u3000+\\)")
  (set-face-attribute 'whitespace-trailing nil
                      :foreground "SkyBlue"
                      :background "SkyBlue"
                      :underline nil)
  (set-face-attribute 'whitespace-tab nil
                      :foreground "yellow"
                      :background "yellow"
                      :underline nil)
  (set-face-attribute 'whitespace-space nil
                      :foreground "gray60"
                      :background "gray60"
                      :underline nil)
  (global-whitespace-mode t)
  )

;; Show counts of matching pattern while searcing
(require 'anzu)
(global-anzu-mode 1)
(custom-set-variables
 '(anzu-mode-lighter "")
 '(anzu-deactivate-region t)
 '(anzu-search-threshold 1000))

;; Customize mode line
(require 'powerline)
(powerline-default-theme)
(custom-set-variables
 '(powerline-display-buffer-size nil)
 '(powerline-display-mule-info nil))
(custom-set-faces
 '(mode-line-buffer-id
   ((t (:background "color-25" :foreground "color-250" :weight bold
                    :height 0.9))))
 '(mode-line-buffer-id-inactive
   ((t (:background "color-18" :foreground "color-242" :weight bold
                    :height 0.9))))
 '(powerline-active0
   ((t (:inherit mode-line :foreground "color-20" :weight bold))))
 '(powerline-active2
   ((t (:inherit mode-line :background "green" :foreground "black")))))

;; No display menu bar
(menu-bar-mode -1)

;; Display line number
(if (version<= "24.4" emacs-version)
    (progn
      (require 'hlinum)
      (if (version<= "26.0.50" emacs-version)
          (global-display-line-numbers-mode)
        (global-linum-mode t))
      (hlinum-activate)
      (custom-set-faces
       '(linum-highlight-face ((t (:foreground "black"
                                   :background "red"))))))
  (global-linum-mode t))

;; Display column number
(column-number-mode t)

;; Show fill-column
(if (version<= "25" emacs-version)
    (progn
      (require 'fill-column-indicator)
      (setq-default fci-rule-column 80)
      (setq-default fci-rule-color "gray")
      (let ((fci-mode-list
             '(
               c-mode-hook
               c++-mode-hook
               cmake-mode-hook
               dockerfile-mode-hook
               emacs-lisp-mode-hook
               lisp-mode-hook
               markdown-mode-hook
               nxml-mode-hook
               python-mode-hook
               rst-mode-hook
               sh-mode-hook
               yaml-mode-hook
               )))
        (dolist (fci-mode- fci-mode-list)
          (cond
           ;; python-mode => max column: 79
           ((eq fci-mode- 'python-mode-hook)
            (add-hook fci-mode-
                      '(lambda () (setq-default fci-rule-column 79))))
           ;; c++-mode for ROS => max column: 120
           ((and (eq fci-mode- 'c++-mode-hook)
                 (file-exists-p
                  (if (version<= "24.4" emacs-version)
                      (concat
                       "/opt/ros/"
                       (string-trim (shell-command-to-string "rosversion -d"))
                       "/lib/roslint/cpplint")
                    "/opt/ros/indigo/lib/roslint/cpplint")))
            (add-hook fci-mode-
                      '(lambda () (setq-default fci-rule-column 120))))
           )
          (add-hook fci-mode-
                    '(lambda ()
                       (fci-mode)
                       (turn-on-fci-mode))))
        ))
  t)

;; Show end of buffer
(setq-default indicate-empty-lines t)

;; No more saving backup files
(setq make-backup-files nil)
(setq auto-save-default nil)

;; Highlight current line
(global-hl-line-mode t)
(custom-set-faces
 '(hl-line ((t (:background "gray10")))))

;; Colorize corresponding parenthesis
(show-paren-mode 1)

;; Colorize corresponding parentheses (deeper)
(require 'rainbow-delimiters)
(add-hook 'prog-mode-hook #'rainbow-delimiters-mode)
(custom-set-faces
 '(rainbow-delimiters-depth-1-face ((t (:foreground "white" :weight bold))))
 '(rainbow-delimiters-depth-2-face ((t (:foreground "blue" :weight bold))))
 '(rainbow-delimiters-depth-3-face ((t (:foreground "red" :weight bold))))
 '(rainbow-delimiters-depth-4-face ((t (:foreground "yellow" :weight bold))))
 '(rainbow-delimiters-depth-5-face ((t (:foreground "white" :weight bold))))
 '(rainbow-delimiters-depth-6-face ((t (:foreground "blue" :weight bold))))
 '(rainbow-delimiters-depth-7-face ((t (:foreground "red" :weight bold))))
 '(rainbow-delimiters-depth-8-face ((t (:foreground "yellow" :weight bold))))
 '(rainbow-delimiters-depth-9-face ((t (:foreground "white" :weight bold))))
 '(rainbow-delimiters-mismatched-face
   ((t (:foreground "yellow" :inverse-video t :weight bold))))
 '(rainbow-delimiters-unmatched-face
   ((t (:foreground "yellow" :inverse-video t :weight bold))))
 )

;; Colorize color name
(require 'rainbow-mode)
(setq rainbow-ansi-colors t)
(setq rainbow-html-colors t)
(setq rainbow-latex-colors t)
(setq rainbow-x-colors t)
(add-hook 'css-mode-hook 'rainbow-mode)
(add-hook 'emacs-lisp-mode-hook 'rainbow-mode)
(add-hook 'html-mode-hook 'rainbow-mode)
(add-hook 'less-mode-hook 'rainbow-mode)
(add-hook 'php-mode-hook 'rainbow-mode)
(add-hook 'scss-mode-hook 'rainbow-mode)
(add-hook 'web-mode-hook 'rainbow-mode)

;; Automatically reload buffer
(global-auto-revert-mode t)

;; Distinct same-name files
(require 'uniquify)
(setq uniquify-buffer-name-style 'post-forward-angle-brackets)

;; Scroll
(setq scroll-conservatively 1)
(setq scroll-margin 5)
(setq next-screen-context-lines 10)
(setq mouse-wheel-scroll-amount '(1 ((shift) . 5)))
(setq mouse-wheel-progressive-speed nil)

;; Disable to show cursor in non-selected windows
(setq cursor-in-non-selected-windows nil)

;; Define key bind for jumping to line
(global-set-key "\C-xj" 'goto-line)

;; Display current function name
(which-function-mode 0)

;; Automatically open with selected mode
(require 'dockerfile-mode)
(setq auto-mode-alist
      (append '(
                ("CMakeLists\\.txt\\'" . cmake-mode)
                ("Dockerfile\\'" . dockerfile-mode)
                ("\\.bash_aliases\\'" . sh-mode)
                ("\\.cfg\\'" . python-mode)
                ("\\.cu\\'" . c++-mode)
                ("\\.h\\'" . c++-mode)
                ("\\.ino\\'" . c-mode)
                ("\\.md\\'" . markdown-mode)
                ("\\.launch\\'" . nxml-mode)
                ("\\.rosinstall\\'" . yaml-mode)
                ("\\.test\\'" . nxml-mode)
                ("\\.world\\'" . nxml-mode)
                ("\\.ya?ml\\'" . yaml-mode)
                )
              auto-mode-alist))
(put 'upcase-region 'disabled nil)

;; ROSemacs
(add-to-list 'load-path
             (concat "/opt/ros/"
                     (string-trim (shell-command-to-string "rosversion -d"))
                     "/share/emacs/site-lisp"))
(if (file-exists-p (concat (car load-path) "/rosemacs-config.el"))
    (require 'rosemacs-config))

;; Open png, jpg files as image (disabled when emacs -nw)
(setq auto-image-file-mode t)

;; Highlight special keywords
(when (package-installed-p 'hl-todo)
  (require 'hl-todo)
  (global-hl-todo-mode)
  (custom-set-faces
   '(hl-todo ((t (:inverse-video t :weight bold)))))
  (custom-set-variables
   '(hl-todo-keyword-faces
     (quote
      (("HOLD" . "#f0f030")
       ("TODO" . "#f0f030")
       ("NEXT" . "#f0f030")
       ("THEM" . "#d080c0")
       ("PROG" . "#90d000")
       ("OK" . "#70d0e0")
       ("OKAY" . "#70d0e0")
       ("OKEY" . "#70d0e0")
       ("DONT" . "#f00000")
       ("FAIL" . "#f00000")
       ("DONE" . "#70d0e0")
       ("NOTE" . "#90d000")
       ("DEPRECATED" . "#f0f030")
       ("DEPRECATION" . "#f0f030")
       ("KLUDGE" . "#f0f030")
       ("HACK" . "#f0f030")
       ("FIXME" . "#f0f030")
       ("XXX" . "#f0f030")
       ("XXXX" . "#f0f030")
       ("???" . "#f0f030")
       ("DEBUG" . "#d080c0")
       ("INFO" . "#90d000")
       ("WARNING" . "#f0f030")
       ("ERROR" . "#f00000")
       ("FATAL" . "#f00000"))))))

;; Don't show some mode name in mode line
(require 'diminish)
(diminish 'auto-complete-mode)
(diminish 'eldoc-mode)
(diminish 'global-whitespace-mode)
(diminish 'rainbow-mode)
(diminish 'yas-minor-mode)

(provide 'init)
;;; init.el ends here
