-module(day8).
-export([part1/0, part1/1, antinodes/1, antinodes/2, comb2/1]).

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
    {Map, length(Lines), length(FirstLine)}.

part1() -> part1("day8_input.txt").
part1(Filename) ->
    {SatMap, Width, Height} = read_map(Filename),
    InBounds = fun({X, Y}) -> X >= 0 andalso X < Width andalso Y >= 0 andalso Y < Height end,
    AllAntinodes = lists:flatten(lists:map(fun antinodes/1, maps:values(SatMap))),
    Antinodes = sets:from_list(lists:filter(InBounds, AllAntinodes)),
    sets:size(Antinodes).

