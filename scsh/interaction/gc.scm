(define (collect port)
  (let ((before (memory-status (enum memory-status-option available) #f)))
    (primitive-collect)
    (let ((after (memory-status (enum memory-status-option available) #f)))
      (display "Before: " port)
      (write before port)
      (display " words free in semispace" port)
      (newline port)
      (display "After:  " port)
      (write after port)
      (display " words free in semispace" port)
      (newline port))))

(define (gc-count)
  (memory-status (enum memory-status-option gc-count) #f))
