;;; b-tree.scm - a B-tree for Xanadu
;;;
;;; Copyright (c) 2011-2012 Johan Ceuppens
;;;
;;; All rights reserved.
;;;
;;; Redistribution and use in source and binary forms, with or without
;;; modification, are permitted provided that the following conditions
;;; are met:
;;; 1. Redistributions of source code must retain the above copyright
;;;    notice, this list of conditions and the following disclaimer.
;;; 2. Redistributions in binary form must reproduce the above copyright
;;;    notice, this list of conditions and the following disclaimer in the
;;;    documentation and/or other materials provided with the distribution.
;;; 3. The name of the authors may not be used to endorse or promote products
;;;    derived from this software without specific prior written permission.
;;;
;;; THIS SOFTWARE IS PROVIDED BY THE AUTHORS ``AS IS'' AND ANY EXPRESS OR
;;; IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
;;; OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
;;; IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY DIRECT, INDIRECT,
;;; INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
;;; NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
;;; DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
;;; THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
;;; (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
;;; THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

(define (make-b-tree)
  (let ((*tree (make-vector 0)))

    (define (goto-left-node str i tree)
      (cond ((= (vector-length tree) i) (display "null node") (vector-set! tree i str))
            (else #f))) 

    (define (add-rec str tree)
      (do ((i 0 (+ i 1)))
	  ((eq? i (vector-length tree))
           (grow-up) 
        (let ((vi (vector-ref tree i)))
          (cond ((string<=? str vi)
                 0)
                ((string>=? str vi)
                 (grow-down))
               ((string=? str vi)
                (set! i (vector-length tree)))
               (else (display "never reached."))))
      ))
        
    (define (add str)
      (add-rec *tree))

    (define (dispatch msg)
      (cond ((eq? msg 'add) add)
            (else (display "b-tree : message not understood."))))
	dispatch))
