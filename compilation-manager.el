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

(provide 'compilation-manager)
