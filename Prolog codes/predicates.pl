member(A, [A | _]).
member(A, [ _ | C]) :- member(A, C).

append([], A, A).
append([A | B], C, [A | D]) :- append(B, C, D).

flatten([], []).
flatten([A | B], [[A] | C]) :- flatten(B, C).

last([_|Tail], Y) :- last(Tail, Y).
last([X], X).

% takes a list of integers and computes the sum of the integers.
sum([], 0).
sum([A | B], R) :- sum(B, R1), R is A + R1.

% integers are arbitrarily nested.
sum2([], 0).
sum2(A, A) :- integer(A).
sum2([A | B], R) :- sum2(A, R1), sum2(B, R2), R is R1 + R2.

% takes a list of integers and computes another list, where all integers are shifted +10.
plus10([], []).
plus10([A | B], [C | D]) :- C is A + 10, plus10(B, D).

% takes a list and computes the length of the list.
len([], 0).
len([_ | B], N) :- len(B, N1), N is N1 + 1.

% takes a list and computes the number of atoms in the list.
atoms([], 0).
atoms(A, 1):- atom(A). % built-in predicate atom(X) yields true if X is an atom.
atoms([A | B], R) :- atoms(A, R1), atoms(B, R2), R is R1 + R2.

% succeeds when X fails.
not(X):- X,!,fail.
not(_).


range(H, H, [H]).
range(L, H, [L | R]):- L < H, N is L + 1, range(N, H, R).
