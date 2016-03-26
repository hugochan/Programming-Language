; check if atom, note that `() is an atom here
(define (atom? x) (not (pair? x)))


; returns the length of a list
(define (len x)
  (cond ((null?  x)  0)  (else  (+ 1 (len (cdr  x))))))


; count the number of lists in a list
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
(define  (fun  x)
    (cond ((null? x) 0)
	((atom? x) 1)
            (else (+ (fun (car x))
                (fun (cdr x))))            
                   ))


; append two lists
(define (app  x  y)
	(cond ((null?  x)  y)
		   ((null?  y)  x)
		   (else 
    		(cons (car x) 
              (app (cdr x)  y)))))