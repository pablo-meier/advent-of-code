main() :-
    open("input.txt", read, Str),
    read_file(Str, Lines),
    close(Str),
    tls_count(Lines, X),
    print(X),
    nl.

read_file(Stream, X) :-
    read_string(Stream, _, L),
    split_string(L, "\n", "\s\t\n", X).

tls_count([], 0).
tls_count([H|T], Total) :-
    supports_tls(H),
    tls_count(T, Remaining),
    Total is 1 + Remaining.

tls_count([_|T], Total) :-
    tls_count(T, Total).


supports_tls(X) :-
    split_string(X, "[]", "", Components),
    valid_tls_components(Components, outside, no_outer_abba).


valid_tls_components([], _, found_outer_abba).

valid_tls_components([H|T], outside, _) :-
    has_abba(H),
    valid_tls_components(T, inside, found_outer_abba).

valid_tls_components([_|T], outside, OuterStatus) :-
    valid_tls_components(T, inside, OuterStatus).

valid_tls_components([H|T], inside, O) :-
    \+ has_abba(H),
    valid_tls_components(T, outside, O).


has_abba(Str):-
    string_chars(Str, Lst),
    abba_analysis(Lst).


abba_analysis([]):- fail.
abba_analysis([X,Y,Y,X|_]):-
    X \== Y.
abba_analysis([_|T]):-
    abba_analysis(T).
