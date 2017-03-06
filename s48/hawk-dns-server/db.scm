
;;Copyright (c) 2015, Johan Ceuppens (goon)
;;All rights reserved.

;;Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

;;1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.

;;2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

;;3. Neither the name of the copyright holder nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.

;;THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

;; <---

(define (make-db)
	(let ((*db '())
	     ((*prime 1)))

	(define (add key value)
	  (let ((*hash (list (list key value))))
	  (nextprime)
	  (do ((i 0 (+ i 1)))
	    ((eq? i *prime)
	  	(set! *db (append *db *hash)))
	    (set! *db (append *db '(0 0))))
	  ))

	(define (lookup key)
	    (cadr (list-ref *db (key->hash key))))

	(define (key->hash key)
	  (let ((*hash 0))
	  (do ((i 0 (+ i 1)))
	    ((= i (string-length key))
	     *hash)
	    (set! *hash (+ *hash (char->ascii (string-ref key i)))))
	  	))

	(define (nextprime)
	  (set! *prime (getprime-rec *prime)))

	(define (getprime-rec prime)
	  (if (not (and (/ prime 2) (/ prime 3) (/ prime 5) (/ prime 7) (/ prime 10)))
	    (getpreime-rec (+ prime 1))))
	    
	(define (integer->ascii 

	(define (dispatch msg)
		(cond ((eq? msg 'add) add)
			((eq? msg 'lookup) lookup)
			(else (display "make-db : message not understood"))))

		dispatch))
