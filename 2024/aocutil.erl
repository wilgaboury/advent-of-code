-module(aocutil).
-export([read_lines/1]).

read_lines(Filename) ->
    {ok, Data} = file:read_file(Filename),
    string:tokens(erlang:binary_to_list(Data), "\r\n").