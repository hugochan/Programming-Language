;; Computes the number of sub sequences we can get from list 2 which equals to list 1.
;; e.g.,  (subseqs `(a c) `(a a c a c)) yields 5.
(define subseqs
  (lambda (lis1 lis2)
    (cond ((null? lis1) 1)
          ((null? lis2) 0)
          ((equal? (car lis1) (car lis2))
           (+ (subseqs (cdr lis1) (cdr lis2))
              (subseqs lis1 (cdr lis2))))
          (else (subseqs lis1 (cdr lis2)))
          )
    )
  )