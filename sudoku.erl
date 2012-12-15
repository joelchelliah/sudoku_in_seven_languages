-module(sudoku).
-export([sudoku/0, solve/3]).

solve(Puzzle) -> io:format("~n Puzzle: ~n"), show(Puzzle), solve(Puzzle, 0, 0).

solve(Board, 9, _) -> io:format("~n      Solved: ~n"), show(Board), exit(done);

solve(Board, RowI, 9) -> solve(Board, RowI + 1, 0);

solve(Board, RowI, ColI) ->
	Row = lists:nth(RowI + 1, Board),
	Tile = lists:nth(ColI + 1, Row),
	if
    Tile /= 0 -> solve(Board, RowI, ColI + 1);
		Tile == 0 ->
			PossibleValues = find_possible_values(Board, RowI, ColI),
			case length(PossibleValues) of
				0 -> exit("No solution found");
				_ ->
					lists:foreach(fun(Value) ->
						NewRow =   lists:sublist(Row, ColI)   ++ [Value]  ++ lists:nthtail(ColI + 1, Row),
						NewBoard = lists:sublist(Board, RowI) ++ [NewRow] ++ lists:nthtail(RowI + 1, Board),
						spawn(?MODULE, solve, [NewBoard, 0, 0]) end, PossibleValues
				     	)
			end
	end.


find_possible_values(Board, RowI, ColI) ->
	SubRow = trunc(RowI / 3) * 3 + 1,
	SubCol = trunc(ColI / 3) * 3 + 1,
	Square = lists:flatten(lists:map( fun(Row) -> lists:sublist(Row, SubCol, 3) end, lists:sublist(Board, SubRow, 3) )),
	lists:subtract([1,2,3,4,5,6,7,8,9], lists:append([lists:nth(RowI + 1, Board), lists:nth(ColI + 1, transpose(Board)), Square])).


transpose([[]|_]) -> [];
transpose(Board) -> [lists:map(fun hd/1, Board) | transpose(lists:map(fun tl/1, Board))].


show(Board) -> show(Board, 0).

show([],_)-> io:format("--------+-------+--------~n");

show([[H1,H2,H3,H4,H5,H6,H7,H8,H9]|T], Row)->
	case Row rem 3 of
		0 -> io:format("--------+-------+--------~n"),
		     io:format("| ~p ~p ~p | ~p ~p ~p | ~p ~p ~p |~n",[H1,H2,H3,H4,H5,H6,H7,H8,H9]);
		_ -> io:format("| ~p ~p ~p | ~p ~p ~p | ~p ~p ~p |~n",[H1,H2,H3,H4,H5,H6,H7,H8,H9])
	end,
	show(T, Row+1).


% Puzzle:
sudoku() -> solve([[0,4,0,2,0,0,5,0,0], [0,0,5,0,7,0,0,0,8], [9,0,0,0,0,0,0,4,0], [1,0,0,9,0,0,0,6,0], [0,0,7,0,5,0,0,8,0], [0,0,0,0,0,6,0,0,0], [4,1,0,0,0,0,0,0,0], [0,7,3,0,0,0,2,0,0], [0,0,9,0,6,7,0,0,0]]).