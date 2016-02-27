% Representation of grammar. Nonterminals expr, term, term_tail,
% and factor_tail are represented as non(e,_), non(t,_), non(tt,_),
% and non(ft,_), respectively. Special nonterminal start is encoded
% as non(s,_).
% Terminals num, -, and * are represented by term(num,_), term(minus,_)
% and term(times,_). Special terminal term(eps,_) denotes the epsilon
% symbol.
%
% Productions are represented with prod(N,[H|T]) --- that is, arguments
% are the production index N and a list [H|T] where the head of the
% list H is the left-hand-side of the production, and the tail of
% the list T is the right-hand-side of the production. For example,
% production expr -> term term_tail is represented as
% prod(1,[non(e,_),non(t,_),non(tt,_)]).

prod(0,[non(s,_),non(e,_)]).
prod(1,[non(e,_),non(t,_),non(tt,_)]).
prod(2,[non(tt,_),term(minus,_),non(t,_),non(tt,_)]).
prod(3,[non(tt,_),term(eps,_)]).
prod(4,[non(t,_),term(num,_),non(ft,_)]).
prod(5,[non(ft,_),term(times,_),term(num,_),non(ft,_)]).
prod(6,[non(ft,_),term(eps,_)]).

% LL(1) Parsing table.
% predict(non(s,_),term(num,_),0) stands for "on start and num, predict
% production 0. start -> expr"
% predict(non(e,_),term(num,_),1) stands for "on nonterminal expr and
% terminal num, predict production 1. expr -> term term_tail".

% YOUR CODE HERE.
% Complete the LL(1) parsing table for the grammar.
predict(non(s,_),term(num,_),0).
predict(non(e,_),term(num,_),1).
predict(non(t,_),term(num,_),4).
predict(non(tt,_),term(minus,_),2).
predict(non(tt,_),term(eps,_),3).
predict(non(ft,_),term(minus,_),6).
predict(non(ft,_),term(times,_),5).
predict(non(ft,_),term(eps,_),6).


% sample inputs
input0([3,-,5]).
input1([3,-,5,*,7,-,18]).


% YOUR CODE HERE.
% Write transform(L,R): it takes input list L and transforms it into a
% list where terminals are represented with term(...). The transformed
% list will be computed in unbound variable R.
% E.g., transform([3,-,5],R).
% R = [term(num,3),term(minus,_),term(num,5)]
transform([],[]).
transform([H|T],[X|Y]) :- term_recog(H,X), transform(T, Y).

term_recog(-,term(minus,_)).
term_recog(*,term(times,_)).
term_recog(N,term(num,N)) :- number(N).

is_term(term(minus,_)).
is_term(term(times,_)).
is_term(term(num,_)).

% You will write parseLL(L,ProdSeq): it will take a transformed
% list R and will produce the production sequence applied by
% the predictive parser.
% E.g., transform([3,-,5],R),parseLL(R,ProdSeq).
% ProdSeq = [0, 1, 4, 6, 2, 4, 6, 3].
parseLL([H|T], [N|N1]) :- predict(non(s,_),H,N), attribute(N,[_|R]), parseLL2([H|T],N1,[R]).

parseLL2([], [], []).
parseLL2([H|T], [N|N1], [term(eps,_)|S2]) :- parseLL2([H|T],[N|N1],S2).
parseLL2([H|T], [N|N1], [S1|S2]) :- is_term(S1), match(S1,H), parseLL2(T,[N|N1],S2).
parseLL2([H|T], [N|N1], [S1|S2]) :- predict(S1,H,N), attribute(N,[_|R]), append(R,S2,S), parseLL2([H|T],N1,S).

match(S1,H) :- .

attribute(N,[H|R]) :- prod(N,[H|R]).

% Later, write parseAndSolve which augments parseLL with the
% computation of the expression value.
% E.g., transform([3,-,5],R),parseAndSolve(R,ProdSeq,V).
% ProdSeq = [0, 1, 4, 6, 2, 4, 6, 3],
% V = -2.
