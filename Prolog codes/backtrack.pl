p(I, [1 | S]) :- append([a | I1], [b | I2], I), p(I1, S1), p(I2, S2), append(S1, S2, S).
p(I, [2 | S]) :- append([b | I1], [a | I2], I), p(I1, S1), p(I2, S2), append(S1, S2, S).
p([], [3]).
