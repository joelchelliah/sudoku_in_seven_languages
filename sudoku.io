Sudoku := clone Object do (

  solvePuzzle := method(name,
    puzzle := list()
    file := File with(name)
    file openForReading
    9 repeat(puzzle append(file readLine toList))
    file close
    puzzle foreach(row, row mapInPlace(asNumber))

    writeln("Board loaded:")
    show(puzzle)

    solution := solve(puzzle)
    if(solution == nil) then(
      writeln("Could not find solution")
    ) else(
      writeln("Solved:")
      show(solution)
    )
  )

  solve := method(prev_board,
    filled := fill(prev_board)
    board := filled at(0)
    if(board == nil or isSolved(board), return board)

    emptyTile := filled at(1)
    rIndex := emptyTile at(0)
    cIndex := emptyTile at(1)
    possibleValues := emptyTile at(2)

    possibleValues foreach(value,
      copied := copy(board)
      copied at(rIndex) atPut(cIndex, value)
      solved := solve(copied)
      if(solved==nil, continue)
      return solved
    )
    nil
  )

  fill := method(board,
    tileSet := true
    while(tileSet,
      tileSet = false
      emptyTile := nil
      board foreach(rIndex, row,
        row foreach(cIndex, tile,
          if(tile==0,
            possibleValues := getValues(board, rIndex, cIndex)
            if(possibleValues isEmpty, return list(nil))
            if(possibleValues size == 1) then(
              board at(rIndex) atPut(cIndex, possibleValues at(0))
              if(isSolved(board), return list(board))
              tileSet = true
            ) else(
              emptyTile = list(rIndex, cIndex, possibleValues)
            )
          )
        )
      )
    )
    return list(board, emptyTile)
  )

  getValues := method(board, rIndex, cIndex,
    square := list()
    bRow := (rIndex/3) floor *3
    bCol := (cIndex/3) floor * 3
    3 repeat(ci,
      3 repeat(ri,
        square append(board at(bRow + ri) at(bCol + ci))
      )
    )
    list(1,2,3,4,5,6,7,8,9) difference( board at(rIndex) union(transpose(board) at(cIndex) union(square)) )
  )

  transpose := method(board,
    transposed := copy(board)
    9 repeat(x,
      9 repeat(y,
        transposed at(y) atPut(x, board at(x) at(y))
      )
    )
    transposed
  )

  copy := method(board,
    copied := list()
    board foreach(row, copied append(row clone))
    copied
  )

  isSolved := method(board, if(board flatten contains(0), return false, return true))

  show := method(board,
    writeln("+-------+-------+-------+")
    board foreach(y, row,
      write("|")
      row foreach(x, tile,
        if(tile==0, write(" ", "_"), write(" ", tile))
        if(x%3==2, write(" |"))
      )
      writeln()
      if(y%3==2, writeln("+-------+-------+-------+"))
    )
  )
)

Sequence toList := method(
  sList := list()
  foreach(char, sList append(char asCharacter))
)

Sudoku clone solvePuzzle("puzzles/puzzle2.txt")