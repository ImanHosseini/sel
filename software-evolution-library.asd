(defsystem :software-evolution-library
  :description "programmatic modification and evaluation of extant software"
  :long-description "A common interface abstracts over multiple
types of software objects including abstract syntax trees parsed from
source code, LLVM IR, compiled assembler, and linked ELF binaries.
Mutation and evaluation methods are implemented on top of this
interface supporting Search Based Software Engineering (SBSE)
techniques."
  :version "0.0.0"
  :licence "GPL V3"
  ;; :homepage "http://GrammaTech.github.io/sel"
  :depends-on (alexandria
               closer-mop
               uiop
               bordeaux-threads
               cl-arrows
               cl-custom-hash-table
               cl-json
               cl-ppcre
               cl-fad
               curry-compose-reader-macros
               diff
               elf
               iterate
               metabang-bind
               software-evolution-library-utility
               split-sequence
               usocket
               trivial-utf-8
               fast-io
               trace-db)
  :in-order-to ((test-op (test-op software-evolution-library-test)))
  :components
  ((:module base
            :pathname ""
            :components
            ((:file "package")
             (:file "software-evolution-library" :depends-on ("package"))))
   (:module software
            :depends-on (base)
            :pathname "software"
            :components
            ((:file "lisp")
             (:file "expression" :depends-on ("lisp"))
             (:file "simple")
             (:file "diff" :depends-on ("simple"))
             (:file "asm"  :depends-on ("simple"))
             (:file "csurf-asm" :depends-on ("asm"))
             (:file "elf"  :depends-on ("diff"))
             (:file "elf-cisc" :depends-on ("elf"))
             (:file "elf-risc" :depends-on ("elf"))
             (:file "elf-mips" :depends-on ("elf-risc"))
             (:file "ast")
             (:file "cil" :depends-on ("ast"))
             (:file "clang" :depends-on ("ast"))
             (:file "clang-expression" :depends-on ("clang" "expression"))
             (:file "clang-w-fodder" :depends-on ("clang"))
             (:file "llvm" :depends-on ("ast"))
             (:file "project")
             (:file "clang-project" :depends-on ("project" "clang"))))
   (:module src
            :depends-on (base software)
            :pathname "src"
            :components
            ((:file "ancestral")
             (:file "clang-instrument")
             (:file "traceable" :depends-on ("test-suite"))
             (:file "fix-compilation")
             (:file "adaptive-mutation")
             (:file "searchable")
             (:file "fodder-database" :depends-on ("searchable"))
             (:file "in-memory-fodder-database" :depends-on ("fodder-database"))
             (:file "json-fodder-database" :depends-on ("in-memory-fodder-database"))
             (:file "lexicase")
             (:file "pliny-fodder-database" :depends-on ("fodder-database"))
             (:file "test-suite")
             (:file "condition-synthesis" :depends-on ("test-suite"))
             (:file "fault-loc" :depends-on ("test-suite"))
             (:file "generate-helpers")
             (:file "style-features")
             (:file "multi-objective")
             (:file "clang-tokens")))))