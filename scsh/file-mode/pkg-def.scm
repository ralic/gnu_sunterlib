(define-package "file-mode"
  (0 1)
  ()
  (install-file "load.scm" 'base)
  (install-file "README" 'doc)
  (install-file "NEWS" 'doc)
  (install-string (COPYING) "COPYING" 'doc)
  (install-file "file-mode.scm" 'scheme))