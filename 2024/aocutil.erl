-module(aocutil).
-export([read_lines/1]).

read_lines(Filename) ->
    case file:read_file(Filename) of
        {ok, Data} -> 
            Lines = binary:split(Data, <<"\r\n">>, [global]),
            lists:map(
                fun(BinaryLine) -> 
                    binary_to_list(BinaryLine) 
                end, 
                Lines
            )
    end.