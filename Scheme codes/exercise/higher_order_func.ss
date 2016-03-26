; helper
; check if atom, note that `() is an atom here.
; (atom? `a) yields #t.
(define (atom? x) (not (pair? x)))

; builds a new list by applying the f to each element of lis
; (mymap abs `(-1 -2 -3)) yields (1 2 3).
(define (mymap f lis) 
    (if (null? lis) `()
	    (cons (f (car lis)) (mymap f (cdr lis)))))

; returns the number of atoms in a list.
; (counta2 `(1 (2 (3)))) yields 3.
(define (counta2 s) 
    (cond ((null? s) 0)
      ((atom? s) 1)
          (else (apply + (map counta2 s)))))

; flattens a list
; (flatten2 `(1 (2 (3)))) yields (1 2 3)
(define (flatten2 lis)
    (cond ((null? lis) `())
          ((atom? lis) (cons lis `()))
          (else (apply append (map flatten2 lis)))
          )
  )

