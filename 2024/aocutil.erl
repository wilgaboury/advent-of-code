-module(aocutil).
-export([read_lines/1, parse_map/1, parse_map/2, pos_to_array_index/2, array_index_to_pos/2, get_map_value/2]).

read_lines(Filename) ->
    {ok, Data} = file:read_file(Filename),
    string:tokens(erlang:binary_to_list(Data), "\r\n").

parse_map(Filename) -> parse_map(Filename, fun(X) -> X end).
parse_map(Filename, Map) ->
    Lines = read_lines(Filename),
    Width = length(lists:nth(1, Lines)),
    Height = length(Lines),
    MapArray = lists:foldl(
        fun({I, E}, Data) ->
            array:set(I-1, Map(E), Data)
        end,
        array:new(Width*Height),
        lists:enumerate(lists:flatten(Lines))
    ),
    {MapArray, Width, Height}.

pos_to_array_index({X, Y}, Width) -> X + Y * Width.
array_index_to_pos(I, Width) -> {I rem Width, I div Width}.

get_map_value({X, Y}, {MapArray, Width, _}) ->
    case X >= 0 andalso X < Width andalso Y >= 0 andalso Y < Width of
        true -> array:get(pos_to_array_index({X, Y}, Width), MapArray);
        false -> undefined
    end.

