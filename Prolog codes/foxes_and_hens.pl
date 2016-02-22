link([A, B, C], [D, E, F]) :- D is A + 1, E is B, F is C + 1.
link([A, B, C], [D, E, F]) :- D is A, E is B + 1, F is C + 1.
link([A, B, C], [D, E, F]) :- D is A - 2, E is B, F is C - 1.
link([A, B, C], [D, E, F]) :- D is A, E is B - 2, F is C - 1.
link([A, B, C], [D, E, F]) :- D is A - 1, E is B - 1, F is C - 1.

requires([LF, LH, LB]) :- LF @=< LH, 0 @=< LF, LF @=< 3, 0 @=< LH, LH @=< 3, 0 @=< LB, LB @=< 1. % right shore?

go(X, Y) :- link(X, Y), \+ member(Y, []), requires(Y). % use cut !

sub_solve([[0, 0, 0] | []]).
sub_solve([X | [Y, T]]) :- go(X, Y), sub_solve([Y | T]).

solve([[3, 3, 1] | [Y, T]]) :- go([3, 3, 1], Y), sub_solve([ Y | T]).


last([X], Y):-
        Y is X,
        write(X).

last([Y|Tail], Y):-
    last(Tail, Y).
