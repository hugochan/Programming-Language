link(g,h).
link(g,d).
link(e,d).
link(h,f).
link(e,f).
link(a,e).
link(a,b).
link(b,f).
link(b,c).
link(f,c).

go(X, X, [X]).
go(X, Y, [X|T]) :- link(X, Z), go(Z, Y, T).

