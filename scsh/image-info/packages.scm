; Copyright (c) 2003 RT Happe <rthappe at web de>
; See the file COPYING distributed with the Scheme Untergrund Library

;;; refers to structures SRFI-9+ and KRIMS from sunterlib/s48/krims
;;;                      BYTIO             from sunterlib/s48/bytio
;;;                      SEQUENCE-LIB from sunterlib/s48/sequences

;; extracting w x h etc. from images
(define-structure image-info image-info-face
  (open bytio                           ; read-byte
        byte-vectors
        sequence-lib                    ; subsequence
        krims                           ; assert
        srfi-1                          ; fold-right
        srfi-9+
        srfi-23                         ; error
        scsh-level-0                    ; arithmetic-shift bitwise-and
        scheme)
  (files imxize))