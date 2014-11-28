;;; compilation-manager.el - profile management for emacs' compilation-mode.
;;; P.C. Shyamshankar <sykora@lucentbeing.com>

;;; Commentary:

(defgroup compilation-manager nil
  "Customization for `compilation-manager'."

  :group 'compilation)

(defcustom compilation-manager-profiles nil
  "Profile specifications for `compilation-manager'.

An alist of compilation profile names and definitions. Each profile is a plist
of:

- `:compile-command' :: The value of `compile-command'.
- `:default-directory' :: The value of `default-directory'.
- `:search-path' :: The value of `compilation-search-path'.
- `:interactive' :: Whether or not the compilation buffer is interactive."

  :type '(alist :key-type string
                :value-type (plist
                             :options (:compile-command
                                       :default-directory
                                       :interactive
                                       :search-path))))

(defvar compilation-arguments nil)

(defun compilation-manager-name-last-profile (name)
  "Saves the last executed compilation as the profile `NAME'

If called interactively, prompt for `NAME'. With one prefix argument, edit the
compilation command before naming. With two prefix arguments, edit the entire
profile before naming."
  (let ((profile `(:compile-command ,compile-command
                   :default-directory ,default-directory
                   :interactive ,(if compilation-arguments (nth 1 compilation-arguments) nil)
                   :search-path ,compilation-search-path)))
    (if compilation-manager-profiles
        (if (assoc name compilation-manager-profiles)
            (setcdr (assoc name compilation-manager-profiles) profile)
          (add-to-list 'compilation-manager-profiles `(,name . ,profile)))
      (set 'compilation-manager-profiles `((,name . ,profile))))))

(defun compilation-manager-run-profile (profile)
  "Runs the profile named `PROFILE'.

If called interactively, prompt for a profile from the list of profiles in
`compilation-manager-profiles'. With one prefix argument, edit the compilation
command before executing, keeping all other settings intact. With two prefix
arguments, edit the entire profile before execution.

While the effects of editing a profile are temporary, they can be made permanent
by calling `compilation-manager-name-last-profile' directly afterwards.")

(provide 'compilation-manager)
