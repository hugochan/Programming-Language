%bintree(1, bintree(2, bintree(3, null, null), bintree(4, null, null)), bintree(5, null, null)).

walk(null, [null]).
walk(Tree, T) :- parse(Tree, H, L, R), walk(L, T1), walk(R, T2), append(T1, [H], TT), append(TT, T2, T).

parse(bintree(H, L, R), H, L, R).
