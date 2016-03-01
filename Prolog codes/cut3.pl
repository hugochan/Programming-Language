 rainy(seattle).
 rainy(rochester).
 cold(rochester).
 %cold(seattle).
 snowy(X) :- !, rainy(X), cold(X).
 snowy(troy).
