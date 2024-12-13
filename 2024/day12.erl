-module(day12).
-export([part1/0, part1/1, part2/0, part2/1]).

-define(DEFAULT_INPUT_FILE, "day12_input.txt").

parse_input(Filename) -> aocutil:parse_map(Filename).

calculate_price_for_target(Start, Target, Visited, Map) -> calculate_price_for_target([Start], Target, Visited, Map, {0, 0}).
calculate_price_for_target([], _, Visited, _, {Area, Perimeter}) -> {Visited, Area, Perimeter};
calculate_price_for_target([Cur|Rest], Target, Visited, Map, {Area, Perimeter}) ->
    io:format("bfs: ~w\n", [Cur]),
    case aocutil:get_map_value(Cur, Map) /= Target of
        true -> case sets:is_element(Cur, Visited) of
            true -> calculate_price_for_target(Rest, Target, Visited, Map, {Area, Perimeter+1});
            false -> calculate_price_for_target(Rest, Target, Visited, Map, {Area, Perimeter+1})
        end;
        false ->
            {X,Y} = Cur,
            NewVisited = sets:add_element(Cur, Visited),
            PosDiffs = [{0,1}, {1,0}, {0,-1}, {-1,0}],
            Visit = lists:filter(fun(P) -> not sets:is_element(P, NewVisited) end, lists:map(fun({Dx, Dy}) -> {X+Dx, Y+Dy} end, PosDiffs)),
            calculate_price_for_target(Rest++Visit, Target, NewVisited, Map, {Area+1, Perimeter})
    end.

calculate_price(Map) -> calculate_price(Map, sets:new(), 0, {0, 0}).
calculate_price(Map, Visited, Idx, {Area, Perimeter}) ->
    {MapArray, Width, _} = Map,
    case array:size(MapArray) == Idx of
        true -> Area * Perimeter;
        false -> 
            Cur = aocutil:array_index_to_pos(Idx, Width),
            io:format("~w, ~w, ~w, ~w\n", [Idx, Cur, aocutil:get_map_value(Cur, Map), sets:is_element(Cur, Visited)]),
            case sets:is_element(Cur, Visited) of
                true -> calculate_price(Map, Visited, Idx+1, {Area, Perimeter});
                false -> 
                    {NewVisited, NewArea, NewPerimeter} = calculate_price_for_target(Cur, aocutil:get_map_value(Cur, Map), Visited, Map),
                    calculate_price(Map, NewVisited, Idx+1, {Area+NewArea, Perimeter+NewPerimeter})
            end
    end.
        

part1() -> part1(?DEFAULT_INPUT_FILE).
part1(Filename) ->
    calculate_price(parse_input(Filename)).

part2() -> part2(?DEFAULT_INPUT_FILE).
part2(_Filename) ->
    ok.