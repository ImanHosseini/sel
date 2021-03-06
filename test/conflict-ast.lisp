;;;; conflict-ast.lisp --- Conflict ast tests.
(defpackage :software-evolution-library/test/conflict-ast
  (:nicknames :sel/test/conflict-ast)
  (:use
   :gt/full
   #+gt :testbot
   :software-evolution-library/test/util
   :software-evolution-library/stefil-plus
   :software-evolution-library
   :software-evolution-library/software/parseable)
  (:export :test-conflict-ast))
(in-package :software-evolution-library/test/conflict-ast)
(in-readtable :curry-compose-reader-macros)
(defsuite test-conflict-ast "Conflict ast tests.")

(deftest conflict-ast.1 ()
  (let ((c1 (make-conflict-ast
             :child-alist '((1 a) (2 b))
             :default-children '(c)))
        (c2 (make-conflict-ast
             :child-alist '((2 d) (3 e))
             :default-children '(f))))
    (let ((c (combine-conflict-asts c1 c2)))
      (is (equalp (conflict-ast-child-alist c)
                  '((1 a f) (2 b d) (3 c e)))
          "conflict ast alists are merged")
      (is (equalp (conflict-ast-default-children c) '(c f))
          "conflict ast defaults are merged"))))
