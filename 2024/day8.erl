-module(day8).
-export([part1/0, part1/1, part2/0, part2/1, antinodes/1, antinodes/2, resonant_antinodes/2, resonant_antinodes/3, comb2/1]).

-define(DEFAULT_INPUT_FILE, "day8_input.txt").

comb2(List) -> comb2(List, []).
comb2([], Acc) -> Acc;
comb2([Head|Rest], Acc) ->
    NewAcc = Acc++lists:map(fun(Elem) -> {Head, Elem} end, Rest),
    comb2(Rest, NewAcc).

antinodes(List) ->
    lists:flatten(lists:map(fun({P1, P2}) -> antinodes(P1, P2) end, comb2(List))).
antinodes({Ax, Ay}, {Bx, By}) ->
    Dx = Ax - Bx,
    Dy = Ay - By,
    [{Ax + Dx, Ay + Dy}, {Bx - Dx, By - Dy}].

resonant_antinodes(List, InBounds) ->
    lists:flatten(lists:map(fun({P1, P2}) -> resonant_antinodes(P1, P2, InBounds) end, comb2(List))).
resonant_antinodes({Ax, Ay}, {Bx, By}, InBounds) ->
    Dx = Ax - Bx,
    Dy = Ay - By,
    [{Ax, Ay}, {Bx, By}]++resonant_antinodes_gen({Ax, Ay}, {Dx, Dy}, InBounds, [])++resonant_antinodes_gen({Bx, By}, {-Dx, -Dy}, InBounds, []).

resonant_antinodes_gen({X, Y}, {Dx, Dy}, InBounds, Acc) ->
    XNew = X + Dx,
    YNew = Y + Dy,
    case InBounds({XNew, YNew}) of
        true -> resonant_antinodes_gen({XNew, YNew}, {Dx, Dy}, InBounds, Acc++[{XNew, YNew}]);
        false -> Acc
    end.

read_map(Filename) ->
    Lines = aocutil:read_lines(Filename),
    Map = lists:foldl(
        fun({Y, Line}, Map1) ->
            lists:foldl(
                fun({X, Char}, Map2) ->
                    case Char /= $. of
                        true ->
                            List = maps:get(Char, Map2, []),
                            NewList = [{X-1, Y-1}|List],
                            maps:put(Char, NewList, Map2);
                        false -> Map2
                    end
                end,
                Map1,
                lists:enumerate(Line)
            )
        end,
        #{},
        lists:enumerate(Lines)
    ),
    [FirstLine|_] = Lines,
    Width = length(FirstLine),
    Height = length(Lines),
    InBounds = fun({X, Y}) -> X >= 0 andalso X < Width andalso Y >= 0 andalso Y < Height end,
    {Map, InBounds}.    

part1() -> part1(?DEFAULT_INPUT_FILE).
part1(Filename) ->
    {SatMap, InBounds} = read_map(Filename),
    AllAntinodes = lists:flatten(lists:map(fun antinodes/1, maps:values(SatMap))),
    Antinodes = sets:from_list(lists:filter(InBounds, AllAntinodes)),
    sets:size(Antinodes).

part2() -> part2(?DEFAULT_INPUT_FILE).
part2(Filename) ->
    {SatMap, InBounds} = read_map(Filename),
    AllAntinodes = lists:flatten(lists:map(fun(Sats) -> resonant_antinodes(Sats, InBounds) end, maps:values(SatMap))),
    Antinodes = sets:from_list(lists:filter(InBounds, AllAntinodes)),
    sets:size(Antinodes).