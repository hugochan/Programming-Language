%member(X, [X|_]) :- !.
%member(X,[_|T]) :- member(X,T).

%prime(X) :- X is 1.

%pc(X) :- member(X, [1,2,3,4,5,3,6,3]), prime(X).


natural(1).
natural(N) :- natural(M), N is M+1.


my_loop(N) :- natural(I),
    write(I), nl,         % loop body (nl prints a newline)
    I = N, !.
