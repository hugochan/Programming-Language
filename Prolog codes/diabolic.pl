% 4 * 4 magic squares

magic_no(4).

digtal(X) :- magic_no(N), End is N * N, range(1, End, R), member(X, R).


check_m([H | T], A, N) :- digtal(H), \+ member(H, A), append(A, [H], A2), N1 is N - 1, check_m(T, A2, N1).
check_m([], _, 0).

rst(R) :- magic_no(N), R is (N^3 + N)/2.

ok(L) :- sum(L, S), rst(S).

all_ok([]).
all_ok([H | T]) :- ok(H), all_ok(T).

sum([], 0).
sum([A | B], R) :- sum(B, R1), R is A + R1.

range(H, H, [H]).
range(L, H, [L | R]):- L < H, N is L + 1, range(N, H, R).

% given list, get cols
get_rows(L, Rows) :- flatten4(L, Rows).

% given rows, get cols
get_cols([[], [], [], []], []).
get_cols([[A | T1], [B | T2], [C | T3], [D | T4]], [[A, B, C, D] | T]) :-
            get_cols([T1, T2, T3, T4], T).

get_diags([X1, X2, X3, X4, X5, X6, X7, X8, X9, X10, X11, X12, X13, X14, X15, X16], Diag) :-
            Diag = [[X1, X6, X11, X16], [X2, X7, X12, X13], [X3, X8, X9, X14], [X4, X5, X10, X15],
            [X4, X7, X10, X13], [X3, X6, X9, X16], [X2, X5, X12, X15], [X1, X8, X11, X14]].


flatten4([], []).
flatten4([A1,A2,A3,A4 | B], [A | C]) :- A = [A1,A2,A3,A4], flatten4(B, C).

magic([1, 8, 10, 15, 14, 11, 5, 4, 7, 2, 16, 9, 12, 13, 3, 6]).

% convolution
transform([A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P], [A,D,H,E,B,C,G,F,N,O,K,J,M,P,L,I]).

% reflection center
transform([A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P], [M,N,O,P,I,J,K,L,E,F,G,H,A,B,C,D]).
transform([A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P], [D,C,B,A,H,G,F,E,L,K,J,I,P,O,N,M]).
transform([A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P], [P,L,H,D,O,K,G,C,N,J,F,B,M,I,E,A]).
transform([A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P], [A,E,I,M,B,F,J,N,C,G,K,O,D,H,L,P]).

% rotation center
transform([A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P], [M,I,E,A,N,J,F,B,O,K,G,C,P,L,H,D]).
transform([A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P], [P,O,N,M,L,K,J,I,H,G,F,E,D,C,B,A]).
transform([A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P], [D,H,L,P,C,G,K,O,B,F,J,N,A,E,I,M]).

% rotation rows
transform([A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P], [M,N,O,P,A,B,C,D,E,F,G,H,I,J,K,L]).

% rotation cols
transform([A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P], [D,A,B,C,H,E,F,G,L,I,J,K,P,M,N,O]).


write_all :- magic(Base), L = [Base|T], go_to_next([Base], T, [Base]).

go_to_next([], [], _).
go_to_next([H|T], [New|T1], S) :- transform(H, New), not(member(New, S)), write(New), nl, go_to_next([New|T], T1, [New | S]).

diabolic(L) :- var(L), magic(Base), L = [Base|T], go_to_next([Base], T, [Base]).

diabolic(L) :- not(var(L)), check_m(L, [], 16), get_rows(L, Rows), get_cols(Rows, Cols), get_diags(L, Diags), all_ok(Rows), all_ok(Cols), all_ok(Diags).



