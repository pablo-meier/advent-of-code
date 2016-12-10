-module(part2).
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
    {Substring, NewRemaining} = lists:split(Size, PastMarker),
    SubSize = calculate_uncompressed_size(Substring),
    calculate_uncompressed_size_recur(NewRemaining, Accum + (SubSize * Repeats));

calculate_uncompressed_size_recur([_|T], Accum) ->
    calculate_uncompressed_size_recur(T, Accum + 1).


test() ->
    6 = calculate_uncompressed_size("ADVENT"),
    9 = calculate_uncompressed_size("(3x3)XYZ"),
    20 = calculate_uncompressed_size("X(8x2)(3x3)ABCY"),
    241920 = calculate_uncompressed_size("(27x12)(20x12)(13x14)(7x10)(1x12)A"),
    445 = calculate_uncompressed_size("(25x3)(3x3)ABC(2x3)XY(5x2)PQRSTX(18x9)(3x2)TWO(5x7)SEVEN").


main() ->
    test(),
    Line = strip_whitespace(get_line("input.txt")),
    io:format("~p~n", [calculate_uncompressed_size(Line)]),
    erlang:halt().
