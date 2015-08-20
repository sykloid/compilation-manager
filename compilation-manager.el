;;; compilation-manager.el --- profile management for emacs' compilation-mode.
;;; P.C. Shyamshankar <sykora@lucentbeing.com>

;;; Commentary:

;;; `compilation-manager' provides a set of utilities for managing repeated recompilations with
;;; emacs' built-in `compilation-mode'.
;;;
;;; The two entry-points to this library are `compilation-manager-name-last-profile' and
;;; `compilation-manager-run-profile'.

;;; Code:

(require 'compile)

(defgroup compilation-manager nil
  "Customization for `compilation-manager'."

  :group 'compilation)

(defvar compilation-manager-known-properties
  '(:compile-command
    :default-directory
    :interactive
    :search-path)
  "Known properites permitted in a compilation profile.")

(defcustom compilation-manager-profiles nil
  "Profile specifications for `compilation-manager'.

An alist of compilation profile names and definitions. Each profile is a plist
of:

- `:compile-command' :: The value of `compile-command'.
- `:default-directory' :: The value of `default-directory'.
- `:search-path' :: The value of `compilation-search-path'.
- `:interactive' :: Whether or not the compilation buffer is interactive."

  :type `(alist :key-type string
                :value-type (plist :options ,compilation-manager-known-properties)))

;;;###autoload
(defun compilation-manager-name-last-profile (name edit)
  "Saves the last executed compilation as the profile `NAME'

If called interactively, prompt for `NAME'. With one prefix argument, edit the
compilation command before naming. With two prefix arguments, edit the entire
profile before naming."
  (interactive "MProfile Name: \nP")
  (let ((profile `(:compile-command ,compile-command
                   :default-directory ,(or compilation-directory default-directory)
                   :interactive ,(if compilation-arguments (nth 1 compilation-arguments) nil)
                   :search-path ,compilation-search-path)))
    (cond
     ((equal edit '(4))
      (plist-put profile :compile-command (compilation-read-command (plist-get profile :compile-command))))
     ((equal edit '(16))
      (set 'profile (car (read-from-string (read-string "Edit Profile: " (prin1-to-string profile)))))))

    (if compilation-manager-profiles
        (if (assoc name compilation-manager-profiles)
            (setcdr (assoc name compilation-manager-profiles) profile)
          (add-to-list 'compilation-manager-profiles `(,name . ,profile)))
      (set 'compilation-manager-profiles `((,name . ,profile))))))

;;;###autoload
(defun compilation-manager-run-profile (profile edit)
  "Runs the profile named `PROFILE'.

If called interactively, prompt for a profile from the list of profiles in
`compilation-manager-profiles'. With one prefix argument, edit the compilation
command before executing, keeping all other settings intact. With two prefix
arguments, edit the entire profile before execution.

While the effects of editing a profile are temporary, they can be made permanent
by calling `compilation-manager-name-last-profile' directly afterwards."
  (interactive (list (cdr (assoc (completing-read "Profile: " compilation-manager-profiles)
                                 compilation-manager-profiles))
                     current-prefix-arg))

  (let ((profile (copy-tree profile)))
    (cond
     ((equal edit '(4))
      (plist-put profile :compile-command (compilation-read-command (plist-get profile :compile-command))))
     ((equal edit '(16))
      (set 'profile (car (read-from-string (read-string "Edit Profile: " (prin1-to-string profile)))))))

    (set 'compile-command (plist-get profile :compile-command))
    (set 'compilation-search-path (plist-get profile :search-path))

    (let ((default-directory (plist-get profile :default-directory)))
      (compile compile-command (plist-get profile :interactive)))))

(provide 'compilation-manager)
;;; compilation-manager.el ends here
