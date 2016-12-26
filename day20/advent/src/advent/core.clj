(ns advent.core)

(defn find-lowest-open [curr sorted-intervals]
  (let [head (first sorted-intervals)]
    (if (or (empty? sorted-intervals) (< (.compareTo curr (first head)) 0))
      curr
      (recur (.add (second head) (biginteger 1)) (rest sorted-intervals)))))

(def max-value (.add (new BigInteger "4294967295") (biginteger 1)))

(defn correct-for-remaining-range [curr last-open]
  (+ curr (.intValue (.subtract max-value last-open))))

(defn find-num-open [curr last-open sorted-intervals]
  (if (empty? sorted-intervals) (correct-for-remaining-range curr last-open)
    (let [head (first sorted-intervals)
          low (first head)
          next-open-candidate (.add (second head) (biginteger 1))
          the-rest (rest sorted-intervals)]
      (if (< (.compareTo last-open low) 0)
        (recur (+ curr (.intValue (.subtract low last-open))) next-open-candidate the-rest)
        (if (> (.compareTo (second head) last-open) 0)
            (recur curr next-open-candidate the-rest)
            (recur curr last-open the-rest))))))

(defn make-tuple [input]
  (let [[_ fst snd] (re-matches #"([0-9]+)-([0-9]+)" input)] (list (BigInteger. fst) (BigInteger. snd))))

(defn get-input [filename]
  (with-open [reader (clojure.java.io/reader filename)]
    (map make-tuple (doall (line-seq reader)))))

(defn -main []
  (let [list-of-ips (concat (sort-by first (get-input "../input.txt")))
        lowest-head (find-lowest-open (biginteger 0) list-of-ips)
        num-open-ports (find-num-open 0 (biginteger 0) list-of-ips)]
    (print "Part 1: ")
    (println lowest-head)
    (print "Part 2: ")
    (println num-open-ports)))
