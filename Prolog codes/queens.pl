my_not(X):- X, !, fail.     %same as not
my_not(_).
in(H,[H|_]).            %same as member
in(H,[_|T]):- in(H,T).

nums(H,H,[H]).
nums(L,H,[L|R]):- L<H, N is L+1, nums(N,H,R).

queen_no(2).
ranks(L):- queen_no(N), nums(1,N,L).
files(L):- queen_no(N), nums(1,N,L).
% ranks and files generate the x and y axes of the chess board. Both are lists of numbers up to the number of queens; that is, ranks(L) binds L to the list [1,2,3,…,#queens].

rank(R):- ranks(L), in(R,L).
% R is a rank on the board; selects a particular rank  R from the list of all ranks L.

file(F):- files(L), in(F,L).
% F is a file on the board; selects a particular file F from the list of all files L.

attacks((R,_),(R,_)).
attacks((_,F),(_,F)). %a Prolog tuple
attacks((R1,F1),(R2,F2)):-
                   diagonal((R1,F1),(R2,F2)).

diagonal((X,Y),(X,Y)). %degenerate case
diagonal((X1,Y1),(X2,Y2)):-N is Y2-Y1,D is X2-X1,
    Q is N/D, Q is 1 . %diagonal needs bound arguments!
diagonal((X1,Y1),(X2,Y2)):-N is Y2-Y1,D is X2-X1,
    Q is N/D, Q is -1 .


queens(P):- queen_no(N), length(P,N), placement(P), ok_place(P).

% test(A) :- queen_no(N), length(A, N), placement(A).
placement([]).
placement([(R,F)|P]):- placement(P), rank(R), file(F).


ok_place([]).
ok_place([(R,F)|P]):- no_attacks((R,F),P),ok_place(P).
% Checks that a queen at square (R,F) does not attack any square (rank,file pair) in list L; uses attacks predicate defined previously

no_attacks(_,[]).
no_attacks((R,F),[(R2,F2)|P]):- my_not(attacks((R,F),(R2,F2))), no_attacks((R,F),P).
