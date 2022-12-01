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

solve_part_1(Result) :-
    phrase_from_file(lines(Lines), 'data.txt'),
    sums(Lines, Sums),
    max_list(Sums, Result).

solve_part_2(Result) :-
    phrase_from_file(lines(Lines), 'data.txt'),
    sums(Lines, Sums),
    sort(Sums, Sorted),
    reverse(Sorted, Reversed),
    [First,Second,Third|_] = Reversed,
    sum_list([First,Second,Third], Result).

:-
  solve_part_1(Result1),
  write(Result1),
  write(' '),
  solve_part_2(Result2),
  write(Result2),
  halt.
