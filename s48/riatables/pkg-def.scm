(define-package "riatables"
  (0 2)
  ((install-lib-version (1 3 0)))
  (write-to-load-script
   `((config)
     (load ,(absolute-file-name "packages.scm"
                                (get-directory 'scheme #f)))))
  (install-file "README" 'doc)
  (install-file "NEWS" 'doc)
  (install-string (COPYING) "COPYING" 'doc)
  (install-file "scheme/packages.scm" 'scheme)
  (install-file "scheme/riatable.scm" 'scheme)
  (install-file "scheme/support.scm" 'scheme))
