-module(day9).
-export([part1/0, part1/1, part2/0, part2/1, cleanup_free_blocks/1, compact_blocks/1]).

-define(DEFAULT_INPUT_FILE, "day9_input.txt").

read_file(Filename) -> 
    [Line] = aocutil:read_lines(Filename),
    Line.

parse_disk(Line) -> parse_disk(Line, 0, []).
parse_disk([File], Id, Acc) -> 
    FileSize = list_to_integer([File]),
    lists:reverse(lists:duplicate(FileSize, {file, Id})++Acc);
parse_disk([File,Free|Rest], Id, Acc) ->
    FileSize = list_to_integer([File]),
    FreeSize = list_to_integer([Free]),
    parse_disk(Rest, Id+1, lists:duplicate(FreeSize, free)++lists:duplicate(FileSize, {file, Id})++Acc).

compact(Disk) -> compact(Disk, lists:reverse(Disk), length(Disk), []).
compact(Disk, RDisk, Length, Acc) when length(Disk) + length(RDisk) == Length -> lists:reverse(Acc);
compact([Head|Rest], [Tail|RRest], Length, Acc) ->
    case Head of
        {file, _} -> compact(Rest, [Tail|RRest], Length, [Head|Acc]);
        free -> case Tail of
            {file, _} -> compact(Rest, RRest, Length, [Tail|Acc]);
            free -> compact([Head|Rest], RRest, Length, Acc)
        end
    end.

checksum(Disk) -> checksum(Disk, 0, 0).
checksum([], _Pos, Checksum) -> Checksum;
checksum([Head|Rest], Pos, Checksum) ->
    case Head of
        {file, Id} -> checksum(Rest, Pos+1, Pos*Id+Checksum);
        free -> checksum(Rest, Pos+1, Checksum)
    end.

list_to_blocks(List) -> list_to_blocks(List, []).
list_to_blocks([], Acc) -> lists:reverse(Acc);
list_to_blocks([Head|Rest], Acc) ->
    Next = lists:dropwhile(fun(E) -> E == Head end, Rest),
    Count = 1+length(Rest)-length(Next),
    list_to_blocks(Next, [{Count, Head}|Acc]).

blocks_to_list(Blocks) -> 
    Blockize = fun({Count, Value}, Acc) -> lists:duplicate(Count, Value)++Acc end,
    lists:reverse(lists:foldl(Blockize, [], Blocks)).

cleanup_free_blocks(List) -> cleanup_free_blocks(List, []).
cleanup_free_blocks([], Acc) -> lists:reverse(Acc);
cleanup_free_blocks([{Count, {file, Id}}|Rest], Acc) -> cleanup_free_blocks(Rest, [{Count, {file, Id}}|Acc]);
cleanup_free_blocks([{Count, free}|Rest], Acc) -> 
    case Count == 0 of
        true -> cleanup_free_blocks(Rest, Acc);
        false ->
            Splitter = fun({_, Value}) -> case Value of free -> true; _ -> false end end, 
            {Free, NewRest} = lists:splitwith(Splitter, Rest),
            NewFreeCount = Count + lists:foldl(fun({C, _}, Sum) -> C + Sum end, 0, Free),
            cleanup_free_blocks(NewRest, [{NewFreeCount, free}|Acc])
    end.

remove_block(TargetId, List) ->
    Remove = fun({Count, Value}) ->
        case Value of
            {file, Id} when Id == TargetId -> {Count, free};
            _ -> {Count, Value}
        end
    end,
    cleanup_free_blocks(lists:map(Remove, List)).

compact_blocks(List) -> compact_blocks(lists:reverse(List), List).
compact_blocks([], Acc) -> Acc;
compact_blocks([{_, free}|Rest], Acc) -> compact_blocks(Rest, Acc);
compact_blocks([{FileCount,{file, FileId}}|Rest], Acc) ->
    InsertSplitter = fun({Count, Value}) ->
        case Value of
            {file, Id} -> FileId /= Id;
            free -> Count < FileCount
        end
    end,
    {AccStart, AccEnd} = lists:splitwith(InsertSplitter, Acc),
    case AccEnd of
        [{FreeCount, free}|AccEndRest] ->
            AccRemove = remove_block(FileId, AccEndRest), 
            NewAcc = cleanup_free_blocks(AccStart++[{FileCount,{file, FileId}}, {FreeCount-FileCount, free}]++AccRemove),
            compact_blocks(Rest, NewAcc);
        _ -> compact_blocks(Rest, Acc)
    end.

part1() -> part1(?DEFAULT_INPUT_FILE).
part1(Filename) ->
    checksum(compact(parse_disk(read_file(Filename)))).

part2() -> part2(?DEFAULT_INPUT_FILE).
part2(Filename) ->
    checksum(blocks_to_list(compact_blocks(list_to_blocks(parse_disk(read_file(Filename)))))).