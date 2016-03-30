(define (lmax lis1 lis2)
  (if (> (length lis1) (length lis2)) lis1 lis2)
  )

(define (lcs_fast lis1 lis2)
  (cond ((null? lis1) `())
        ((null? lis2) `())
        (else (let (      ;; binding list for each of the three cases
                   (clis1 (if (equal? (car lis1) (car lis2)) (cons (car lis1) (lcs_fast (cdr lis1) (cdr lis2))) ;; case 1
                                (lcs_fast (cdr lis1) (cdr lis2)))) 
                    (clis2 (lcs_fast (cdr lis1) lis2)) ;; case 2
                    (clis3 (lcs_fast lis1 (cdr lis2)))) ;; case 3
              (lmax (lmax clis1 clis2) clis3) ;; returns the longest list among clis1, clis2 and clis3
               ))
        ))

(lcs_fast '(a b c b d a b) '(b d c a b a))