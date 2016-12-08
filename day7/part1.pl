
%% TOPLEVEL
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

%% I'm SURE there's some equivalent of (length (filter PREDICATE list)), but
%% I couldn't find it :-p
tls_count([], 0).
tls_count([H|T], Total) :-
    supports_tls(H),
    tls_count(T, Remaining),
    Total is 1 + Remaining.

tls_count([_|T], Total) :-
    tls_count(T, Total).

%% The meat. An X supports TLS when, after splitting the strings, we
%% find ABBA in a valid component.
supports_tls(X) :-
    split_string(X, "[]", "", Components),
    valid_tls_components(Components, outside, no_outer_abba).

%% We determine ABBA ability by two criteria, it's been found on any
%% "outside" component (not in square brackets), which is tracked by the third
%% free variable. If we get to the end and have found an outer ABBA, we're true.
valid_tls_components([], _, found_outer_abba).

%% Here, we're true if a head has ABBA. Then we're true if we remain true for the
%% rest of the string, but we set the third free variable to `found_outer_abba`
valid_tls_components([H|T], outside, _) :-
    has_abba(H),
    valid_tls_components(T, inside, found_outer_abba).

%% If not, call it a wash and check inside.
valid_tls_components([_|T], outside, OuterStatus) :-
    valid_tls_components(T, inside, OuterStatus).

%% If we're looking at an "inside" component, it may never, ever have ABBA
valid_tls_components([H|T], inside, O) :-
    \+ has_abba(H),
    valid_tls_components(T, outside, O).

%% Simple pattern matching on strings.
has_abba(Str):-
    string_chars(Str, Lst),
    abba_analysis(Lst).

abba_analysis([]):- fail.
abba_analysis([X,Y,Y,X|_]):-
    X \== Y.
abba_analysis([_|T]):-
    abba_analysis(T).
