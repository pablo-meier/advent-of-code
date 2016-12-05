#lang racket

(define (get-lines filename)
  (sequence->list (in-lines (open-input-file filename #:mode 'text))))

(define (split-line line)
  (map string->number (string-split line)))

(define fst car)
(define snd cadr)
(define thd caddr)

(define (triangles-from-columns lines)
  (define (line-threefer lst accum)
    (cond [(empty? lst) (reverse accum)]
          [else (let ([fst-triple (fst lst)]
                      [snd-triple (snd lst)]
                      [thd-triple (thd lst)])
                  (line-threefer (drop lst 3) (list* (list (fst fst-triple)
                                                           (fst snd-triple)
                                                           (fst thd-triple))
                                                     (list (snd fst-triple)
                                                           (snd snd-triple)
                                                           (snd thd-triple))
                                                     (list (thd fst-triple)
                                                           (thd snd-triple)
                                                           (thd thd-triple))
                                                     accum)))]))
  (let ([as-triples (map split-line lines)])
    (line-threefer as-triples '())))
    

(define (possible-triangle? triple)
  (let ([x (fst triple)]
        [y (snd triple)]
        [z (thd triple)])
    (and (> (+ x y) z)
         (> (+ y z) x)
         (> (+ z x) y))))

(define (solution lines)
  (let* ([triangles (triangles-from-columns lines)]
         [possibles (filter possible-triangle? triangles)])
    (length possibles)))

(solution (get-lines "input.txt"))