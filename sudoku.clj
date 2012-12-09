(defn show [board]
  (if-not (empty? board) (do
    (println (first board))
    (show (rest board)))))

(defn solve [board row-i col-i] (do
  (cond
    (= row-i 9) (println "finished")
    (= col-i 9) (solve board (inc row-i) 0)
    :else       (solve board row-i (inc col-i)))
  board))

(defn sudoku [puzzle] do(
  (println "Puzzle:")
  (show puzzle)
  (println "\nSolved:")
  (show (solve puzzle 0 0))))

(sudoku [[0 0 0 2 8 3 0 0 0] [0 2 0 0 5 0 0 9 0] [8 0 6 9 0 7 1 0 2] [3 0 9 0 0 0 5 0 8] [7 6 0 0 0 0 0 1 4] [2 0 8 0 0 0 7 0 9] [9 0 2 3 0 4 6 0 7] [0 8 0 0 7 0 0 3 0] [0 0 0 5 2 8 0 0 0]])
