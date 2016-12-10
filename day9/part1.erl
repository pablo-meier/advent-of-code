-module(part1).
-export([main/0]).

get_line(Filename) ->
    {ok, Device} = file:open(Filename, [read]),
    try read_lines(Device)
    after file:close(Device)
    end.

read_lines(Device) ->
    case io:get_line(Device, "") of
        eof -> [];
        Line -> Line ++ read_lines(Device)
    end.

strip_whitespace(Line) -> re:replace(Line, "(^\\s+)|(\\s+$)", "", [global,{return,list}]).

parse_marker(T) ->
    parse_marker_recur(T, [], [], left).

parse_marker_recur([$x|T], LengthAccum, [], left) ->
    parse_marker_recur(T, LengthAccum, [], right);

parse_marker_recur([$)|T], LengthAccum, RepeatsAccum, right) ->
    {Size, _} = string:to_integer(lists:reverse(LengthAccum)),
    {Repeats, _} = string:to_integer(lists:reverse(RepeatsAccum)),
    {Size, Repeats, T};

parse_marker_recur([H|T], LengthAccum, [], left) ->
    parse_marker_recur(T, [H|LengthAccum], [], left);
parse_marker_recur([H|T], LengthAccum, RepeatsAccum, right) ->
    parse_marker_recur(T, LengthAccum, [H|RepeatsAccum], right).


calculate_uncompressed_size(Line) ->
    calculate_uncompressed_size_recur(Line, 0).

calculate_uncompressed_size_recur([], Accum) -> Accum;
calculate_uncompressed_size_recur([$(|T], Accum) ->
    {Size, Repeats, PastMarker} = parse_marker(T),
    {_, NewRemaining} = lists:split(Size, PastMarker),
    calculate_uncompressed_size_recur(NewRemaining, Accum + (Size * Repeats));

calculate_uncompressed_size_recur([_|T], Accum) ->
    calculate_uncompressed_size_recur(T, Accum + 1).


test() ->
    6 = calculate_uncompressed_size("ADVENT"),
    7 = calculate_uncompressed_size("A(1x5)BC"),
    9 = calculate_uncompressed_size("(3x3)XYZ"),
    11 = calculate_uncompressed_size("A(2x2)BCD(2x2)EFG"),
    6 = calculate_uncompressed_size("(6x1)(1x3)A"),
    18 = calculate_uncompressed_size("X(8x2)(3x3)ABCY").


main() ->
    test(),
    Line = strip_whitespace(get_line("input.txt")),
    io:format("~p~n", [calculate_uncompressed_size(Line)]),
    erlang:halt().
