#! /usr/local/bin/scsh \
-s
!#

;;; xpackages.scm
;;;
;;; Copyright (c) 2003 Anthony Carrico
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

(define header-message
  ";; This file was automatically generated by the sunterlib
;;  makefile, so do not edit it.
")

;;; (open <structure>*)
;;; (access <name>*)
;;; (begin <program>)
;;; (files <file-spec>*)
;;; (optimize <optimize-spec>*)
;;; (for-syntax <clause>*)
;;;
;;; File names in a files clause can be symbols, strings, or lists
;;; (Maclisp-style "namelists").  A ".scm" file type suffix is assumed.
;;; Symbols are converted to file names by converting to upper or lower
;;; case as appropriate for the host operating system.  A namelist is an
;;; operating-system-independent way to specify a file obtained from a
;;; subdirectory.  For example, the namelist "(rts record)" specifies the
;;; file "record.scm" in the "rts" subdirectory.

(define process-source
  (lambda (source)
    (let* ((leading-path
            (split-file-name (file-name-directory source)))
           (massage-file-spec
            (lambda (file-spec)
              (append
               leading-path
               (cond ((pair? file-spec)
                      file-spec)
                     ((string? file-spec)
                      (split-file-name file-spec))
                     ;; ISSUE: Is this ok?
                     ((symbol? file-spec)
                      (split-file-name (symbol->string file-spec)))
                     (else
                      (error "unrecognized file-spec" file-spec))))))
           (massage-clause
            (lambda (clause)
              (if (not (and (pair? clause) (eq? 'files (car clause))))
                  clause
                  (cons (car clause)
                        (map massage-file-spec (cdr clause)))))))
      (with-current-input-port
       (open-input-file source)
       (let loop ((form (read)))
         (cond ((eof-object? form)
                (values))
               ((pair? form)
                (write
                 (let ((op (car form))
                       (rest (cdr form)))
                   (case op
                     ((define-structure define-structures)
                      (if (pair? rest)
                          (let* ((interface (car rest))
                                 (clauses (cdr rest)))
                            (cons op
                                  (cons interface
                                        (map massage-clause clauses))))))
                     ((define-interface)
                      form)
                     ((define-syntax)
                      ;; ISSUE: what does define-syntax mean in the
                      ;; configuration language?
                      (error "unexpected form in packages" source form))
                     (else
                      (error "unexpected form in packages" source form)))))
                (newline)
                (newline)
                (loop (read)))
               (else
                (error "unexpected form in packages" source form))))))))

(define xpackages
  (lambda (target sources)
    (with-current-output-port
     (open-output-file target)
     (display header-message)
     (newline)
     (for-each process-source sources))))

(xpackages (car command-line-arguments)
           (cdr command-line-arguments))
