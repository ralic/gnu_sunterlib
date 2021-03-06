; Copyright (c) 2003 RT Happe <rthappe at web de>
; See the file COPYING distributed with the Scheme Untergrund Library

;;; generic sequence procedures -- no explicit dispatch on sequence type
;;;
;;; The code should work with the names of the elementary sequence
;;; operations bound to the umbrella procedures that dispatch on the
;;; sequence type, or to the specific procedures of a particular type,
;;;
;;; sequence->list
;;; sequence-fill!
;;; sequence-tabulate!
;;; subsequence
;;; sequence-copy
;;; sequence-copy!
;;; sequence-append
;;; sequence-map sequences-map sequences-map/maker
;;; sequence-map-into! sequences-map-into!
;;; sequence-for-each sequences-for-each
;;; sequence-fold sequences-fold
;;; sequence-fold-right sequence-fold-right
;;; sequence-null?
;;; sequence-any sequences-any
;;; sequence-every sequences-every
;;; sequence= sequences=

(define (id x) x)

;; seqs : nonempty proper list of sequences
;; compute min sequence-length [ for internal use ]
(define (sequences-length seqs)
  ;; we got the time, we got the space ...
  (apply min (map sequence-length seqs)))


(define (sequence->list s . opts)
  (let-optionals opts ((start 0) (end (sequence-length s)))
    (assert (<= 0 start end (sequence-length s))
            sequence->list)
    (let loop ((i end) (xs '()))
      (if (= i start) xs
          (loop (- i 1) (cons (sequence-ref s (- i 1)) xs))))))

;; unspecified return value as usual
(define (sequence-fill! s x . opts)
  (let-optionals opts ((start 0) (end (sequence-length s)))
    (assert (<= 0 start end (sequence-length s))
            sequence-fill!)
    (let loop ((i start))
      (if (< i end)
          (begin
            (sequence-set! s i x)
            (loop (+ i 1)))))))


(define (sequence-tabulate! s start proc len)
  (assert (<= 0 start (+ start len) (sequence-length s))
          sequence-tabulate!)
  (do ((i 0 (+ i 1)))
      ((= i len) s)
    (sequence-set! s (+ start i) (proc i))))



(define (sequence-copy/maker maker s . opts)
  (let-optionals opts ((start 0)
                       (end (sequence-length s)))
    (assert (<= 0 start end (sequence-length s))
            sequence-copy/maker)
    (let* ((len (- end start))
           (ss (maker len)))
      (do ((i 0 (+ i 1)))
          ((= i len) ss)
        (sequence-set! ss i (sequence-ref s (+ start i)))))))


(define (sequence-copy s . opts)
  (apply sequence-copy/maker
         (lambda (n) (make-another-sequence s n))
         s opts))


;; for internal use
(define (%sequence-copy! s1 start1 s0 start0 end0)
  (if (<= start1 start0)
      (do ((i0 start0 (+ i0 1))
           (i1 start1 (+ i1 1)))
          ((= i0 end0) (unspecific))
        (sequence-set! s1 i1 (sequence-ref s0 i0)))
      (let ((end1 (+ start1 (- end0 start0))))
        (do ((i0 (- end0 1) (- i0 1))
             (i1 (- end1 1) (- i1 1)))
            ((= i0 (- start0 1)) (unspecific))
          (sequence-set! s1 i1 (sequence-ref s0 i0))))))


(define (sequence-copy! s1 start1 s0 . opts)
  (let-optionals opts ((start0 0) (end0 (sequence-length s0)))
    (assert (<= 0 start0 end0 (sequence-length s0))
            sequence-copy!)
    (assert (<= 0 start1 (+ start1 (- end0 start0)) (sequence-length s1))
            sequence-copy!)
    (%sequence-copy! s1 start1 s0 start0 end0)
))

;; ...
(define (subsequence s start end)
  (sequence-copy s start end))


(define (sequence-fold kons nil s . opts)
  (let-optionals opts ((start 0)
                       (end (sequence-length s)))
    (assert (<= 0 start end (sequence-length s))
            sequence-fold)
    (let loop ((subtotal nil) (i start))
      (if (= i end) subtotal
          (loop (kons (sequence-ref s i) subtotal) (+ i 1))))))


(define (sequences-fold kons nil seq . seqs)
  (if (null? seqs)
      (sequence-fold kons nil seq)
      (let* ((ss (cons seq seqs))
             ;; are we morally obliged to use FOLD here?
             (end (sequences-length ss)))
        (let loop ((subtotal nil) (i 0))
          (if (= i end) subtotal
              (loop (apply kons (append! (map (lambda (s)
                                                (sequence-ref s i))
                                              ss)
                                         (list subtotal)))
                    (+ i 1)))))))


(define (sequence-fold-right kons nil s . opts)
  (let-optionals opts ((start 0)
                 (end (sequence-length s)))
    (assert (<= 0 start end (sequence-length s))
            sequence-fold-right)
    (let loop ((subtotal nil) (i end))
      (if (= i start) subtotal
          (loop (kons (sequence-ref s (- i 1)) subtotal) (- i 1))))))


(define (sequences-fold-right kons nil seq . seqs)
  (if (null? seqs)
      (sequence-fold-right kons nil seq)
      (let* ((ss (cons seq seqs))
             ;; are we morally obliged to use FOLD here?
             (end (sequences-length ss)))
        (let loop ((subtotal nil) (i (- end 1)))
          (if (= i -1) subtotal
              (loop (apply kons (append! (map (lambda (s)
                                                (sequence-ref s i))
                                              ss)
                                         (list subtotal)))
                    (- i 1)))))))


(define (sequence-append . seqs)
  (if (null? seqs) (vector)
      (let* ((len (apply + (map sequence-length seqs)))
             (res (make-another-sequence (car seqs) len)))
        (let loop ((ss seqs) (start 0))
          (if (null? ss) res
              (let* ((s (car ss)) (end (sequence-length s)))
                (do ((i 0 (+ i 1)))
                    ((= i end) (loop (cdr ss) (+ start end)))
                  (sequence-set! res (+ start i)
                                 (sequence-ref s i)))))))))


(define (sequence-for-each proc seq . opts)
  (let-optionals opts ((start 0) (end (sequence-length seq)))
    (assert (<= 0 start end (sequence-length seq))
            sequence-for-each)
    (do ((i start (+ i 1)))
        ((= i end) (unspecific))
      (proc (sequence-ref seq i)))))


(define (sequences-for-each proc seq . seqs)
  (let* ((ss (cons seq seqs))
         (end (sequences-length ss)))
    (do ((i 0 (+ i 1)))
        ((= i end) (unspecific))
      (apply proc (map (lambda (s) (sequence-ref s i)) ss)))))


(define (sequence-map/maker maker proc seq . opts)
  (let-optionals opts ((start 0)
                       (end (sequence-length seq)))
    (assert (<= 0 start end (sequence-length seq))
            sequence-map/maker)
    (let ((res (maker (- end start))))
      (do ((i start (+ i 1)))
          ((= i end) res)
        (sequence-set! res (- i start)
                       (proc (sequence-ref seq i)))))))


(define (sequence-map proc seq . opts)
  (apply sequence-map/maker
         (lambda (n) (make-another-sequence seq n))
         seq opts))


(define (sequences-map/maker maker proc seq . seqs)
  (let* ((ss (cons seq seqs))
         (end (sequences-length ss))
         (res (maker end)))
    (do ((i 0 (+ i 1)))
        ((= i end) res)
      (sequence-set! res i (apply proc (map (lambda (s) (sequence-ref s i))
                                            ss))))))


(define (sequences-map proc seq . seqs)
  (apply sequences-map/maker (lambda (n) (make-another-sequence seq n))
         proc seq seqs))


;; for internal use
(define (%sequence-map-into! s1 proc s0 start1 end1 start0)
  (if (<= start1 start0)
      (do ((i0 start0 (+ i0 1))
           (i1 start1 (+ i1 1)))
          ((= i1 end1) s1)
        (sequence-set! s1 i1 (proc (sequence-ref s0 i0))))
      (let ((end0 (+ start0 (- end1 start1))))
        (do ((i0 (- end0 1) (- i0 1))
             (i1 (- end1 1) (- i1 1)))
            ((= i0 (- start0 1)) s1)
          (sequence-set! s1 i1 (proc (sequence-ref s0 i0)))))))


(define (sequence-map-into! s1 proc s0 . opts)
  (let-optionals opts ((start1 0)
                       (end1 (sequence-length s1))
                       (start0 0))
    (assert (<= 0 start0 (sequence-length s0))
            sequence-map-into!)
    (assert (<= 0 start1 end1 (sequence-length s1))
            sequence-map-into!)
    (assert (<= (- end1 start1) (- (sequence-length s0) start0))
            sequence-map-into!)
    (%sequence-map-into! s1 proc s0 start1 end1 start0)))


(define (sequences-map-into! seq proc . seqs)
  (let ((end (sequence-length seq)))
    (do ((i 0 (+ i 1)))
        ((= i end) seq)
      (sequence-set! seq i (apply proc
                                  (map (lambda (s) (sequence-ref s i))
                                       seqs))))))


(define (sequence-null? s)
  (= (sequence-length s) 0))


(define (sequence-any foo? seq . opts)
  (let-optionals opts ((start 0) (end (sequence-length seq)))
    (assert (<= 0 start end (sequence-length seq))
            sequence-any)
    (let loop ((i start))
      (cond ((= i end) #f)
            ((foo? (sequence-ref seq i)) => id)
            (else (loop (+ i 1)))))))


(define (sequences-any foo? . seqs)
  (if (null? seqs) #f
      (let ((end (sequences-length seqs)))
        (let loop ((i 0))
          (cond ((= i end) #f)
                ((apply foo? (map (lambda (seq) (sequence-ref seq i))
                                  seqs))
                 => id)
                (else (loop (+ i 1))))))))


(define (sequence-every foo? seq . opts)
  (let-optionals opts ((start 0) (end (sequence-length seq)))
    (assert (<= 0 start end (sequence-length seq))
            sequence-every)
    (let loop ((i start) (res #t))
      (cond ((= i end) res)
            ((foo? (sequence-ref seq i))
             => (lambda (r) (loop (+ i 1) r)))
            (else #f)))))


(define (sequences-every foo? . seqs)
  (if (null? seqs) #t
      (let ((end (sequences-length seqs)))
        (let loop ((i 0))
          (cond ((= i end) #t)
                ((apply foo? (map (lambda (seq) (sequence-ref seq i))
                                  seqs))
                 (loop (+ i 1)))
                (else #f))))))


(define (sequence= elt= s0 s1 . opts)
  (let-optionals opts ((start0 0) (end0 (sequence-length s0))
                       (start1 0) (end1 (sequence-length s1)))
    (assert (<= start0 end0 (sequence-length s0)) sequence=)
    (assert (<= start1 end1 (sequence-length s1)) sequence=)
    (and (= (- end0 start0)
            (- end1 start1))
         (let loop ((i0 start0) (i1 start1))
           (cond ((= i0 end0) #t)
                 ((elt= (sequence-ref s0 i0)
                        (sequence-ref s1 i1))
                  (loop (+ i0 1) (+ i1 1)))
                 (else #f))))))


(define (sequences= elt= . seqs)
  (if (null? seqs) #t
      (let loop ((s (first seqs)) (ss (rest seqs)))
        (cond ((null? ss) #t)
              ((sequence= elt= s (first ss))
               (loop (first ss) (rest ss)))
              (else #f)))))
