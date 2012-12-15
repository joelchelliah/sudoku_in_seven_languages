(defn show [board]
  (if-not (empty? board) (do
    (println (first board))
    (show (rest board)))))

(defn get-sub [i]
  (cond
    (<= 0 i 2) 0
    (<= 3 i 5) 3
    (<= 6 i 8) 6))

(defn transpose [board]
  (apply map vector board))

(defn get-values [board row-i col-i]
  (let [sub-row-i (get-sub row-i)
        sub-col-i (get-sub col-i)
        sub-rows (subvec board sub-row-i (+ sub-row-i 3))
        square (flatten (map #(subvec % sub-col-i (+ sub-col-i 3)) sub-rows))]
    (filter #(not (some #{%} (flatten (merge (nth board row-i) (nth (transpose board) col-i) square)))) [1 2 3 4 5 6 7 8 9])))

(defn solve [board row-i col-i]
  (cond
    (= row-i 9) board
    (= col-i 9) (solve board (inc row-i) 0)
    :else
      (let [row (nth board row-i)]
        (let [tile (nth row col-i)]
          (if-not (= tile 0)
            (solve board row-i (inc col-i))
            (let [possible-values (get-values board row-i col-i)]
              (if (= 0 (count possible-values))
                :dead-end
                (let [solutions (for [value possible-values] (solve (assoc-in board [row-i col-i] value) 0 0))]
                  (flatten (filter #(not= % :dead-end) solutions))))))))))

(defn sudoku [puzzle] (do
  (println "Puzzle:")
  (show puzzle)
  (println "\n Solved:")
  (show (partition 9 (solve puzzle 0 0)))
  ))

(sudoku [[0 0 0 2 8 3 0 0 0] [0 2 0 0 5 0 0 9 0] [8 0 6 9 0 7 1 0 2] [3 0 9 0 0 0 5 0 8] [7 6 0 0 0 0 0 1 4] [2 0 8 0 0 0 7 0 9] [9 0 2 3 0 4 6 0 7] [0 8 0 0 7 0 0 3 0] [0 0 0 5 2 8 0 0 0]])