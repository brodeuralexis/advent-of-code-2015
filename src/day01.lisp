(defpackage :advent-day01
  (:use :cl :trivia))
(in-package :advent-day01)

(defun input ()
  (let ((content (uiop:read-file-string "./data/day01.txt")))
    (string-trim '(#\Space #\Tab #\Newline) content)))

(defun move (position move)
  (match move
    (#\( (1+ position))
    (#\) (1- position))))

(defun part1 (&optional (input (input)))
  (reduce #'move input :initial-value 0))

(defun part2 (&optional (input (input)))
  (loop :with position = 0
        :with count = 0
        :for move :across input
        :until (minusp position)
        :do (setf position (move position move))
        :do (incf count)
        :finally (return count)))
