import scala.io._

class Sudoku(val puzzle:String){
  val dim = List.range(0, 9)
  var problem:List[List[Char]] = List()

  Source.fromFile(puzzle).getLines.foreach (line => problem ::= line.toList)

  println("board loaded:")
  show(problem)

  var solution = solve(problem)
  if (isSolved(solution)) {
    println("solved:")
    show(solution)
  } else {
    println("Could not find solution.")
  }

  def solve(p:List[List[Char]]):List[List[Char]] = {
    var (board, emptyTile) = fill(p)
    if (board == null || isSolved(board)) return board

    val (rIndex, cIndex, possibleValues) = emptyTile
    possibleValues.foreach{ (value) =>
      val row = board(rIndex)
      val guess = board.updated(rIndex, row.updated(cIndex, value))
      val solved = solve(guess)
      if (solved != null) return solved
    }
    return null
  }

  def fill(p:List[List[Char]]):(List[List[Char]], (Int, Int, List[Char])) = {
    var board = p
    var tileSet = true
    var emptyTile = (0,0,List[Char]())
    while(tileSet) {
      tileSet = false
      (board, dim).zipped.foreach{ (row, rIndex) =>
        (row, dim).zipped.foreach { (tile, cIndex) =>
          if(tile == '0') {
            var possibleValues = getValues(board, rIndex, cIndex)
            if (possibleValues.size == 0) return (null, emptyTile)
            if (possibleValues.size == 1) {
              board = board.updated(rIndex, row.updated(cIndex, possibleValues(0)))
              tileSet = true
            } else {
              emptyTile = (rIndex, cIndex, possibleValues)
            }
          }
        }
      }
    }
    return (board, emptyTile)
  }

  def getValues(board:List[List[Char]], rIndex:Int, cIndex:Int):List[Char] = {
    val x = (rIndex / 3) * 3
    val y = (cIndex / 3) * 3
    var square:List[Char] = List()
    for (i <- x until x+3) {
      for (j <- y until y+3) {
        square ::= board(i)(j)
      }
    }
    val cols = board.transpose
    return List.range(1, 10).map{v => (v+'0').toChar}.filterNot{v => (board(rIndex) union cols(cIndex) union square).contains(v) }
  }

  def isSolved(board:List[List[Char]]):Boolean = {
    return board != null && !board.flatten.contains('0')
  }

  def show(board:List[List[Char]]) {
    println("+-------+-------+-------+")
    (board, dim).zipped.foreach{ (row, rIndex) =>
      print("| ")
      (row, dim).zipped.foreach { (tile, cIndex) =>
        print(if(tile == '0') "_ " else tile + " ")
        if(cIndex % 3 == 2) print("| ")
      }
      println
      if(rIndex % 3 == 2) println("+-------+-------+-------+")
    }
  }
}

new Sudoku("puzzles/puzzle2.txt");