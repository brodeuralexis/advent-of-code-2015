(defpackage :advent-day04
  (:use :cl :trivia))
(in-package :advent-day04)

(defun md5 (string)
  (let ((digester (ironclad:make-digest :md5)))
    (ironclad:update-digest digester (ironclad:ascii-string-to-byte-array string))
    (ironclad:byte-array-to-hex-string (ironclad:produce-digest digester))))

(defun mine (input &key (difficulty 5))
  (loop :for i :from 1
        :for suffix = (write-to-string i)
        :for hash = (md5 (concatenate 'string input suffix))
        :until (equalp (subseq hash 0 difficulty)
                       (make-string difficulty :initial-element #\0))
        :finally (return i)))

(defun input ()
  (let ((content (uiop:read-file-string "./data/day04.txt")))
    (string-trim '(#\Space #\Tab #\Newline) content)))

(defun part1 (&optional (input (input)))
  (mine input))

(defun part2 (&optional (input (input)))
  (mine input :difficulty 6))
