;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; High-level: Write logic that can take any state of elevator and floor possibilites and move on
;; to the next state. Then we BFS using a queue to explore the entire solution tree, keeping track
;; of how deep into the tree we're going. Return that number if we're at the win condition.

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Lazy man's Queue

(defparameter *queue* '(() ()) "LIST PROCESSING")
  
(defun dequeue ()
  (if (first *queue*) 
    (let ((value (car (first *queue*))))
      (setf (first *queue*) (cdr (first *queue*)))
      value)
    (let ((reversed-back (reverse (second *queue*))))
      (setf (first *queue*) (cdr reversed-back))
      (setf (second *queue*)'())
      (car reversed-back))))

(defun enqueue (value)
  (setf (second *queue*) (cons value (second *queue*))))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; State mangling

(defparameter *visited* (make-hash-table :test #'equalp))
(defparameter *init-state*
  '(0
    ((POLONIUM-GENERATOR
      THULIUM-GENERATOR THULIUM-MICROCHIP
      PROMETHIUM-GENERATOR
      RUTHENIUM-GENERATOR RUTHENIUM-MICROCHIP 
      COBALT-GENERATOR COBALT-MICROCHIP)
     (POLONIUM-MICROCHIP PROMETHIUM-MICROCHIP)
     ()
     ()) 
    0)
  "A state is a current elevator floor, list of floors, each one containing their components, and the depth of the solution.")

(defparameter *all-components*
  '(POLONIUM-GENERATOR POLONIUM-MICROCHIP 
    THULIUM-GENERATOR THULIUM-MICROCHIP
    PROMETHIUM-GENERATOR PROMETHIUM-MICROCHIP
    RUTHENIUM-GENERATOR RUTHENIUM-MICROCHIP 
    COBALT-GENERATOR COBALT-MICROCHIP))


; (defparameter *init-state*
;   '(0
;     ((POLONIUM-MICROCHIP RUTHENIUM-MICROCHIP)
;      (POLONIUM-GENERATOR)
;      (RUTHENIUM-GENERATOR)
;      ()) 
;     0))

;(defparameter *all-components*
;  '(POLONIUM-GENERATOR POLONIUM-MICROCHIP 
;    RUTHENIUM-GENERATOR RUTHENIUM-MICROCHIP))

