(define-structure rt-modules rt-modules-interface

  (open scheme
	rt-modules-core)
  (for-syntax (open scheme
		    rt-modules-core))

  (begin
    (define-syntax lambda-interface
      (lambda (expr rename compare)
	(let ((%lambda (rename 'lambda))
	      (interface-name (cadr expr))
	      (body (cddr expr)))
	  `(,%lambda ,(interface-value-names interface-name) ,@body))))

    (define-syntax with-names-from-rt-structure
      (lambda (expr rename compare)
	(let ((%lambda (rename 'lambda))
	      (%let (rename 'let))
	      (%rt-structure-value (rename 'rt-structure-value))
	      (%rt-structure-binding (rename 'rt-structure-binding))
	      (rt-structure (cadr expr))
	      (interface-name (caddr expr))
	      (body (cdddr expr)))
 	  (let ((ivn (interface-value-names interface-name)))
	    `(,%let ((,%rt-structure-value ,rt-structure))
	       ((,%lambda ,ivn ,@body)
		,@(map (lambda (name)
			 `(,%rt-structure-binding ,%rt-structure-value ',name))
		       ivn)))))))))

(define-structure rt-modules-core rt-modules-core-interface
  (open scheme
	meta-types ; syntax-type
	interfaces ; for-each-declaration
	define-record-types
	records
	signals
	bindings
	packages
	packages-internal
	locations
	environments
	ensures-loaded
	package-commands-internal)
  (files rt-module))
