-module(day10).
-export([part1/0, part1/1, part2/0, part2/1, calculate_score/2, calculate_rating/2]).

-define(DEFAULT_INPUT_FILE, "day10_input.txt").

parse_map(Filename) ->
    Lines = aocutil:read_lines(Filename),
    Width = length(lists:nth(1, Lines)),
    Height = length(Lines),
    MapArray = lists:foldl(
        fun({I, E}, Data) ->
            array:set(I-1, list_to_integer([E]), Data)
        end,
        array:new(Width*Height),
        lists:enumerate(lists:flatten(Lines))
    ),
    {MapArray, Width, Height}.

pos_to_array_index({X, Y}, Width) -> X + Y * Width.
array_index_to_pos(I, Width) -> {I rem Width, I div Width}.

get_map_value({X, Y}, {MapArray, Width, _}) ->
    case X >= 0 andalso X < Width andalso Y >= 0 andalso Y < Width of
        true -> array:get(pos_to_array_index({X, Y}, Width), MapArray);
        false -> undefined
    end.

find_value_positions(Target, MapArray, Width) ->
  Indexes = array:foldl(
      fun(I, Value, Acc) ->
          case Value == Target of
              true -> [I|Acc];
              false -> Acc
          end
      end,
      [],
      MapArray
  ),
  lists:map(fun(I) -> array_index_to_pos(I, Width) end, Indexes). 

calculate_score(Start, Map) -> calculate_score([Start], Map, sets:new(), 0).
calculate_score([], _, _, Score) -> Score;
calculate_score([Cur|Rest], Map, Visited, Score) ->
    case sets:is_element(Cur, Visited) of
        true -> calculate_score(Rest, Map, Visited, Score);
        false -> 
            {X,Y} = Cur,
            CurValue = get_map_value(Cur, Map),
            NewVisited = sets:add_element(Cur, Visited),
            NewScore = case CurValue == 9 of true -> Score+1; false -> Score end,
            PosDiffs = [{0,1}, {1,0}, {0,-1}, {-1,0}],
            VisitCandidates = lists:map(fun({Dx, Dy}) -> {X+Dx, Y+Dy} end, PosDiffs),
            RemoveVisited = lists:filter(fun(P) -> not sets:is_element(P, NewVisited) end, VisitCandidates),
            IsPath = fun(Next) -> 
                Value = get_map_value(Next, Map),
                case Value of
                    undefined -> false;
                    _ -> Value - CurValue == 1
                end
            end,
            Visit = lists:filter(IsPath, RemoveVisited),
            calculate_score(Rest++Visit, Map, NewVisited, NewScore)
    end.

calculate_rating(Start, Map) -> calculate_rating([Start], Map, 0).
calculate_rating([], _, Rating) -> Rating;
calculate_rating([Cur|Rest], Map, Rating) ->
    {X,Y} = Cur,
    CurValue = get_map_value(Cur, Map),
    NewRating = case CurValue == 9 of true -> Rating+1; false -> Rating end,
    PosDiffs = [{0,1}, {1,0}, {0,-1}, {-1,0}],
    VisitCandidates = lists:map(fun({Dx, Dy}) -> {X+Dx, Y+Dy} end, PosDiffs),
    IsPath = fun(Next) -> 
        Value = get_map_value(Next, Map),
        case Value of
            undefined -> false;
            _ -> Value - CurValue == 1
        end
    end,
    Visit = lists:filter(IsPath, VisitCandidates),
    calculate_rating(Rest++Visit, Map, NewRating).

sum_list(List) -> lists:foldl(fun(Value, Sum) -> Value + Sum end, 0, List).

part1() -> part1(?DEFAULT_INPUT_FILE).
part1(Filename) ->
    Map = parse_map(Filename),
    {MapArray, Width, _} = Map,
    Trailheads = find_value_positions(0, MapArray, Width),
    Scores = rpc:pmap({day10, calculate_score}, [Map], Trailheads),
    sum_list(Scores).

part2() -> part2(?DEFAULT_INPUT_FILE).
part2(Filename) ->
    Map = parse_map(Filename),
    {MapArray, Width, _} = Map,
    Trailheads = find_value_positions(0, MapArray, Width),
    Ratings = rpc:pmap({day10, calculate_rating}, [Map], Trailheads),
    sum_list(Ratings).
