
main() :-
    open("input.txt", read, Str),
    read_file(Str, Lines),
    close(Str),
    ssl_count(Lines, X),
    print(X),
    nl.

read_file(Stream, X) :-
    read_string(Stream, _, L),
    split_string(L, "\n", "\s\t\n", X).

ssl_count([], 0).
ssl_count([H|T], Total) :-
    supports_ssl(H),
    ssl_count(T, Remaining),
    Total is 1 + Remaining.

ssl_count([_|T], Total) :-
    ssl_count(T, Total).


supports_ssl(X) :-
    split_string(X, "[]", "", Components),
    valid_ssl_components(Components, outside, Abas, Babs),
    aba_has_bab(Abas, Babs).


valid_ssl_components([], _, [], []).

valid_ssl_components([H|T], outside, Concatenated, Babs) :-
    abas_present(H, Abas),
    valid_ssl_components(T, inside, InitialAbas, Babs),
    append(InitialAbas, Abas, Concatenated).

valid_ssl_components([_|T], outside, Abas, Babs) :-
    valid_ssl_components(T, inside, Abas, Babs).

valid_ssl_components([H|T], inside, Abas, Concatenated) :-
    abas_present(H, Babs),
    valid_ssl_components(T, outside, Abas, InitialBabs),
    append(InitialBabs, Babs, Concatenated).


abas_present(Str, Results):-
    string_chars(Str, Lst),
    aba_analysis(Lst, Results).

aba_analysis([], []).
aba_analysis([X,Y,X|T], [[X,Y,X]|Rst]):-
    X \== Y,
    aba_analysis(T, Rst).

aba_analysis([_|T], Rst):-
    aba_analysis(T, Rst).


aba_has_bab([], _) :- fail.
aba_has_bab([[X,Y,X]|_], Babs):-
    member([Y,X,Y], Babs).
aba_has_bab([_|T], Babs):-
    aba_has_bab(T, Babs).
