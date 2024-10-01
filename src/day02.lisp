(defpackage :advent-day02
  (:use :cl :trivia))
(in-package :advent-day02)

(defclass box ()
  ((l :type integer :initarg :l :initform 0)
   (w :type integer :initarg :w :initform 0)
   (h :type integer :initarg :h :initform 0)))

(defmethod print-object ((box box) stream)
  (print-unreadable-object (box stream :type t)
    (with-slots (l w h) box
      (format stream "~dx~dx~d" l w h))))

(defun make-box (&rest initargs)
  (apply #'make-instance 'box initargs))

(defun parse-box (line)
  (check-type line string)
  (match line
    ((trivia.ppcre:split "x" l w h)
     (make-box :l (parse-integer l)
               :w (parse-integer w)
               :h (parse-integer h)))
    (otherwise
     (error "~S is not a valid box specifier" line))))

(defmethod paper ((box box))
  (with-slots (l w h) box
    (let ((top (* l w))
          (front (* w h))
          (left (* h l)))
      (let ((wrapping (+ (* 2 top) (* 2 front) (* 2 left)))
            (slack (min top front left)))
        (+ wrapping slack)))))

(defmethod ribon ((box box))
  (with-slots (l w h) box
    (let ((perimeter (+ (* 2 l)
                        (* 2 w)
                        (* 2 h)
                        (- (* 2 (max l w h)))))
          (bow (* l w h)))
      (+ perimeter bow))))

(defun input ()
  (let ((content (uiop:read-file-lines "./data/day02.txt")))
    (mapcar #'parse-box content)))

(defun part1 (&optional (boxes (input)))
  (loop :for box :in boxes
        :sum (paper box)))

(defun part2 (&optional (boxes (input)))
  (loop :for box :in boxes
        :sum (ribon box)))
