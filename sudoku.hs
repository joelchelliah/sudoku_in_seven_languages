module Main where
import Data.List

solve puzzle rowI colI
	| rowI == 9 = print "Solution" >> display puzzle >> return (Just puzzle)
	| colI == 9 = solve puzzle (rowI + 1) 0
	| otherwise =
		if ((puzzle !! rowI !! colI) /= 0) 
			then solve puzzle rowI (colI + 1)
			else 
				tryValues puzzle rowI colI (concat $ possibleValues (puzzle, rowI, colI)) where
					tryValues board rowI colI [] = return Nothing
					tryValues board rowI colI (h:t) = do
						let newRow = (updateList ((board !! rowI), (board !! rowI !! colI), h, []));
						let newBoard = (updateList (board, (board !! rowI), newRow, []));
						_ <- solve newBoard 0 0
						tryValues board rowI colI t

updateList ((h:t), old, new, acc) = if (h == old) then acc ++ [new] ++ t else updateList (t, old, new, (acc ++ [h]))

possibleValues :: ([[Int]], Int, Int) -> [[Int]]
possibleValues (board, rowI, colI) = do
	let y = (floor (fromIntegral rowI / fromIntegral 3)) * 3;
	let x = (floor (fromIntegral colI / fromIntegral 3)) * 3;
	let row = (board !! rowI);
	let col = ((transpose board) !! colI);
	let square = concat $ map (drop x . take (x + 3)) (drop y . take (y + 3) $ board);
	return $ [1..9] \\ (row `union` col `union` square)

display []    = print ""
display (h:t) = print h >> display t

sudokuboard = [[0,4,0,2,0,0,5,0,0], [0,0,5,0,7,0,0,0,8], [9,0,0,0,0,0,0,4,0], [1,0,0,9,0,0,0,6,0], [0,0,7,0,5,0,0,8,0], [0,0,0,0,0,6,0,0,0], [4,1,0,0,0,0,0,0,0], [0,7,3,0,0,0,2,0,0], [0,0,9,0,6,7,0,0,0]]
sudoku 0 = print "Board:" >> display sudokuboard >> solve sudokuboard 0 0
