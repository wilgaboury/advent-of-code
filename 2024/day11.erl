-module(day11).
-export([part1/0, part1/1, part2/0, part2/1, part2_bad/0, blink/1, blink_count_split/4, split/2]).

-define(DEFAULT_INPUT_FILE, "day11_input.txt").

parse_stones(Filename) ->
    [Line] = aocutil:read_lines(Filename),
    lists:map(fun list_to_integer/1, string:tokens(Line, " ")).

blink(List) ->
    FoldFun = fun(Stone, Acc) -> 
        case Stone of
            0 -> [1|Acc];
            _ -> 
                ListStone = integer_to_list(Stone),
                Length = length(ListStone),
                case Length rem 2 of
                0 ->
                    {S1, S2} = lists:split(Length div 2, ListStone),
                    [list_to_integer(S2),list_to_integer(S1)|Acc];
                _ -> [Stone*2024|Acc]
            end
        end
    end,
    lists:foldl(FoldFun, [], List).

repeat(_, Arg, 0) -> Arg;
repeat(Fun, Arg, N) ->
    NextArg = Fun(Arg),
    repeat(Fun, NextArg, N-1).

split(List, N) ->
    Mod = length(List) div (N-1),
    lists:foldl(
        fun({I, E}, Acc) ->
            case {Acc, (I-1) rem Mod} of
                {[], _} -> [[E]];
                {[AccHead|AccRest], 0} -> [[E],AccHead|AccRest];
                {[AccHead|AccRest], _} -> [[E|AccHead]|AccRest]
            end
        end,
        [],
        lists:enumerate(List)
    ).

blink_count_split(List, _, 0, _) -> length(List);
blink_count_split(List, Limit, N, InThread) ->
    Blinked = blink(List),
    case N < 20 orelse length(Blinked) < Limit of
        true -> blink_count_split(Blinked, Limit, N-1, InThread);
        false ->
            case InThread of
                true -> lists:sum(lists:map(fun(Section) -> blink_count_split(Section, Limit, N-1, InThread) end, split(Blinked, 50)));
                false -> lists:sum(rpc:pmap({day11, blink_count_split}, [Limit, N-1, true], split(Blinked, 8)))
            end
    end.

blink_stone(Stone) ->
    case Stone of
        0 -> [1];
        _ -> 
            ListStone = integer_to_list(Stone),
            Length = length(ListStone),
            case Length rem 2 of
            0 ->
                {S1, S2} = lists:split(Length div 2, ListStone),
                [list_to_integer(S1), list_to_integer(S2)];
            _ -> [Stone*2024]
        end
    end.

blink_multiple_cache(Stones, N) -> 
    {Result, _ } = blink_multiple_cache(Stones, N, maps:new()),
    Result.
blink_multiple_cache(Stones, N, Cache) ->
    lists:foldl(
        fun(Stone, {Result, AccCache}) -> 
            {NewResult, NewCache} = blink_cache(Stone, N, AccCache),
            {Result + NewResult, NewCache}
        end, 
        {0, Cache},
        Stones    
    ).

blink_cache(_, 0, Cache) -> {1, Cache};
blink_cache(Stone, N, Cache) ->
    case maps:get({Stone, N}, Cache, undefined) of
        undefined -> 
            NewStones = blink_stone(Stone),
            {Result, ResultCache} = blink_multiple_cache(NewStones, N-1, Cache),
            NewCache = maps:put({Stone, N}, Result, ResultCache),
            {Result, NewCache};
        Value -> {Value, Cache}
    end.

part1() -> part1(25).
part1(Itr) -> part1(?DEFAULT_INPUT_FILE, Itr).
part1(Filename, Itr) ->
    length(repeat(fun blink/1, parse_stones(Filename), Itr)).

part2() -> part2(75).
part2(N) -> part2(?DEFAULT_INPUT_FILE, N).
part2(Filename, N) ->
    blink_multiple_cache(parse_stones(Filename), N).

part2_bad() -> part2_bad(75).
part2_bad(Itr) -> part2_bad(?DEFAULT_INPUT_FILE, Itr).
part2_bad(Filename, Itr) ->
    blink_count_split(parse_stones(Filename), 10000, Itr, false).