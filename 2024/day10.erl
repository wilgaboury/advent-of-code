-module(day10).
-export([part1/1]).

parse_map(Filename) ->
  Lines = aocutil:read_lines(Filename),
  Width = length(lists:nth(1, Lines)),
  Height = length(Lines),
  MapArray = lists:foldl(
      fun({I, E}, Data) ->
        array:set(I-1, E, list_to_integer([Data]))
      end,
      array:new(Width*Height),
      lists:enumerate(lists:flatten(Lines))
  ),
  {MapArray, Width, Height}

pos_to_array_index({X, Y}, Width) -> X + Width * Y.
array_index_to_pos(I, Width) -> {I div Width, I rem Width}.

get_map_value({X, Y}, {MapArray, Width, Height}) ->
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
            CurValue = get_map_value(Cur)
            {MapArray, Width, Height} = Map,
            NewVisited = sets:add_element(Cur, Visited),
            NewScore = case CurValue == 9 of true -> Score+1; false -> Score end,
            PosDiffs = [{0,1}, {1,0}, {0,-1}, {-1,0}],
            VisitCandidates = lists:map(fun({Dx, Dy}) -> {X+Dx, Y+Dy} end, PosDiffs),
            RemoveVisited = lists:filter(fun(P) -> not sets:is_element(P, NewVisited) end, VisitCandidates)
            IsPath = fun(Next) -> 
                Value = get_map_value(Next),
                case Value of
                    undefined -> false;
                    _ -> Value - CurValue == 1
                end
            end,
            Visit = lists:filter(IsPath, RemoveVisited),
            calculate_score(Rest++Visit, Map, NewVisited, NewScore)
    end.

part1(Filename) ->
  Map = parse_map(Filename),
  {MapArray, Width, Height} = Map,
  Trailheads = find_value_positions(0, MapArray, Width),
  Scores = lists:map(fun(Trailhead) -> calculate_score(Trailhead, Map) end, Trailheads),
  lists:foldl(fun(Score, Sum) -> Score + Sum end, 0, Scores).
