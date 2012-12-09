class Sudoku
  def initialize(file)
    puzzle = []
    File.open(file) do |file|
      file.each_line do |line|
        row = line.scan(/./).map { |tile| tile.to_i }
        puzzle << row
      end
    end

    puts "Puzzle:"
    show puzzle

    solution = solve puzzle
    if solution.nil?
      puts "Could not find solution"
    else
      puts "Solved:"
      show solution
    end
  end

  def solve(prev_board)
    board, empty_tile = fill(prev_board)
    return board if board.nil? || solved?(board)

    row_i, col_i, possible_values = empty_tile
    possible_values.each do |value|
      copy = clone board
      copy[row_i][col_i] = value
      solved = solve(copy)
      next if solved.nil?
      return solved
    end
    nil
  end

  def fill(board, tile_set = true)
    while tile_set
      empty_tile, tile_set = nil, false

      for_each_empty_tile(board) do |row_i, col_i|
        possible_values = getValues(board, row_i, col_i)
        return nil if possible_values.empty?

        if possible_values.length == 1
          board[row_i][col_i] = possible_values.first
          tile_set = true
        else
          empty_tile = [row_i, col_i, possible_values]
        end
      end
    end
    return board, empty_tile
  end

  def getValues(board, row_i, col_i)
    x = (row_i / 3) * 3
    y = (col_i / 3) * 3
    square = board[x..x+2].flat_map { |row| row[y..y+2] }

    [*(1..9)] - (board[row_i] | board.transpose[col_i] | square)
  end

  def for_each_empty_tile(board)
    board.each_with_index do |row, row_i|
      row.each_with_index do |tile, col_i|
        yield row_i, col_i  if tile.zero?
      end
    end
  end

  def clone(board)
    board.inject([]) { |copy_rows, self_row| copy_rows << self_row.dup }
  end

  def solved?(board)
    board.flatten.none? { |tile| tile.zero? }
  end

  def show(board)
    board.each_with_index do |row, row_i|
      print "+-------"*3 +"+\n" if row_i %3 == 0
      row.each_with_index do |tile, col_i|
        print "| " if col_i % 3 == 0
        if tile.zero? then print "_ " else print "#{tile} " end
      end
      print "|\n"
    end
    print print "+-------"*3 +"+\n"
  end
end

Sudoku.new("puzzles/puzzle2.txt")