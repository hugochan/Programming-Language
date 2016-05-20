; (all_pairs `(1 2) `(3 4)) yields `((1 3) (1 4) (2 3) (2 4)).
(define (all_pairs xs ys)
  (cond ((null? xs) `())
        (else (append (single_pairs (car xs) ys)
                      (all_pairs (cdr xs) ys))))
  )

; (single_pairs `1 `(3 4)) yields `((1 3) (1 4)).
(define (single_pairs x ys)
  (cond ((null? ys) `())
        (else (cons (list x (car ys))
                    (single_pairs x (cdr ys)))
              )
        )
  )