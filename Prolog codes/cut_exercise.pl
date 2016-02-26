% 1)
 rainy(seattle).
 rainy(rochester).
 cold(rochester).
 snowy(X) :- rainy(X), !, cold(X).
 snowy(troy).

 %2)
 %rainy(seattle) :- !.
 %rainy(rochester).
 %cold(rochester).
 %snowy(X) :- rainy(X), cold(X).
 %snowy(troy).

% 3)
% rainy(seattle).
% rainy(rochester).
% cold(rochester).
% snowy(X) :- !, rainy(X), cold(X).

% 4)
%rainy(seattle).
%rainy(rochester).
%cold(rochester).
%snowy(X) :- rainy(X), cold(X), !.
