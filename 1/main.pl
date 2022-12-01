:- use_module(library(pio)).
:- use_module(library(lists)).


lines([])           --> call(eos), !.
lines([Line|Lines]) --> line(Line), lines(Lines).

eos([], []).

line([])     --> ( "\n" ; call(eos) ), !.
line([L|Ls]) --> [L], line(Ls).

sums(List, Sums) :-
    sums(List, 0, [], Sums).
sums([], Sum, Accum, Result) :-
    reverse([Sum|Accum], Result).
sums([[]|Ls], Sum, Accum, Result) :-
    sums(Ls, 0,  [Sum|Accum], Result).
sums([L|Ls], Sum, Accum, Result) :-
    string_codes(L, String),
    number_string(Number, String),
    NewSum is Number + Sum,
    sums(Ls, NewSum, Accum, Result).

solve_part_1(Sums, Result) :-
    max_list(Sums, Result).

solve_part_2(Sums, Result) :-
    sort(Sums, Sorted),
    reverse(Sorted, Reversed),
    [First,Second,Third|_] = Reversed,
    sum_list([First,Second,Third], Result).

:-
    phrase_from_file(lines(Lines), 'data.txt'),
    sums(Lines, Sums),

    solve_part_1(Sums, Result1),
    writeln(Result1),

    solve_part_2(Sums, Result2),
    writeln(Result2),

    halt.
