;; This program is an Interpreter for PLAN language which has the following grammar:

;; grammar for PLAN language:
;; program → ( prog expr )
;; expr → id
;; expr → const
;; expr → ( myignore expr )
;; expr → ( myadd expr expr )
;; expr → ( mymul expr expr )
;; expr → ( myneg expr )
;; expr → ( mylet id expr expr )
;; id →a|b| ... |z
;; const → integer


;; Contract: myinterpreter : (list a) -> (list b)
;; Purpose: interpreter for PLAN.
;; Example: (myinterpreter '((prog 5) (prog (mylet z (myadd 4 5) (mymul z 2)))) yields (5 18).
;; Definition:
(define (myinterpreter x)
  (cond ((null? x) `()) ;; base case
        ((cons (pv (car x) `()) (myinterpreter (cdr x)))) ;; shallow recursion
  )
)


;; Contract: pv : (list a) * (list b) -> (integer c)
;; Purpose: parses and evaluates a PLAN expression.
;; Example: (pv `(prog 5) `()) yields 5.
;; Definition: The two arguments are PLAN expression and current binding stack, respectively.
(define (pv x bind)
  (cond ((integer? x) x)  
        ((symbol? x) (fbind x bind))
        ((equal? (car x) `prog) (pv (cadr x) bind))
        ((equal? (car x) `myadd) (+ (pv (cadr x) bind) (pv (caddr x) bind)))
        ((equal? (car x) `mymul) (* (pv (cadr x) bind) (pv (caddr x) bind)))
        ((equal? (car x) `myneg) (* -1 (pv (cadr x) bind)))
        ((equal? (car x) `myignore) 0)
        ((equal? (car x) `mylet)
        (pv (cadddr x) (cons (cons (cadr x) (cons (pv (caddr x) bind) `())) bind))) ;; puts new binding to stack
  )
 )


;; Contract: fbind : (symbol a) * (list b) -> (integer c)
;; Purpose: finds the binding value for a given id.
;; Example: (fbind `a `((a 1) (b 2))) yields 1.
;; Definition: The two arguments are queried id and current binding stack.
(define (fbind id bind)
  (cond ((null? bind) '())
    ((equal? (caar bind) id) (cadar bind)) ;; recursively matchs id
        (else (fbind id (cdr bind)))
        )
)


;; test case 1)
(myinterpreter '(
 (prog 5)
 (prog (myadd (myadd 7 (myignore (mymul 4 5))) (mymul 2 5)))
 (prog (mylet z (myadd 4 5) (mymul z 2)))
 (prog (mylet a 66 (myadd (mylet b (mymul 2 4) (myadd 2 b)) (mymul 2 a))))
 (prog (mylet x 66 (myadd (mylet x (mymul 2 4) (myadd 2 x)) (mymul 2 x))))
))


;; test case 2)
(myinterpreter '(
   (prog 100)
   (prog (myadd 22 -10))
   (prog (mymul 9 78))
   (prog (myignore (mylet z 18 (myneg z))))  
   (prog (myneg (mymul 44 (myneg (myneg 55)))))
   (prog (myadd (myadd 1 (mymul 4 5)) (mymul (myadd 2 3) (myadd 2 (myignore (myadd 66 77))))))
   (prog (mylet a 10 (mylet a 15 (myneg (mylet b -10 (myadd a b))))))
   (prog (mylet a 12 (mylet b 13 (myadd (mylet c 10 (mymul a c)) b))))
   (prog (mylet z (myadd 3 8) (mylet a z (mymul (myignore (mylet z 14 z)) (myadd 77 100))) ))
   (prog (mylet z (myadd 3 8) (mylet a z (mymul (myneg (mylet z 14 z)) (myadd 77 100))) ))
   (prog (myadd (mylet x 10 (myadd (mylet x (mylet x (mymul 10 11) (myadd x 1)) (mymul 4 x)) 11)) (mylet x 2 (myadd (mylet x (mylet x (mymul 23 11) (myadd 1 x)) (mymul 2 x)) 3))))
   (prog (myadd (mylet x 11 (myadd (mylet y (mylet x (myignore x) (myadd x 90)) (myneg x)) (mylet z (mylet x 1 (mymul x 2)) (mymul x (mymul (mylet z 19 (mymul x z)) (myadd x x)))))) (myadd 5 4)))
   ))