%bintree(1, bintree(2, bintree(3, null, null), bintree(4, null, null)), bintree(5, null, null)).


walk(null, [null]).
% walk(bintree(H, L, R), [H|T]) :- walk(L, T1), walk(R, T2), append(T1, T2, T). % pre-order
% walk(bintree(H, L, R), T) :- walk(L, T1), walk(R, T2), append(T1, [H], TT), append(TT, T2, T). % in-order
walk(bintree(H, L, R), T) :- walk(L, T1), walk(R, T2), append(T1, T2, TT), append(TT, [H], T). % post-order
