(defsystem "advent"
  :version "0.0.1"
  :author ""
  :license ""
  :depends-on ("trivia" "trivia.ppcre" "ironclad")
  :components ((:module "src"
                :components
                ((:file "day01")
                 (:file "day02")
                 (:file "day03")
                 (:file "day04"))))
  :description ""
  :in-order-to ((test-op (test-op "advent/tests"))))
