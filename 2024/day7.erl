-module(day7).
-export([part1/0, part1/1]).

op(0) -> fun(X, Y) -> X + Y end;
op(1) -> fun(X, Y) -> X * Y end;
op(2) -> fun(X, Y) -> list_to_integer(integer_to_list(X)++integer_to_list(Y)) end.

apply_ops(Ops, [Head|Rest]) ->
    Prods = prod(Ops, length(Rest)),
    lists:map(
        fun(Prod) ->
            lists:foldl(
                fun({Op, Next}, Acc) ->
                    OpFunc = op(Op),
                    OpFunc(Acc, Next)
                end,
                Head,
                lists:zip(Prod, Rest)
            )
        end,
        Prods
    ).

read_lines(FileName) ->
    case file:read_file(FileName) of
        {ok, Data} -> 
            Lines = binary:split(Data, <<"\r\n">>, [global]),
            lists:map(
                fun(BinaryLine) -> 
                    binary_to_list(BinaryLine) 
                end, 
                Lines
            )
    end.

read_input(Filename) ->
    {ok, StrLines} = read_lines(Filename),
    lists:map(
        fun(StrLine) ->
            io:format("~w", [string:split(StrLine, ":")]),
            [Num, NumsStr] = string:split(StrLine, ":"),
            Nums = string:tokens(NumsStr, " "),
            {Num, Nums}
        end,
        StrLines
    ).

part1() ->
    part1("day7_input.txt").
part1(Filename) ->
    Lines = read_input(Filename),
    lists:foldl(
        fun({Num, Nums}, Acc) ->
            Vals = apply_ops([0, 1], Nums),
            case lists:member(Num, Vals) of
                true -> Num + Acc;
                false -> Acc
            end
        end,
        0,
        Lines
    ).

prod(List, N) -> prod(List, lists:map(fun(Elem) -> [Elem] end, List), N-1).
prod(_, Result, N) when N < 1 -> Result;
prod(List, Result, N) ->
    prod(
        List, 
        lists:foldl(
            fun(Elem, Acc) ->
                lists:map(fun(Comb) -> Comb++[Elem] end, Result)++Acc
            end,
            [],
            List
        ),
        N-1
    ).