;;; init-local.el --- magit
;;; Commentary:
;;; code:
(setq magit-save-some-buffers nil
      magit-process-popup-time 10
      magit-completing-read-function 'magit-ido-completing-read)

(defun magit-status-somedir ()
  (interactive)
  (let ((current-prefix-arg t))
    (magit-status default-directory)))

(global-set-key [(meta f12)] 'magit-status)
(global-set-key [(shift meta f12)] 'magit-status-somedir)


(defvar magit-status-mode-map)
(eval-after-load 'magit
  '(progn
     ;; Don't let magit-status mess up window configurations
     ;; http://whattheemacsd.com/setup-magit.el-01.html
     (defadvice magit-status (around magit-fullscreen activate)
       (window-configuration-to-register :magit-fullscreen)
       ad-do-it
       (delete-other-windows))

     (defun magit-quit-session ()
       "Restores the previous window configuration and kills the magit buffer"
       (interactive)
       (kill-buffer)
       (when (get-register :magit-fullscreen)
         (jump-to-register :magit-fullscreen)))

     (define-key magit-status-mode-map (kbd "q") 'magit-quit-session)))


(defconst *is-a-mac* (eq system-type 'darwin))
(when *is-a-mac*
  (add-hook 'magit-mode-hook (lambda () (local-unset-key [(meta h)]))))

;;----------------------------------------------------------------------------
;; gist fixes
;;----------------------------------------------------------------------------

;; If using a "password = !some command" in .gitconfig, we need to
;; run the specified command to find the actual value

(defadvice gh-config (after sanityinc/maybe-execute-bang (key) activate)
  "Pass."
  (when (and (string= key "password")
             (string-prefix-p "!" ad-return-value))
    (setq ad-return-value (shell-command-to-string (substring ad-return-value 1)))))

(provide 'init-magit)
;;; init-magit.el ends here
