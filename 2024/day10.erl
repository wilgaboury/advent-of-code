-module(day10).
-export([part1/1]).

parse_map(Filename) ->
  Lines = aocutil:read_lines(Filename),
  Width = length(lists:nth(1, Lines)),
  Height = length(Lines),
  MapArray = lists:foldl(
      fun({I, E}, Data) ->
        array:set(I-1, E, list_to_integer([Data]))
      end,
      array:new(Width*Height),
      lists:enumerate(lists:flatten(Lines))
  ),
  {MapArray, Width, Height}

pos_to_array_index({X, Y}, Width) -> X + Width * Y.
array_index_to_pos(I, Width) -> {I div Width, I rem Width}.

find_value_positions(Target, MapArray, Width) ->
  Indexes = array:foldl(
      fun(I, Value, Acc) ->
          case Value == Target of
              true -> [I|Acc];
              false -> Acc
          end
      end,
      [],
      MapArray
  ),
  lists:map(fun(I) -> array_index_to_pos(I, Width) end, Indexes). 

part1(Filename) ->
  {MapArray, Width, Height} = parse_map(Filename),
  Trailheads = find_value_positions(0, MapArray, Width),
  Terminals = find_value_positions(9, MapArray, Width),
  ok.
