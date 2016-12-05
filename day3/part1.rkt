#lang racket

(define (get-lines filename)
  (sequence->list (in-lines (open-input-file filename #:mode 'text))))

(define (split-line line)
  (apply values (map string->number (string-split line))))

(define (possible-triangle? x y z)
  (and (> (+ x y) z)
       (> (+ y z) x)
       (> (+ z x) y)))

(define (solution lines)
  (let* ([possibles (filter (compose possible-triangle? split-line) lines)])
    (length possibles)))

(solution (get-lines "input.txt"))