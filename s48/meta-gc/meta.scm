;;; Copyright (c) 2012 Johan Ceuppens                                           
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

;; Copyright (C) Johan Ceuppens 2013
;;
;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 2 of the License, or
;; (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

(load "meta-gc.scm")

;; special REPL
;; You can add REPL functions such as ((make-meta) 'cons our-cons)
(define (make-meta)
  (let ((*applicants '()))
    
    (define (add-hook symbol fun)
      (set! *applicants (append *applicants (list (cons symbol fun)))))
    
    (define (search-applicants msgsymbol)
      (do ((l *applicants (cdr *applicants)))
	  ((cond ((null? l)
		  #f)
		 ((eq? (caar *applicants) msgsymbol)
		  (cdar *applicants))
		 ))))

    ;; dynamically bound f- function
    (define (post-applicants args)
      (if (procedure? f-)
	  (f- args)))
      
    (define (dispatch msg)
      (cond ((eq? msg 'add-hook) add-hook)
	    ((let ((f- (search-applicants msg)))
	       (if f-
		   post-applicants)))
	    (else (display "make-meta : message not understood : ")(display msg)(newline)
		)))
    
    dispatch))
