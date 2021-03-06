;;; init.el --- 安装包的设置
;;; Commentary:
;;; code:
(add-to-list 'load-path (expand-file-name "~/.emacs.d/custom"))
(require 'package) ;; You might already have this line
(add-to-list 'package-archives
	     '("melpa" . "http://melpa.org/packages/"))
(package-initialize)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(bmkp-last-as-first-bookmark-file "~/.emacs.d/bookmarks")
 '(custom-enabled-themes (quote (sanityinc-solarized-dark)))
 '(custom-safe-themes
   (quote
    ("4aee8551b53a43a883cb0b7f3255d6859d766b6c5e14bcb01bed572fcbef4328" default)))
 '(magit-commit-arguments nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
;;打开最近文件
(require 'recentf)
(recentf-mode 1)
(setq recentf-max-menu-items 45)
(global-set-key (kbd "C-c C-r") 'recentf-open-files)
;; ido-yes-or-no
(ido-yes-or-no-mode 1)
;;自定义的选择
(global-set-key [(control tab)] 'set-mark-command)
;;显示行号
(global-linum-mode t)
;;(setq tab-width 2)
;;隐藏工具栏
(tool-bar-mode 0)
;;隐藏菜单栏
(menu-bar-mode 0)
;;隐藏侧边滑动栏
(scroll-bar-mode 0)
;;tab键替换为空格
(setq-default indent-tabs-mode nil)
;;winner-mode
(winner-mode 1)
;;去掉启动页面
(setq inhibit-startup-message t)
;;search下很容易查看occurs
(define-key isearch-mode-map (kbd "C-o") 'isearch-occur)
;;Lisp 窗口的自动提示
(require 'ac-slime)
(add-hook 'slime-mode-hook 'set-up-slime-ac)
(add-hook 'slime-repl-mode-hook 'set-up-slime-ac)
(eval-after-load "auto-complete"
  '(add-to-list 'ac-modes 'slime-repl-mode))
;;自动提示
(global-auto-complete-mode)
;;git项目模式

(projectile-global-mode 1)
;;dirtree
(autoload 'dirtree "dirtree" "Add directory to tree view" t)
;;语法检查
(global-flycheck-mode)
;;多处选择
(require 'multiple-cursors)

;;smex,命令栏显示交互
(require 'smex)
(smex-initialize)
(ido-mode t)
;;匹配输入括号等等

(require 'smartparens-config)
;;彩虹分隔符
(add-hook 'prog-mode-hook #'rainbow-delimiters-mode)
(smartparens-mode t)
;;自动匹配括号
 (require 'autopair)
(autopair-global-mode)
(show-paren-mode 1)
;;js-mode
(add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))
;;web-mode
(require 'web-mode)
(add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.blade.php\\'" . web-mode))
;;扩展选择

(require 'expand-region)
(global-set-key (kbd "C-=") 'er/expand-region)
;;yasnippet
(require 'yasnippet)
(yas-global-mode 1)
;;书签增强
(require 'bookmark+)
;;SliNav mode
(require 'elisp-slime-nav) ;; optional if installed via package.el
(dolist (hook '(emacs-lisp-mode-hook ielm-mode-hook))
  (add-hook hook 'turn-on-elisp-slime-nav-mode))
;;快速跳转
(autoload
  'ace-jump-mode
  "ace-jump-mode"
  "Emacs quick move minor mode"
  t)
;;窗口编号
(require 'window-numbering )
(window-numbering-mode 1)
;;选中区域覆盖重写
(cua-selection-mode t)
;;----------------------------------------------------------------------------
;; Zap *up* to char is a more sensible default
;;----------------------------------------------------------------------------
(autoload 'zap-up-to-char "misc" "Kill up to, but not including ARGth occurrence of CHAR.")
(global-set-key (kbd "M-z") 'zap-up-to-char)
(global-set-key (kbd "M-Z") 'zap-to-char)

;;alt up
(require 'move-text)
(move-text-default-bindings)
;;checkdoc mode
(add-hook 'emacs-lisp-mode-hook 'checkdoc-minor-mode)
;;eldoc
(add-hook 'emacs-lisp-mode-hook 'turn-on-eldoc-mode)
(add-hook 'lisp-interaction-mode-hook 'turn-on-eldoc-mode)
(add-hook 'ielm-mode-hook 'turn-on-eldoc-mode)
;;eldoc-eval
(autoload 'eldoc-in-minibuffer-mode "eldoc-eval")
(eldoc-in-minibuffer-mode 1)
;;ibuffer 分组 ibuffer-projectile
(defvar ibuffer-sorting-mode)
(add-hook 'ibuffer-hook
          (lambda ()
            (ibuffer-projectile-set-filter-groups)
            (unless (eq ibuffer-sorting-mode 'alphabetic)
              (ibuffer-do-sort-by-alphabetic))))
;;退出后保存状态
(autoload 'save-current-configuration "revive" "Save status" t)
(autoload 'resume "revive" "Resume Emacs" t)
(autoload 'wipe "revive" "Wipe Emacs" t)
(add-hook 'kill-emacs-hook 'save-current-configuration)
(add-hook 'emacs-startup-hook 'resume)
;;org
(defvar org-startup-indented)
(setq org-startup-indented t)  ;;缩进模式
(defvar org-todo-keywords)
(setq org-todo-keywords
      (quote ((sequence "TODO(t)" "STARTED(s)" "|" "DONE(d!/!)")
              (sequence "WAITING(w@/!)" "SOMEDAY(S)" "PROJECT(P@)" "|" "CANCELLED(c@/!)"))))
(defvar org-clock-in-switch-to-state)
(setq org-clock-in-switch-to-state "STARTED")

(require 'init-local)
;;; init.el ends here
