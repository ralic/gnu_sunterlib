;;; This file is part of the Scheme Untergrund Library.

;;; Copyright (c) 2003 by Taylor Campbell
;;; For copyright information, see the file COPYING which comes with
;;; the distribution.

(define (procedure-hash proc)
  (debug-data-uid
   (template-debug-data
    (closure-template
     (loophole :closure proc)))))
