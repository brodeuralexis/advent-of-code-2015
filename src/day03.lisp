(defpackage :advent-day03
  (:use :cl :trivia))
(in-package :advent-day03)

(defstruct pos
  (x 0 :type integer)
  (y 0 :type integer))

(defmethod delta ((pos pos) &key (x 0) (y 0))
  (make-pos :x (+ (pos-x pos) x)
            :y (+ (pos-y pos) y)))

(defmethod move ((pos pos) move)
  (match move
    (#\< (delta pos :x -1))
    (#\> (delta pos :x +1))
    (#\v (delta pos :y -1))
    (#\^ (delta pos :y +1))))

(defun make-default-map ()
  (let ((hash (make-hash-table :test 'equalp)))
    (setf (gethash (make-pos) hash) 1)
    (values hash)))

(defun map-after-input (input &key (initial-map (make-default-map)))
  (loop :with position = (make-pos)
        :with map = initial-map
        :for move :across input
        :do (setf position (move position move))
        :do (if (gethash position map)
                (incf (gethash position map))
                (setf (gethash position map) 1))
        :finally (return (hash-table-count map))))

(defun input ()
  (let ((content (uiop:read-file-string "./data/day03.txt")))
    (string-trim '(#\Space #\Tab #\Newline) content)))

(defun part1 (&optional (input (input)))
  (map-after-input input))

(defun part2 (&optional (input (input)))
  (let ((map (make-default-map)))
    (map-after-input (loop :for i :from 0 :below (length input) :by 2
                           :collect (char input i) :into list
                           :finally (return (coerce list 'string)))
                     :initial-map map)
    (map-after-input (loop :for i :from 1 :below (length input) :by 2
                           :collect (char input i) :into list
                           :finally (return (coerce list 'string)))
                     :initial-map map)
    (hash-table-count map)))
