% get all the vars having type T
% ?- get_var(int, [[x, int], [y, real], [x, int]], V)

get_var(_, [], []).
get_var(T, [[V|T]|Rest], [V|VRest]) :- get_var(T, Rest, VRest).
get_var(T, [_|Rest], VRest) :- get_var(T, Rest, VRest).
