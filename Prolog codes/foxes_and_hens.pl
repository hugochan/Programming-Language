num(3, 3). % numbers of foxes and hens

link([A, B, 0], [D, E, 1]) :- D is A + 1, E is B.
link([A, B, 0], [D, E, 1]) :- D is A, E is B + 1.
link([A, B, 0], [D, E, 1]) :- D is A + 2, E is B. % back 2
link([A, B, 0], [D, E, 1]) :- D is A, E is B + 2.
link([A, B, 0], [D, E, 1]) :- D is A + 1, E is B + 1.

link([A, B, 1], [D, E, 0]) :- D is A - 2, E is B.
link([A, B, 1], [D, E, 0]) :- D is A, E is B - 2.
link([A, B, 1], [D, E, 0]) :- D is A - 1, E is B - 1.

invalid([F, _, _]) :- F < 0.
invalid([F, _, _]) :- F > 3.
invalid([_, H, _]) :- H < 0.
invalid([_, H, _]) :- H > 3.
invalid([_, _, B]) :- B < 0.
invalid([_, _, B]) :- B > 1.
invalid([F, H, _]) :- 3-F > 3-H, 3-H > 0.
invalid([F, H, _]) :- F > H, H > 0.

% requires([LF, LH, LB]) :- num(N, M), safe([LF, LH]), RF is N - LF, RH is M - LH, safe([RF, RH]), 0 @=< LF, LF @=< N, 0 @=< LH, LH @=< M, 0 @=< LB, LB @=< 1.

% safe([_, 0]).
% safe([F, H]) :- F @=< H.

go(Z, X, Y) :-
            link(Z,Y),
%            requires(Y),
            not(invalid(Y)),
            not(member(Y,X)).

sub_solve([0, 0, 0], _, []).
sub_solve(Z, X, [Y | T]) :- go(Z, X, Y), sub_solve(Y, [Y|X], T).

solve([[N,M,1] | T]) :- num(N, M), sub_solve([N,M,1], [[N,M,1]], T).
