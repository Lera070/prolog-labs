% Задача 4: Сортировка методом перестановок

naive_sort(List, Sorted) :-
    permutation(List, Sorted),
    is_sorted(Sorted), !.

is_sorted([]).
is_sorted([_]).
is_sorted([X, Y | T]) :- X =< Y, is_sorted([Y | T]).

smart_sort(List, Sorted) :-
    smart_perm(List, Sorted).

smart_perm([], []).
smart_perm(List, [X | RestSorted]) :-
    select(X, List, Rest),
    \+ (member(Y, Rest), Y < X),
    smart_perm(Rest, RestSorted).

% Задача 15: Минимальное число белых коней

board(N, Board) :-
    findall(X/Y, (between(1, N, X), between(1, N, Y)), Board).

% Использована структура d(Dx, Dy) вместо дробей
knight_move(X/Y, Nx/Ny) :-
    member(d(Dx, Dy),[d(1,2), d(2,1), d(-1,2), d(-2,1), d(1,-2), d(2,-1), d(-1,-2), d(-2,-1)]),
    Nx is X + Dx, Ny is Y + Dy.

covers(Knight, Target) :- Knight = Target.
covers(Knight, Target) :- knight_move(Knight, Target).

smart_knights(N, K, Knights) :-
    board(N, PosList),
    % Максимальное число коней для перебора - это площадь всей доски N*N
    MaxK is N * N,
    between(1, MaxK, K), 
    smart_search(K, PosList, PosList,[], Knights), !.

% Кони кончились, и список непокрытых клеток пуст
smart_search(0, _,[], Acc, Acc).
smart_search(K, Positions, Uncovered, Acc, Result) :-
    K > 0,
    length(Uncovered, L),
    L =< K * 9, 
    choose_one(P, Positions, RestPos),
    remove_covered(Uncovered, P, NewUncovered),
    K1 is K - 1,
    smart_search(K1, RestPos, NewUncovered, [P|Acc], Result).

choose_one(X,[X|Rest], Rest).
choose_one(X, [_|Rest], RestOut) :- choose_one(X, Rest, RestOut).

remove_covered([], _, []).
remove_covered([T|Rest], K, NewRest) :-
    covers(K, T), !, remove_covered(Rest, K, NewRest).
remove_covered([T|Rest], K, [T|NewRest]) :-
    remove_covered(Rest, K, NewRest).