(defun state-floor (state) (car state))
(defun state-floors (state) (cadr state))
(defun state-turn (state) (caddr state))
(defun ormap (lst) (reduce #'(lambda (x y) (or x y))  lst :initial-value '()))
(defun andmap (lst) (reduce #'(lambda (x y) (and x y)) lst :initial-value 'TRUE))
(defun take (index lst) (if (= 0 index) '() (cons (car lst) (take (- index 1) (cdr lst)))))
(defun drop (index lst) (if (= 1 index) (cdr lst) (drop (- index 1) (cdr lst))))
(defun replace-nth (lst index val)
  (append (take index lst) (list val) (drop (+ 1 index) lst)))

(defun microchipp (sym)
  (member sym '(POLONIUM-MICROCHIP THULIUM-MICROCHIP PROMETHIUM-MICROCHIP RUTHENIUM-MICROCHIP COBALT-MICROCHIP)))
(defun generatorp (sym)
  (member sym '(POLONIUM-GENERATOR THULIUM-GENERATOR PROMETHIUM-GENERATOR RUTHENIUM-GENERATOR COBALT-GENERATOR)))
(defun paireq (x y pair)
  (or (and (eq x (first pair))
           (eq y (second pair)))
      (and (eq y (first pair))
           (eq x (second pair)))))

(defparameter *known-goods*
  '((POLONIUM-GENERATOR POLONIUM-MICROCHIP)
    (THULIUM-GENERATOR THULIUM-MICROCHIP)
    (PROMETHIUM-GENERATOR PROMETHIUM-MICROCHIP)
    (RUTHENIUM-GENERATOR RUTHENIUM-MICROCHIP)
    (COBALT-GENERATOR COBALT-MICROCHIP)))

(defun its-generator (sym)
  (if (eq sym 'POLONIUM-MICROCHIP) 'POLONIUM-GENERATOR
    (if (eq sym 'THULIUM-MICROCHIP) 'THULIUM-GENERATOR
      (if (eq sym 'PROMETHIUM-MICROCHIP) 'PROMETHIUM-GENERATOR
        (if (eq sym 'RUTHENIUM-MICROCHIP) 'RUTHENIUM-GENERATOR
          'COBALT-GENERATOR)))))

(defun its-microchip (sym)
  (if (eq sym 'POLONIUM-GENERATOR) 'POLONIUM-MICROCHIP
    (if (eq sym 'THULIUM-GENERATOR) 'THULIUM-MICROCHIP
      (if (eq sym 'PROMETHIUM-GENERATOR) 'PROMETHIUM-MICROCHIP
        (if (eq sym 'RUTHENIUM-GENERATOR) 'RUTHENIUM-MICROCHIP
          'COBALT-MICROCHIP)))))

(defun valid-pairp (pair)
  (let ((fst (first pair))
        (snd (second pair)))
    (or (and (generatorp fst) (generatorp snd))
        (and (microchipp fst) (microchipp snd))
        (ormap (mapcar #'(lambda (x) (paireq fst snd x)) *known-goods*)))))

(defun valid-floorp (fl)
  (or (andmap (mapcar #'generatorp fl))
      (andmap (mapcar #'microchipp fl))
      (let ((chips (remove-if-not #'microchipp fl)))
        (andmap (mapcar #'(lambda (chip) (member (its-generator chip) fl)) chips)))))

(defun invalid-pairp (pair)
  (not (valid-pairp pair)))

(defun invalid-floorp (fl)
  (not (valid-floorp fl)))

(defun win-condition-or-enqueue (state)
  "We win when we have all the generators + chips on the fourth floor. Return the state in that case, NIL otherwise."
  (let ((fourth-floor (fourth (state-floors state))))
    (if (andmap (mapcar #'(lambda (component) (member component fourth-floor)) *all-components*))
      state
      (and (enqueue state) '()))))


(defun all-pairs (remaining)
  (if (> (length remaining) 1)
    (let ((these (mapcar #'(lambda (x) (list x (car remaining))) (cdr remaining)))
          (others (all-pairs (cdr remaining))))
      (append these others))
    '()))


(defun singles-valid-doubles (components)
  (let ((pairs (if components (all-pairs components) '())))
    (append (mapcar #'list components) (remove-if #'invalid-pairp pairs))))


(defun floor-analysis (floors curr-floor new-floor)
  "All singles and valid pairs of current floor. Then create new floor, ensure validity."
  (let* ((pairs-from-floor (singles-valid-doubles (nth curr-floor floors)))
         (new-floors-with-pairs (mapcar #'(lambda (x) (append x (nth new-floor floors))) pairs-from-floor))
         (old-floors-sans-pairs (mapcar #'(lambda (x) 
                                            (reduce #'(lambda (x y) (remove y x)) x :initial-value (nth curr-floor floors))) pairs-from-floor))
         (new-floors (mapcar #'list new-floors-with-pairs old-floors-sans-pairs))
         (valid-floors (remove-if #'(lambda (x) (or (invalid-floorp (car x)) (invalid-floorp (cadr x)))) new-floors)))
    (mapcar #'(lambda (x) (replace-nth (replace-nth floors new-floor (car x)) curr-floor (cadr x))) valid-floors)))


(defun move-maker (func state)
  "Takes a function. Returns a state with the following transformations:
    * Takes the components of the current floor, finds all valid pairs of the two of them,
      and creates a new set of floors for each of those pairs that can be moved to the adjacent
      floor (according to (function)).
    * New floor is calculated by applying that function to the current floor if within bounds.
    * Turn count in incremented."
    (let* ((old-floor (state-floor state))
           (new-floor (funcall func old-floor)))
      (if (and (> new-floor -1) (< new-floor 4))
          (let ((new-floors (floor-analysis (state-floors state) old-floor new-floor))
                (new-turn (+ 1 (state-turn state))))
            (mapcar #'(lambda (x) (list new-floor x new-turn)) new-floors))
          '())))


(defun make-moves-from (state)
  (let* ((above (move-maker #'(lambda (x) (+ x 1)) state))
         (below (move-maker #'(lambda (x) (- x 1)) state)))
    (append above below)))

(defun floor-pairs (floors)
  "This monstrosity: iterates through every floor. We set the floor number we're on
  for every element, then filter out the chips. For every chip, we make a pair of
  (chip-floor, generator-floor), then sort it into one flat list."
  (let ((hash (make-hash-table))
        (curr -1)
        (keys '()))
    (mapcar #'(lambda (floor)
                (setf curr (+ 1 curr))
                (mapcar #'(lambda (elem)
                            (setf (gethash elem hash) curr)
                            (if (microchipp elem)
                              (setf keys (cons elem keys)))) floor)) floors)
    (sort (mapcar #'(lambda (chip) 
                      (list (gethash chip hash) (gethash (its-generator chip) hash))) keys)
          #'(lambda (x y) (and (< (car x) (car y))
              (< (cadr x) (cadr y)))))))

(defun naked-state (state)
  "Don't include the turn number for when we do equality checking, and stop isomorphic gen/microchip
  checks. The 'encoding' we use for isomorphic gen/chip configs is by converting each pair of chip/generator
  as a list of pairs with their corresponding floor numbers."
  (list (state-floor state) (floor-pairs (state-floors state))))

(defun get-new-state ()
  (let* ((state (dequeue))
         (naked (naked-state state)))
    (setf (gethash naked *visited*) naked)
    state))

(defun seen-before (state)
  (gethash (naked-state state) *visited*))

(defun print-state (state)
  (format t "  Turn: ~a~%" (state-turn state))
  (format t "  Floor: ~a~%" (state-floor state))
  (format t "  ~{~a, ~}~%" (state-floors state)))

(defun traverse ()
  "Pops off the top item of the queue, makes a gaggle of new states. Checks any of them for win conditions, if so,
  return that digit. Else, add to BFS and recurse."
  (let* ((curr-state (get-new-state))
;         (x (format t "!!!!!!!!!!!!!!!!!!~%NEW STATE:~%"))
;         (y (print-state curr-state))
;         (x (format t "Turn: ~a~%" (state-turn curr-state)))
         (new-states (make-moves-from curr-state))
;         (xx (format t "~%ADDITIONAL STATES:~%"))
;         (yy (mapcar #'print-state new-states))
         (filtered (remove-if #'seen-before (remove-duplicates new-states :test #'(lambda (x y) (equalp (naked-state x) (naked-state y))))))
;         (xxx (format t "~%FILTERED STATES:~%"))
;         (yyy (mapcar #'print-state filtered))
;         (yyy (mapcar #'(lambda (x) (format t "~a~%" (naked-state x))) filtered))
;         (yyy (format t "~%"))
         (checked-for-victory (mapcar #'win-condition-or-enqueue filtered))
         (this-round (ormap checked-for-victory)))
    (if this-round
      (state-turn this-round)
      (traverse))))



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; For real logic
(enqueue *init-state*)

(let ((num-steps (traverse)))
  (format t "~a~%" num-steps))
