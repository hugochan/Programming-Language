; map function f to corresponding elements of two lists and return list of values.
; (mapp + `(1 2) `(3 4)) yields `(4 6).
(define (mapp f xs ys)
  (cond ((null? xs) `())
        ((null? ys) `())
        (else (cons (f (car xs) (car ys)) (mapp f (cdr xs) (cdr ys))))
  )
)


; zip two lists into a list of tuples.
; (makepairs `(1 2 3) `(a b c)) yields ((1 a) (2 b) (3 c)).
(define (makepairs lis1 lis2)
  (mapp list lis1 lis2)
  )