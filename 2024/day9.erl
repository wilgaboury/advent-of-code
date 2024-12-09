-module(day9).
-export([part1/0, part1/1, part2/0, part2/1]).

-define(DEFAULT_INPUT_FILE, "day9_input.txt").

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

part1() -> part1(?DEFAULT_INPUT_FILE).
part1(Filename) ->
    checksum(compact(parse_disk(aocutil:read_lines(Filename)))).

part2() -> part2(?DEFAULT_INPUT_FILE).
part2(_Filename) ->
    ok.