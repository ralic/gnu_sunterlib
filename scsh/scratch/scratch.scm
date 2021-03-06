;;; scratch.scm - a scheme utility library
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

;; ,open continuations
;;(define call-with-current-continuation call/cc)

;; inner syntax
;; test
;;  (list-generate-element a b c) generates an element with each call


(define (list-generate-element lst)
  (define (get-el return)
    (for-each
     (lambda (element)
       (set! return (call-with-current-continutation
                     (lambda (r)
                       (set! get-el r)
                       (return element)))))
     lst)
    (return 'end-generate))

  (define (gen)
    (call-with-current-continuation get-el))
  gen)

;; outer syntax
;; test
;; (list-gen a b c) gives an element of '(a b c) each call
(define-syntax list-gen
  (syntax-rules ()
    ((_ a ...)
     (list-generate-element (make-list a ...)))))


(define (vector-generate-element lst)
  (define (get-el return)
    (for-each
     (lambda (element)
       (set! return (call-with-current-continutation
                     (lambda (r)
                       (set! get-el r)
                       (return element)))))
     (vector->list lst))
    (return 'end-generate))

  (define (gen)
    (call-with-current-continuation get-el))
  gen)

(define-syntax vector-gen
  (syntax-rules ()
    ((_ a ...)
     (vector-generate-element (make-list a ...)))))

