; (all_pairs2 `(1 2) `(3 4)) yields `((1 3) (1 4) (2 3) (2 4)).

(define (all_pairs2 xs ys)
  (foldr (lambda (x1 y1)
           (append
            (foldr (lambda (x2 y2)
                     (append (list (list x1 x2)) y2))
                     ys
                     `()) y1))
                   xs
                   `()))


; folds ('reduces') the elements of a list into one, from right-to-left
; (foldr append `((1 2) (3 4)) `()) yields (1 2 3 4).
(define (foldr op lis id)
		(if (null? lis) id
		    (op (car lis) (foldr op (cdr lis) id))
                    ))