;;; init-local.el --- 自定义的设置
;;; Commentary:
;;; code:
(fset 'my-kill-buffer
      [?\M-x ?k ?i ?l ?l ?- ?b ?u ?f ?f ?e ?r return return])
(fset 'my-save-all-buffers
      [?\M-x ?s ?a ?v ?e ?- ?s ?o ?m ?e ?- ?b ?u ?f ?f ?e ?r ?s return ?!])
(fset 'my-comment
      [?\M-m C-tab ?\C-e ?\M-\;])
(fset 'my-uncomment
      [?\M-m C-tab ?\C-e ?\M-\;])
(fset 'my-task-end
   [?\M-> ?\C-p tab ?\M-> ?\C-p tab ?\M->])
;;打开最近访问tabletable文件
(defvar recentf-list)
(defun my-recentf-open ()
  "Open recent files.  In ido style if applicable --lgfang."
  (interactive)
  (let* ((path-table (mapcar
                      (lambda (x) (cons (file-name-nondirectory x) x))
                      recentf-list))
         (file-list (mapcar (lambda (x) (file-name-nondirectory x))
                            recentf-list))
         (complete-fun (if (require 'ido nil t)
                           'ido-completing-read
                         'completing-read))
         (fname (funcall complete-fun "File Name: " file-list)))
    (find-file (cdr (assoc fname path-table)))))
;;重复一行
(defun duplicate-line ()
  "Duplicat line."
  (interactive)
  (save-excursion
    (let ((line-text (buffer-substring-no-properties
                      (line-beginning-position)
                      (line-end-position))))
      (move-end-of-line 1)
      (newline)
      (insert line-text))))
;;插入时间（不包括日期）
(defun insert-short-time ()
  "H:M:S."
  (interactive)
  (insert (format-time-string "%H:%M:%S " (current-time))))
;;插入日期
(defun insert-short-day ()
  "YYYY-mm-dd."
  (interactive)
  (insert (format-time-string "%Y-%m-%d" (current-time))))
;;快速标示类似isearch
(defvar smart-use-extended-syntax nil
  "If t the smart symbol functionality will consider extended syntax in finding matches, if such matches exist.")
(defvar smart-last-symbol-name ""
  "Contains the current symbol name.
This is only refreshed when `last-command' does not contain
either `smart-symbol-go-forward' or `smart-symbol-go-backward'")
(make-local-variable 'smart-use-extended-syntax)
(defvar smart-symbol-old-pt nil
  "Contains the location of the old point.")
(defun smart-symbol-goto (name direction)
  "Jumps to the next NAME in DIRECTION in the current buffer.
DIRECTION must be either `forward' or `backward'; no other option
is valid."
  ;; if `last-command' did not contain
  ;; `smart-symbol-go-forward/backward' then we assume it's a
  ;; brand-new command and we re-set the search term.
  (unless (memq last-command '(smart-symbol-go-forward
                               smart-symbol-go-backward))
    (setq smart-last-symbol-name name))
  (setq smart-symbol-old-pt (point))
  (message (format "%s scan for symbol \"%s\""
                   (capitalize (symbol-name direction))
                   smart-last-symbol-name))
  (unless (catch 'done
            (while (funcall (cond
                             ((eq direction 'forward) ; forward
                              'search-forward)
                             ((eq direction 'backward) ; backward
                              'search-backward)
                             (t (error "Invalid direction"))) ; all others
                            smart-last-symbol-name nil t)
              (unless (memq (syntax-ppss-context
                             (syntax-ppss (point))) '(string comment))
                (throw 'done t))))
    (goto-char smart-symbol-old-pt)))
(defun smart-symbol-go-forward ()
  "Jumps forward to the next symbol at point."
  (interactive)
  (smart-symbol-goto (smart-symbol-at-pt 'end) 'forward))
(defun smart-symbol-go-backward ()
  "Jumps backward to the previous symbol at point."
  (interactive)
  (smart-symbol-goto (smart-symbol-at-pt 'beginning) 'backward))
(defun smart-symbol-at-pt (&optional dir)
  "Return the symbol at point, move point to DIR(either `beginning' or `end').
If `smart-use-extended-syntax' is t then that symbol is returned
instead."
  (with-syntax-table (make-syntax-table)
    (if smart-use-extended-syntax
        (modify-syntax-entry ?. "w"))
    (modify-syntax-entry ?_ "w")
    (modify-syntax-entry ?- "w")
    ;; grab the word and return it
    (let ((word (thing-at-point 'word))
          (bounds (bounds-of-thing-at-point 'word)))
      (if word
          (progn
            (cond
             ((eq dir 'beginning) (goto-char (car bounds)))
             ((eq dir 'end) (goto-char (cdr bounds)))
             (t (error "Invalid direction")))
            word)
        (error "No symbol found")))))
(global-set-key (kbd "M-n") 'smart-symbol-go-forward)
(global-set-key (kbd "M-p") 'smart-symbol-go-backward)
(global-set-key (kbd "M-x") 'smex)
(global-set-key (kbd "M-w") 'whole-line-or-region-kill-ring-save)
(global-set-key (kbd "C-w") 'whole-line-or-region-kill-region)
(global-set-key (kbd "C-\+") 'mc/mark-next-like-this)
(global-set-key (kbd "M-<f12>") 'magit-status)
(define-key global-map [f1] 'my-recentf-open)
(define-key global-map [f2] 'my-save-all-buffers)
(define-key global-map [f5] 'call-last-kbd-macro)
(define-key global-map [f10] 'ido-switch-buffer)
(global-set-key (kbd "C-<f2>")  'org-pomodoro)
;;(global-set-key (kbd "C-<f1>")  'pop-global-mark);;返回上一次的光标位置
(global-set-key (kbd "C-<f1>")  'goto-last-change);;返回上一次的光标位置
(define-key global-map [f12] 'my-kill-buffer)
(define-key global-map (kbd "C-o") 'projectile-find-file)
(define-key global-map (kbd "C-'") 'duplicate-line)
(define-key global-map (kbd "C-\"") 'ace-jump-char-mode)
(define-key global-map (kbd "C-:") 'ace-jump-word-mode)
(define-key global-map (kbd "C-<up>") 'previous-buffer)
(define-key global-map (kbd "C-<down>") 'next-buffer)
(global-set-key [f9]  'bmkp-toggle-autonamed-bookmark-set/delete)
(global-set-key (kbd "<M-right>")  'bmkp-next-autonamed-bookmark-repeat)
(global-set-key (kbd "<M-left>")  'bmkp-previous-autonamed-bookmark-repeat)
(global-set-key (kbd "<C-left>")  'backward-sexp)
(global-set-key (kbd "<C-right>")  'forward-sexp)
(global-set-key (kbd "C-M-;")  'my-comment)
(global-set-key (kbd "C-M-'")  'my-uncomment)
(global-set-key (kbd "C-c t")  'insert-short-time)
(global-set-key (kbd "C-c d")  'insert-short-day)
(provide 'init-local)
;;; init-local.el ends here
