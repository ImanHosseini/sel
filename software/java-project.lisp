;;; Specialization for building a software object from a java project
;;;
;;; Implements the core functionality of the software-evolution-library
;;; for class files written in java. The java versions that are supported
;;; relies heavily on an input's success of parsing individual files with
;;; @uref{http://javaparser.org/, Java Parser}.
;;;
;;; The project will use jar files to extract which files need to be
;;; initialized in this context. A java-project will contain relative
;;; path names and the corresponding software object, stored in
;;; evolve-files. Naturally, the java software object is used in this
;;; implementation.
;;;
;;; The core functionality is supported by the command line tool
;;; @uref{https://github.com/GrammaTech/java-mutator, java-mutator}.
;;;
;;; @texi{java-project}
(in-package :software-evolution-library)
(in-readtable :curry-compose-reader-macros)

(define-software java-project (project)
  ((project-dir :initarg :project-dir
                :accessor project-dir
                :initform nil
                :documentation "Source directory containing the project")
   (java-class  :initarg :java-class
                :accessor java-class
                :initform 'java
                :documentation "Java subclass to utilize in the project")))

(defmethod from-file ((obj java-project) project-dir)
  "Build project and extract relevant java source files."
  (setf (project-dir obj) project-dir)
  (with-temp-build-dir (project-dir)
    (multiple-value-bind (stdout stderr exit-code)
        (shell "cd ~a && ~a" *build-dir* (build-command obj))
      (if (not (zerop exit-code))
          (error "Failed to build java project for project.~%~
                  build-command: ~a~%~
                  stdout: ~a~%~
                  stderr: ~a~%"
                 (build-command obj)
                 stdout stderr)
          (setf (evolve-files obj)
                (iter (for entry in
                           (->> (merge-pathnames-as-file
                                 *build-dir*
                                 ;; FIXME: The following artificially
                                 ;; limits Java projects to a single
                                 ;; build artifact and should be
                                 ;; generalized as in
                                 ;; clang-project.lisp.
                                 (first (artifacts obj)))
                                (get-applicable-project-files project-dir)
                                (mapcar
                                 (lambda (file)
                                   (replace-all
                                    file
                                    (namestring
                                     (ensure-directory-pathname project-dir))
                                    "")))))
                      (for i upfrom 1)
                      (handler-case
                          (let ((java-obj (from-file
                                           (make-instance (java-class obj))
                                           (merge-pathnames-as-file
                                            *build-dir*
                                            entry))))
                            (if (not (zerop (size java-obj)))
                                (collect (cons entry java-obj))
                                (warn "Ignoring file ~a with 0 statements"
                                      entry)))
                        (mutate (e)
                          (declare (ignorable e))
                          (warn "Ignoring file ~a, failed to initialize"
                                entry))))))))
  obj)

(defmethod to-file ((java-project java-project) path)
  (let ((*build-dir* (make-build-dir (project-dir java-project) :path path)))
    (write-genome-to-files java-project)))

(defun get-filename (path)
  "Return filename of a path"
  (pathname-name (pathname path)))

(defun extract-filename-list (pathList)
  "Return a list of filenames for a list of full paths"
  (mapcar #'get-filename pathList))

(defun extract-jars-in-jar (folder jar-name)
  "Extracts jars within the jar passed to the function
and returns the list of jars extracted for the next
extraction iteration"
  (let ((jar-files (run-command-split-newline
                     (format nil "jar tf ~a/~a | grep -o '[^/]*.jar$'"
                             folder
                             jar-name))))
    (when jar-files
      (shell "unzip -jo ~a/~a '*\.jar' -d ~a" folder jar-name folder))
    jar-files))

(defun get-files-project-folder (project-path)
  "Returns a list of all files with ext java"
  (multiple-value-bind (stdout stderr errno)
      (shell "find ~a -type f -name '*\.java'" project-path)
    (declare (ignorable stderr errno))
    (unless (emptyp (trim-whitespace stdout))
      (split-sequence #\Newline
        (string-trim '(#\Newline) stdout)))))

(defun get-files-with-ext-in-dir (folder ext)
  "Returns a list of file paths with the ext file extension"
  (run-command-split-newline
    (format nil "find ~a -type f -name '*\.~a'" folder ext)))

(defun run-command-split-newline (command)
  "Executes a command and splits output by newline"
  (let ((stdout-str (make-array '(0)
                                :element-type
                                #+sbcl 'extended-char
                                #-sbcl 'character
                                :fill-pointer 0 :adjustable t)))
    (with-output-to-string (stdout stdout-str)
        (run-program command
                     :force-shell t
                     :ignore-error-status t
                     :output stdout)
      (unless (emptyp (trim-whitespace stdout-str))
        (split-sequence #\Newline (string-trim '(#\Newline) stdout-str))))))

(defun get-files-jar (jar-path)
  "Returns a list of class files in a jar or directory.
Jars within jars are recursivly extracted
to the depth of 3 within the built jar"
  (with-temp-dir (sandbox)
    (let ((jar-paths
           (if (directory-exists-p jar-path)
               (get-files-with-ext-in-dir jar-path "jar")
               (list jar-path))))
      (shell "cp ~{~a~^ ~} ~a" jar-paths sandbox)
      (iter (with paths = (iter (for path in jar-paths)
                                (collect
                                    (format nil "~a.~a"
                                            (pathname-name (pathname path))
                                            (pathname-type (pathname path))))))
            (for i from 1 to 4)
            (setf paths
                  (iter (for path in paths)
                        (appending (extract-jars-in-jar sandbox path)))))

      (iter (for jar-file in (get-files-with-ext-in-dir sandbox "jar"))
            (appending
             (extract-filename-list
              (run-command-split-newline
               (format nil
                       "jar tf ~a | grep -o '[^/]*.class$'"
                       jar-file))))))))

(defun compare-file-lists (jar-files project-files)
  "Compare the lists, returns full path list if filename is in both lists"
  (iter (for path in project-files)
        (when (find (get-filename path) jar-files :test #'equal)
          (collect path))))

(defun get-applicable-project-files (project-path jar-path)
  "Get list of files that are both in project folder and in jar"
  (compare-file-lists (get-files-jar jar-path)
                      (get-files-project-folder project-path)))

(defmethod astyle ((java-project java-project) &optional style options)
  (declare (ignorable style options))
  java-project)
