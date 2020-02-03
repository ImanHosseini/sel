;;;; javascript-project.lisp --- Javascript project.
(defpackage :software-evolution-library/test/javascript-project
  (:nicknames :sel/test/javascript-project)
  (:use
   :common-lisp
   :alexandria
   :closer-mop
   :software-evolution-library/test/util
   :software-evolution-library/stefil-plus
   :named-readtables
   :curry-compose-reader-macros
   :iterate
   :split-sequence
   :cl-ppcre
   #+gt :testbot
   :software-evolution-library
   :software-evolution-library/utility)
  (:import-from :uiop :nest)
  (:shadowing-import-from
   :closer-mop
   :standard-method :standard-class :standard-generic-function
   :defmethod :defgeneric)
  (:export :javascript-project))
(in-package :software-evolution-library/test/javascript-project)
(in-readtable :curry-compose-reader-macros)
(defsuite javascript-project)

(deftest (can-parse-a-javascript-project :long-running) ()
  (with-fixture fib-project-javascript
    (is (equal 2 (length (evolve-files *soft*))))
    (is (not (null (asts *soft*))))))

(deftest (javascript-project-instrument-uninstrument-is-identity
          :long-running) ()
  (with-fixture fib-project-javascript
    (is (string= (genome *soft*)
                 (genome (uninstrument (instrument (copy *soft*))))))))

(deftest (javascript-project-instrument-and-collect-traces :long-running) ()
  (with-fixture fib-project-javascript
    (let ((instrumented (instrument *soft*)))
      (collect-traces instrumented
                      (make-instance 'test-suite :test-cases
                                     (list (make-instance 'test-case
                                             :program-name (namestring
                                                            (javascript-dir
                                                             #P"fib-project/test.sh"))
                                             :program-args (list :bin "1")))))
      (is (equal 1 (n-traces (traces instrumented))))
      (is (equalp '(((:C . 0)  (:F . 1))
                    ((:C . 0)  (:F . 0))
                    ((:C . 6)  (:F . 1))
                    ((:C . 12) (:F . 1))
                    ((:C . 29) (:F . 1))
                    ((:C . 48) (:F . 1))
                    ((:C . 55) (:F . 1))
                    ((:C . 70) (:F . 1))
                    ((:C . 11) (:F . 0))
                    ((:C . 20) (:F . 0))
                    ((:C . 25) (:F . 0))
                    ((:C . 29) (:F . 0))
                    ((:C . 35) (:F . 0))
                    ((:C . 39) (:F . 0))
                    ((:C . 42) (:F . 0)))
                  (aget :trace (get-trace (traces instrumented) 0)))))))

(deftest (javascript-project-instrument-and-collect-traces-with-vars
          :long-running) ()
  (with-fixture fib-project-javascript
    (let ((instrumented
           (instrument *soft*
                       :functions
                       (list (lambda (instrumenter ast)
                               (var-instrument
                                {get-vars-in-scope (software instrumenter)}
                                instrumenter
                                ast))))))
      (collect-traces instrumented
                      (make-instance 'test-suite :test-cases
                                     (list (make-instance 'test-case
                                             :program-name (namestring
                                                            (javascript-dir
                                                             #P"fib-project/test.sh"))
                                             :program-args (list :bin "1")))))
      (is (equal 1 (n-traces (traces instrumented))))
      (is (equalp '((:C . 29)(:F . 0)(:SCOPES #("temp" "number" 1 nil)
                                      #("b" "number" 0 nil)
                                      #("a" "number" 1 nil)
                                      #("num" "number" 1 nil)))
                  (nth 11 (aget :trace
                                (get-trace (traces instrumented) 0))))))))
