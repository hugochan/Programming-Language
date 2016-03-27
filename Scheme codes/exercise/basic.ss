; check if atom, note that `() is an atom here.
; (atom? `a) yields #t.
(define (atom? x) (not (pair? x)))


; returns the length of a list.
; (len `(1  (2 3))) yields 2.
(define (len x)
  (cond ((null?  x)  0)  (else  (+ 1 (len (cdr  x))))))


; count the number of lists in a list.
; (count `(1 (2 3) (3))) yields 2.
(define (count lis)
    (cond ((null? lis) 0)
        (else
            (if (list? (car lis))
                (+ 1 (count (cdr lis)))
                    (count (cdr lis))
            )
        )
    )
)


; returns num of atoms in a list
; (counta `(1 (2 (3)))) yields 3.
(define  (counta  x)
    (cond ((null? x) 0)
	((atom? x) 1)
            (else (+ (counta (car x))
                (counta (cdr x))))            
                   ))


; append two lists
; (app `(5  9) `(a  (4)  6)) yields (5 9 a (4) 6)
(define (app  x  y)
	(cond ((null?  x)  y)
		   ((null?  y)  x)
		   (else 
    		(cons (car x) 
              (app (cdr x)  y)))))

; flattens a list
; (flatten `(1 (2 (3)))) yields (1 2 3)
(define (flatten x)
        (cond ((null? x) `())
              ((atom? x) (cons x `()))
              (else
               (append (flatten (car x))
                     (flatten (cdr x)))
              )
  ))


; equality testing, value model.
; (eql? `(1 (2 (3))) `(1 (2 ((3))))) yields #f.
(define (eql?  x  y)
	(or    (and (atom?  x) (atom? y) (eq?  x  y))
		      (and  (not (atom? x)) (not (atom? y))
			     (eql?  (car x)  (car y))
			     (eql?  (cdr x)  (cdr y)) )))
