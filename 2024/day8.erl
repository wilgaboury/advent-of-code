-module(day8).
-export([part1/0, part1/1]).

antinodes({Ax, Ay}, {Bx, By}) ->
    Dx = Ax - Bx,
    Dy = Ay - By,
    [{Ax + Dx, Ay + Dy}, {Bx - Dx, By - Dy}].

part1() -> part1("day8_input.txt").
part1(Filename) -> 
    aocutil:read_lines(Filename).