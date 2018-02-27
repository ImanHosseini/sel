(defpackage :software-evolution-library
  (:nicknames :sel)
  (:use
   :alexandria
   :closer-mop
   :uiop
   :bordeaux-threads
   :common-lisp
   :cl-arrows
   :cl-custom-hash-table
   :cl-fad
   :cl-ppcre
   :cl-store
   :named-readtables
   :curry-compose-reader-macros
   :diff
   :elf
   :iterate
   :metabang-bind
   :split-sequence
   :software-evolution-library/utility
   :usocket
   :fast-io
   :trace-db)
  (:shadow :elf :size :type :magic-number :diff :insert :index)
  (:shadowing-import-from :software-evolution-library/utility :quit)
  (:shadowing-import-from :uiop :getenv)
  (:shadowing-import-from :iterate :iter :for :until :collecting :in)
  (:shadowing-import-from
   :closer-mop
   :standard-method :standard-class :standard-generic-function
   :defmethod :defgeneric)
  (:shadowing-import-from
   :alexandria
   :appendf :ensure-list :featurep :emptyp
   :if-let :ensure-function :ensure-gethash :copy-file :copy-stream
   :parse-body :simple-style-warning)
  (:shadowing-import-from
   :cl-fad
   :pathname-as-directory :directory-exists-p
   :pathname-directory-pathname :pathname-root-p
   :merge-pathnames-as-directory :merge-pathnames-as-file
   :pathname-parent-directory :pathname-equal
   :directory-pathname-p :file-exists-p)
  (:export
   :+software-evolution-library-version+
   :+software-evolution-library-branch+
   ;; software objects
   :software
   :define-software
   :edits
   :fitness
   :fitness-extra-data
   :mutation-stats
   :*mutation-improvements*
   :genome
   :phenome
   :phenome-p
   :ignore-phenome-errors
   :return-nil-for-bin
   :retry-project-build
   :evaluate
   :copy
   :size
   :lines
   :line-breaks
   :genome-string
   :tokens
   :headers
   :macros
   :includes
   :types
   :globals
   :ancestral
   :ancestors
   :pick
   :pick-good
   :pick-bad
   :pick-snippet
   :pick-guarded-compound
   :mutation-targets
   :good-mutation-targets
   :bad-mutation-targets
   :mutate
   :no-mutation-targets
   :pick-mutation-type
   :clang-mutation
   :build-op
   :apply-mutation-ops
   :apply-mutation
   :apply-mutations
   :apply-all-mutations
   :apply-picked-mutations
   :text
   :obj
   :op
   :*mutation-stats*
   :*crossover-stats*
   :analyze-mutation
   :mutation-key
   :summarize-mutation-stats
   :classify
   :crossover
   :one-point-crossover
   :two-point-crossover
   :*edit-consolidation-size*
   :*consolidated-edits*
   :*edit-consolidation-function*
   :edit-distance
   :from-file
   :from-file-exactly
   :from-string
   :apply-config
   :ext
   :get-vars-in-scope
   :bind-free-vars
   :prepare-sequence-snippet
   :prepare-inward-snippet
   :create-inward-snippet
   :crossover-2pt-inward
   :crossover-2pt-outward
   :intraprocedural-2pt-crossover
   :select-crossover-points
   :function-containing-ast
   :function-body-p
   :function-decl-p
   :adjust-stmt-range
   :random-point-in-function
   :select-intraprocedural-pair
   :indent
   :clang-tidy
   :clang-format
   :clang-mutate
   :update-headers-from-snippet
   :to-file
   :apply-path
   :expression
   :expression-intern
   :expression-to-c
   :mutation
   :define-mutation
   :compose-mutations
   :sequence-mutations
   :object
   :targeter
   :picker
   :targets
   :get-targets
   :at-targets
   :compiler
   :prototypes
   :functions
   :get-entry
   :ast
   :asts
   :stmt-asts
   :non-stmt-asts
   :good-stmts
   :bad-stmts
   :update-asts
   :source-location
   :line
   :column
   :asts-containing-source-location
   :asts-contained-in-source-range
   :asts-intersecting-source-range
   :ast-to-source-range
   :get-ast
   :get-parent-ast
   :get-parent-asts
   :parent-ast-p
   :get-parent-full-stmt
   :wrap-ast
   :wrap-child
   :can-be-made-traceable-p
   :get-make-parent-full-stmt
   :get-immediate-children
   :extend-to-enclosing
   :get-ast-info
   :+c-numeric-types+
   :+c-relational-operators+
   :+c-arithmetic-binary-operators+
   :+c-arithmetic-assignment-operators+
   :+c-bitwise-binary-operators+
   :+c-bitwise-assignment-operators+
   :+c-arithmetic-unary-operators+
   :+c-bitwise-unary-operators+
   :+c-sign-unary-operators+
   :+c-pointer-unary-operators+
   :ast-declarations
   :declared-type
   :find-var-type
   :typedef-type
   :random-function-name
   :replace-fields-in-snippet
   ;; global variables
   :*population*
   :*generations*
   :*max-population-size*
   :*tournament-size*
   :*tournament-eviction-size*
   :*fitness-predicate*
   :fitness-better-p
   :fitness-equal-p
   :*cross-chance*
   :*mut-rate*
   :*fitness-evals*
   :*running*
   :*start-time*
   :elapsed-time
   ;; simple / asm global variables
   :*simple-mutation-types*
   :*asm-linker*
   :*asm-mutation-types*
   ;; adaptive software
   :adaptive-mutation
   :*bias-toward-dynamic-mutation*
   :*better-bias*
   :*same-bias*
   :*worse-bias*
   :*dead-bias*
   :adaptive-analyze-mutation
   :update-mutation-types
   ;; clang / clang-w-fodder global variables
   :searchable
   :fodder-database
   :in-memory-database
   :json-database
   :pliny-database
   :db
   :host
   :port
   :database-emptyp
   :source-collection
   :cache-collection
   :middle-host
   :middle-port
   :find-snippets
   :weighted-pick
   :find-type
   :find-macro
   :similar-snippets
   :*clang-max-json-size*
   :*crossover-function-probability*
   :*clang-mutation-types*
   :*clang-w-fodder-mutation-types*
   :*clang-w-fodder-new-mutation-types*
   :*free-var-decay-rate*
   :*matching-free-var-retains-name-bias*
   :*matching-free-function-retains-name-bias*
   :*allow-bindings-to-globals-bias*
   :*clang-json-required-fields*
   :*clang-json-required-aux*
   *clang-ast-aux-fields*
   :*database*
   :*mmm-processing-seconds*
   ;; evolution functions
   :incorporate
   :evict
   :default-select-best
   :default-random-winner
   :*tournament-selector*
   :*tournament-tie-breaker*
   :*tie-breaker-predicate*
   :tournament
   :mutant
   :crossed
   :new-individual
   :mcmc
   :mcmc-step
   :*mcmc-fodder*
   :evolve
   :generational-evolve
   ;; software backends
   :simple
   :light
   :sw-range
   :diff
   :original
   :asm
   :csurf-asm
   :*dynamic-linker-path*
   :*elf-copy-redirect-path*
   :*elf-edit-symtab-path*
   :elf
   :elf-cisc
   :elf-csurf
   :elf-x86
   :elf-arm
   :elf-risc
   :elf-mips
   :genome-bytes
   :pad-nops
   :nop-p
   :forth
   :lisp
   :constant-fold
   :random-subtree
   :clang
   :clang-w-fodder
   :clang-w-binary
   :clang-w-fodder-and-binary
   :bytes
   :diff-data
   :recontextualize
   :delete-decl-stmts
   :rename-variable-near-use
   :run-cut-decl
   :run-swap-decls
   :run-rename-variable
   :common-ancestor
   :ancestor-of
   :get-fresh-ancestry-id
   :save-ancestry
   :scopes-between
   :nesting-depth
   :full-stmt-p
   :block-p
   :guard-p
   :enclosing-full-stmt
   :enclosing-block
   :nesting-relation
   :match-nesting
   :block-predeccessor
   :block-successor
   :show-full-stmt
   :full-stmt-info
   :prepare-code-snippet
   :get-children-using
   :get-declared-variables
   :cil
   :llvm
   :linker
   :flags
   :addr-map
   :assembler
   :asm-flags
   :redirect-file
   :weak-symbols
   :elf-risc-max-displacement
   :ops                      ; <- might want to fold this into `lines'
   ;; software backend specific methods
   :reference
   :base
   :disasm
   :addresses
   :instrumented-p
   :instrument
   :instrumenter
   :clang-instrumenter
   :uninstrument
   :var-instrument
   :+instrument-log-variable-name+
   :+instrument-log-lock-variable-name+
   :add-include
   :force-include
   :add-type
   :find-or-add-type
   :type-decl-string
   :add-macro
   :prepend-to-genome
   :nullify-asts
   :keep-partial-asts
   :retry-mutation
   :expand-stmt-pool
   :ignore-failed-mutation
   :try-another-mutation
   :fix-compilation
   :generational-evolve
   :simple-reproduce
   :simple-evaluate
   :simple-select
   :*target-fitness-p*
   :*worst-fitness-p*
   :worst-numeric-fitness
   :worst-numeric-fitness-p
   :*fitness-scalar-fn*
   :fitness-scalar
   :lexicase-select
   :lexicase-select-best
   :*lexicase-key*
   :pareto-selector
   :*pareto-comparison-set-size*
   :multi-objective-scalar
   :pick-least-crowded
   :mutation
   :targets
   :simple-cut
   :simple-insert
   :simple-swap
   :asm-replace-operand
   :asm-nth-instruction
   :asm-split-instruction
   :number-genome
   :homologous-crossover
   :clang-cut
   :clang-cut-same
   :clang-cut-full
   :clang-cut-full-same
   :clang-insert
   :clang-insert-same
   :clang-insert-full
   :clang-insert-full-same
   :clang-swap
   :clang-swap-same
   :clang-swap-full
   :clang-swap-full-same
   :clang-move
   :clang-replace
   :clang-replace-same
   :clang-replace-full
   :clang-replace-full-same
   :clang-promote-guarded
   :clang-nop
   :clang-instrument
   :explode-for-loop
   :coalesce-while-loop
   :cut-decl
   :swap-decls
   :rename-variable
   :expand-arithmatic-op
   :replace-fodder-same
   :replace-fodder-full
   :insert-fodder-decl
   :insert-fodder-decl-rep
   :insert-fodder
   :insert-fodder-full
   :pick-bad-good
   :pick-bad-bad
   :pick-bad-only
   :full-stmt-filter
   :same-class-filter
   :*lisp-mutation-types*
   :lisp-cut
   :lisp-replace
   :lisp-swap
   :change-operator
   :change-constant
   :clang-expression
   :scope
   :mult-divide
   :add-subtract
   :subtract-add
   :add-subtract-tree
   :subtract-add-tree
   :add-subtract-scope
   :evaluate-expression
   :demote-binop-left
   :demote-binop-right
   :eval-error
   :project
   :apply-to-project
   :build-command
   :build-target
   :current-file
   :with-current-file
   :evolve-files
   :other-files
   :instrumentation-files
   :all-files
   :write-genome-to-files
   :with-build-dir
   :with-temp-build-dir
   :make-build-dir
   :full-path
   :*build-dir*
   :clang-project
   :project-dir
   :compilation-database
   :test-suite
   :test-cases
   :test-case
   :program-name
   :program-args
   :process
   :os-process
   :process-id
   :process-input-stream
   :process-output-stream
   :process-error-stream
   :process-exit-code
   :process-status
   :signal-process
   :start-test
   :finish-test
   :run-test
   :instrumentation-exprs
   :synthesize-condition
   :synthesize-conditions
   :find-best-condition
   :add-condition
   :tighten-condition
   :loosen-condition
   :refine-condition
   :valid-targets
   :if-to-while
   :if-to-while-tighten-condition
   :insert-else-if
   :*abst-cond-attempts*
   :*synth-condition-attempts*
   :stmts-in-file
   :error-funcs
   :rinard
   :rinard-compare
   :rinard-incremental
   :rinard-write-out
   :rinard-read-in
   :collect-fault-loc-traces
   :generate-helpers
   :clang-ast
   :ast-args
   :ast-children
   :ast-class
   :ast-counter
   :ast-declares
   :ast-expr-type
   :ast-full-stmt
   :ast-guard-stmt
   :ast-in-macro-expansion
   :ast-includes
   :ast-is-decl
   :ast-macros
   :ast-name
   :ast-opcode
   :ast-ret
   :ast-syn-ctx
   :ast-varargs
   :ast-void-ret
   :ast-array-length
   :ast-base-type
   :ast-bit-field-width
   :ast-aux-data
   :clang-type
   :copy-clang-ast
   :make-clang-ast
   :type-array
   :type-col
   :type-decl
   :type-file
   :type-hash
   :type-i-col
   :type-i-file
   :type-i-line
   :type-line
   :type-pointer
   :type-const
   :type-volatile
   :type-restrict
   :type-storage-class
   :type-reqs
   :type-name
   :type-size
   :make-clang-type
   :macro-name
   :macro-body
   :macro-hash
   :make-clang-macro
   :roots
   :ast->snippet
   :snippet->clang-ast
   :snippet->clang-type
   :snippet->clang-macro
   :source-text
   :function-body
   :stmt-range
   :get-ast-types
   :get-unbound-vals
   :get-unbound-funs
   :scopes
   :ast-ref
   :make-ast-ref
   :ast-ref-path
   :ast-ref-ast
   :index-of-ast
   :ast-at-index
   :ast-later-p
   :make-statement
   :make-literal
   :make-operator
   :make-block
   :make-parens
   :make-while-stmt
   :make-for-stmt
   :make-if-stmt
   :make-var-reference
   :make-var-decl
   :make-cast-expr
   :make-call-expr
   :make-array-subscript-expr
   :make-label
   :ast-root
   :replace-in-ast
   :parse-source-snippet
   :prepare-fodder
   ;; traceable
   :traceable
   :traces
   :collect-trace
   :collect-traces
   :read-trace-file
   :read-trace-stream
   :type-decl-string
   :type-trace-string
   :type-from-trace-string
   :trace-error
   :bin
   ;; style features
   :style-feature
   :feature-name
   :extractor-fn
   :merge-fn
   :styleable
   :features
   :feature-vecs
   :feature-vec-meta
   :style-project
   :define-feature
   :diff-feature-vectors
   :extract-features
   :extract-baseline-features
   :merge-styleables
   :ast-node-type-tf-extractor
   :max-depth-ast-extractor
   :avg-depth-ast-extractor
   :ast-node-type-avg-depth-extractor
   :ast-full-stmt-bi-grams-extractor
   :ast-bi-grams-extractor
   :ast-keyword-tf-extractor
   :*feature-extractors*
   :ast-node-type-tf-feature
   :max-depth-ast-feature
   :avg-depth-ast-feature
   :ast-node-type-avg-depth-feature
   :ast-full-stmt-bi-grams-feature
   :ast-bi-grams-feature
   :ast-keyword-tf-feature
   :merge-normalized
   :merge-max
   :merge-means
   :uni-grams
   :to-feature-vector
   :normalize-vector
   :ast-node-types
   :ast-depth
   :max-depth-ast
   :all-ast-node-types
   :bi-grams
   :bi-grams-hashtable-to-feature
   :all-keywords
   :extract-feature
   :update-project-features ))
#+allegro
(set-dispatch-macro-character #\# #\_
                              #'(lambda (s c n) (declare (ignore s c n)) nil))
