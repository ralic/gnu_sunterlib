; Copyright (c) 2003 RT Happe <rthappe at web de>
; See the file COPYING distributed with the Scheme Untergrund Library

;;; sequence operations definABLE in terms of the elementary operations
;;; The procedures dispatch early on the specific sequence type but
;;; implement the ``generic behaviour.''

(define (sequence->list s . opts)
  (cond ((vector? s)
         (apply vector->list s opts))
        ((string? s)
         (apply string->list s opts))
        ((pair? s)
         (apply list-copy s opts))
        (else
         (apply contiguous-sequence->list s opts))))


(define (sequence-fill! s x . opts)
  (cond ((vector? s)
         (apply vector-fill! s x opts))
        ((string? s)
         (apply string-fill! s x opts))
        ((pair? s)
         (apply list-fill! s x opts))
        (else
         (apply contiguous-sequence-fill! s x opts))))


(define (sequence-tabulate! s start proc len)
  ((if (vector? s) vector-tabulate! sequence-tabulate!)
   s start proc len))


(define (subsequence s start end)
  (cond ((vector? s)
         (subvector s start end))
        ((string? s)
         (substring s start end))
        ((pair? s)
         (sublist s start end))
        (else (contiguous-subsequence s start end))))


(define (sequence-copy s . opts)
  (cond
   ((vector? s)
    (apply vector-copy s opts))
   ((string? s)
    (apply string-copy s opts))
   ((byte-vector? s)
    (apply contiguous-sequence-copy s opts))
   ((pair? s)
    (apply list-copy s opts))
   (else
    (apply contiguous-sequence-copy s opts))))


(define (sequence-copy! s1 start1 s0 . opts)
  (cond
   ((and (vector? s1) (vector? s0))
    (apply vector-copy! s1 start1 s0 opts))
   ((and (string? s1) (string? s0))
    (apply string-copy! s1 start1 s0 opts))
   (else
    (apply contiguous-sequence-copy! s1 start1 s0 opts))))


(define (sequence-append seq . seqs)
  (cond ((vector? seq)
         (apply vector-append seq seqs))
        ((string? seq)
         (apply string-append seq seqs))
        ((pair? seq)
         (apply append seq seqs))
        (else
         (apply contiguous-sequence-append seq seqs))))


(define (sequence-map proc s . opts)
  (cond ((vector? s)
         (apply vector-map proc s opts))
        ((string? s)
         (apply string-map proc s opts))
        ((and (pair? s) (null? opts))
         (map proc s))
        (else
         (apply contiguous-sequence-map proc s opts))))


(define (sequence-map-into! s1 proc s0 . opts)
  (cond ((and (vector? s1) (vector? s0))
         (apply vector-map-into! s1 proc s0 opts))
        ((and (pair? s1) (pair? s0) (null? opts))
         (map! (lambda (x y) (proc y)) s1 s0))
        (else
         (apply contiguous-sequence-map-into! s1 proc s0 opts))))


(define (sequence-for-each proc s . opts)
  (cond ((vector? s)
         (apply vector-for-each proc s opts))
        ((string? s)
         (apply string-for-each proc s opts))
        ((and (pair? s) (null? opts))
         (for-each proc s))
        (else
         (apply contiguous-sequence-for-each proc s opts))))


(define (sequence-fold kons nil s . opts)
  (cond ((vector? s)
         (apply vector-fold kons nil s opts))
        ((string? s)
         (apply string-fold kons nil s opts))
        ((and (pair? s) (null? opts))
         (fold kons nil s))
        (else
         (apply contiguous-sequence-fold kons nil s opts))))


(define (sequence-fold-right kons nil s . opts)
  (cond ((vector? s)
         (apply vector-fold-right kons nil s opts))
        ((string? s)
         (apply string-fold-right kons nil s opts))
        ((and (pair? s) (null? opts))
         (fold-right kons nil s))
        (else (apply contiguous-sequence-fold-right kons nil s opts))))


(define (sequence-null? s)
  (cond ((vector? s) (vector-null? s))
        ((string? s) (string-null? s))
        ((pair? s) (null? s))
        (else (contiguous-sequence-null? s))))


(define (sequence-any pred s . opts)
  (cond ((vector? s)
         (apply vector-any pred s opts))
        ((string? s)
         (apply string-any pred s opts))
        ((and (pair? s) (null? opts))
         (any pred s))
        (else (apply contiguous-sequence-any pred s opts))))


(define (sequence-every pred s . opts)
  (cond ((vector? s)
         (apply vector-every pred s opts))
        ((string? s)
         (apply string-every pred s opts))
        ((and (pair? s) (null? opts))
         (every pred s))
        (else (apply contiguous-sequence-every pred s opts))))


;; The following procedures take or accept >1 sequence argument.
;; Therefore we don't dispatch on the sequence type so that we
;; may support mixed sequences: (sequence-append (vector) "abc" '(anton))
(define sequence-append contiguous-sequence-append)
(define sequences-map contiguous-sequences-map)
(define sequences-map/maker contiguous-sequences-map/maker)
(define sequences-map-into! contiguous-sequences-map-into!)
(define sequences-for-each contiguous-sequences-for-each)
(define sequences-fold contiguous-sequences-fold)
(define sequences-fold-right contiguous-sequences-fold-right)
(define sequences-any contiguous-sequences-any)
(define sequences-every contiguous-sequences-every)
(define sequence= contiguous-sequence=)
(define sequences= contiguous-sequences=)
;; the MAKER parameter works only with general sequences
(define sequence-copy/maker contiguous-sequence-copy/maker)
(define sequence-map/maker contiguous-sequence-map/maker)

