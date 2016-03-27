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


; folds ('reduces') the elements of a list into one, from right-to-left
; (foldr append `((1 2) (3 4)) `()) yields (1 2 3 4).
(define (foldr op lis id)
		(if (null? lis) id
		    (op (car lis) (foldr op (cdr lis) id))
                    ))


; folds ('reduces') the elements of a list into one, from left-to-right
; (foldl append `((1 2) (3 4)) `(2)) yields (1 2 3 4).
(define (foldl op lis id) 
  (if (null? lis) id  
      (foldl op (cdr lis) (op id (car lis)))))


; returns the reverse of a list using foldl.
; (rev `(1 (2 3) 3)) yields (3 (2 3) 1).
(define (rev lis) (foldl (lambda (x y) (cons y x)) lis `()))


; returns the reverse of a list using foldr.
; (rev2 `(1 (2 3) 3)) yields (3 (2 3) 1).
; error
(define (rev2 lis) (foldr (lambda (x y) (append x (cons y `()))) lis `()))


; computes the length of the list using foldl.
; (len `(1 2 (3) 3)) yields 4.
(define (len lis)
  (if (null? lis) 0
    (foldl (lambda (x y) (+ 1 x)) (cdr lis) 1)
    )
  )
