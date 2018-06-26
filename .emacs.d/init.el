;;; init.el --- Initial settings for Emacs

;;; Commentary:
;;;   Copyright: Yuto Uchimi (2018)
;;;   This file should be placed at "$HOME/.emacs.d/init.el".
;;;   Please edit this so that you will have a happy hacking time.

;;; Code:

;; package archives
(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/") t)
(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))
(package-initialize)

;; automatically install packages
(defvar package-list
  '(
    auto-complete
    cmake-mode
    dockerfile-mode
    flycheck
    flycheck-popup-tip
    flycheck-pos-tip
    fuzzy
    golden-ratio
    hl-todo
    mozc
    rainbow-delimiters
    trr
    yaml-mode
    ))
(if (or (string= "24.4" emacs-version) (string< "24.4" emacs-version))
    (setq package-list (append package-list '(
                                              deferred
                                              epc
                                              jedi
                                              markdown-mode
                                              ))))
(unless package-archive-contents
  (package-refresh-contents))
(dolist (package package-list)
  (unless (package-installed-p package)
    (package-install package)))

;; package required from function (string-trim ...)
(if (or (string= "24.4" emacs-version) (string< "24.4" emacs-version))
    (require 'subr-x))

;; setting for Japanese
(require 'mozc)
(set-language-environment "Japanese")
(setq default-input-method "japanese-mozc")
(prefer-coding-system 'utf-8)

;; auto-complete
(require 'auto-complete-config)
(ac-config-default)
(add-to-list 'ac-modes 'cmake-mode)
(add-to-list 'ac-modes 'nxml-mode)
(add-to-list 'ac-modes 'shell-mode)
(setq ac-delay 0.02)  ;; time to auto-complete
(setq ac-auto-show-menu 0.05) ;; time to show menu

(require 'fuzzy)
(setq ac-use-fuzzy t)

;; auto complete for python
(if (package-installed-p 'jedi)
    (progn (require 'jedi)
           (add-hook 'python-mode-hook
                     '(lambda ()
                        (jedi:setup)
                        (setq jedi:complete-on-dot t)
                        (setq jedi:get-in-function-call-delay 50)
                        (jedi:install-server)
                        )))
  t)

;; trr
(require 'trr)
;(setq TRR:japanese t) ; this line is unnecessary?

;; flycheck
(require 'flycheck)
(add-hook 'after-init-hook #'global-flycheck-mode)
(add-hook 'python-mode-hook '(lambda ()
                               (flycheck-select-checker 'python-flake8)))

;; flycheck-cpplint
;; If roslint/cpplint exists, use that script
;; If not, use manually installed script
(if (file-exists-p "/usr/local/bin/flycheck-google-cpplint.el")
    (eval-after-load 'flycheck
      '(progn
         (load "/usr/local/bin/flycheck-google-cpplint.el")
         (defun enable-cpplint ()
           (flycheck-select-checker 'c/c++-googlelint))
         (add-hook 'c-mode-hook 'enable-cpplint)
         (add-hook 'c++-mode-hook 'enable-cpplint)
         (custom-set-variables
          '(flycheck-c/c++-googlelint-executable "/usr/local/bin/cpplint.py")
          '(flycheck-googlelint-verbose "0")
          '(flycheck-googlelint-filter "-whitespace,+whitespace/braces")
          '(flycheck-googlelint-linelength "80")
          ;; '(flycheck-googlelint-headers "hpp") ;; Not implemented in some cpplint version.
          '(flycheck-googlelint-extensions "c,cpp,h,hpp"))
         (let (f)
           (if (or (string= "24.4" emacs-version) (string< "24.4" emacs-version))
               (setq f (concat "/opt/ros/"
                               (string-trim (shell-command-to-string "rosversion -d"))
                               "/lib/roslint/cpplint"))
             (setq f "/opt/ros/indigo/lib/roslint/cpplint"))  ;; if emacs-version < 24.4
           (if (file-exists-p f)
               (custom-set-variables
                '(flycheck-c/c++-googlelint-executable f))
             t)
           )))
  t)

;; display flycheck errors
(eval-after-load 'flycheck
  (flycheck-pos-tip-mode))
(eval-after-load 'flycheck
  (flycheck-popup-tip-mode))

;; flyspell-mode
(mapc
 (lambda (hook)
   (add-hook hook 'flyspell-prog-mode))
 '(
   ;; enable flyspell-mode only in comment region
   ;; yatex-mode-hook
   ))
(mapc
   (lambda (hook)
     (add-hook hook '(lambda () (flyspell-mode 1))))
   '(
     ;; enable flyspell-mode
     ;; c-mode-common-hook
     ;; emacs-lisp-mode-hook
     ;; yatex-mode-hook
     ))

;; ignore start message
(setq inhibit-startup-message t)

;; set key bind for "C-h" as backspace
(global-set-key (kbd "C-h") 'delete-backward-char)

;; disable TAB
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)

;; settings for c/c++ mode
(add-hook 'c-mode-hook '(lambda () (setq c-basic-offset 2)))
(add-hook 'c++-mode-hook '(lambda () (setq c-basic-offset 2)))

;; colorize TAB, zennkaku space, whitespace at end of line
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

;; no display menu bar
(menu-bar-mode -1)

;; display line number
(global-linum-mode t)

;; display column number
(column-number-mode t)

;; colorize corresponding parenthesis
(show-paren-mode 1)

;; colorize corresponding parentheses (deeper)
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

;; golden ratio
;; (require 'golden-ratio)
;; (golden-ratio-mode 1)

;; scroll
(setq scroll-conservatively 1)
(setq scroll-margin 5)
(setq next-screen-context-lines 10)

;; disable to show cursor in non-selected windows
(setq cursor-in-non-selected-windows nil)

;; define key bind for jumping to line
(global-set-key "\C-xj" 'goto-line)

;; display current function name
(which-function-mode 1)

;; automatically open with selected mode
(require 'dockerfile-mode)
(setq auto-mode-alist
      (append '(
                ("CMakeLists\\.txt\\'" . cmake-mode)
                ("Dockerfile\\'" . dockerfile-mode)
                ("\\.bash_aliases\\'" . shell-script-mode)
                ("\\.cfg\\'" . python-mode)
                ("\\.cu\\'" . c++-mode)
                ("\\.md\\'" . markdown-mode)
                ("\\.launch\\'" . xml-mode)
                ("\\.rosinstall\\'" . yaml-mode)
                ("\\.test\\'" . xml-mode)
                ("\\.world\\'" . xml-mode)
                ("\\.ya?ml\\'" . yaml-mode)
                )
              auto-mode-alist))
(put 'upcase-region 'disabled nil)

;; rosemacs
(add-to-list 'load-path (concat "/opt/ros/"
                                (string-trim (shell-command-to-string "rosversion -d"))
                                "/share/emacs/site-lisp"))
(if (package-installed-p 'rosemacs-config)
    (require 'rosemacs-config))

;; backup files go into .~ directory now
(add-to-list 'backup-directory-alist (cons "." ".~"))

;; open png, jpg files as image
(setq auto-image-file-mode t)

;; highlight special keywords
(require 'hl-todo)
(global-hl-todo-mode)
(custom-set-faces
 '(hl-todo ((t (:foreground "#cc9393" :inverse-video t :weight bold)))))
(custom-set-variables
 '(hl-todo-keyword-faces
   (quote
    (("HOLD" . "#d0bf8f")
     ("TODO" . "#cc9393")
     ("NEXT" . "#dca3a3")
     ("THEM" . "#dc8cc3")
     ("PROG" . "#5f7f5f")
     ("OK" . "#7cb8bb")
     ("OKAY" . "#7cb8bb")
     ("DONT" . "#8c5353")
     ("FAIL" . "#8c5353")
     ("DONE" . "#7cb8bb")
     ("NOTE" . "#5f7f5f")
     ("KLUDGE" . "#d0bf8f")
     ("HACK" . "#d0bf8f")
     ("FIXME" . "#cc9393")
     ("XXX" . "#cc9393")
     ("XXXX" . "#cc9393")
     ("???" . "#cc9393")
     ("DEBUG" . "#dc8cc3")
     ("INFO" . "#5f7f5f")
     ("WARNING" . "#cc9393")
     ("ERROR" . "#8c5353")
     ("FATAL" . "#8c5353")))))

(provide 'init)
;;; init.el ends here
