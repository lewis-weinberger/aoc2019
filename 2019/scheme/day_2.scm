;;;
;;; --- Day 2: 1202 Program Alarm ---
;;; 
;;; 1) To do this, before running the program, replace position 1 with the 
;;; value 12 and replace position 2 with the value 2. 
;;; What value is left at position 0 after the program halts?
;;;
;;; 2) Find the input noun and verb that cause the program to produce the
;;; output 19690720. What is 100 * noun + verb?
;;;
;;; -------------------------------------------------
;;;

(use-modules (ice-9 rdelim)) ;; read-line functionality

;; Replace Kth entry in LST with NEW
(define (replace-val lst k new)
  (if (< k (length lst))
      (cond ((null? lst) '())
	    ((= k 0) (cons new (cdr lst)))
	    (else (cons (car lst) (replace-val (cdr lst) (- k 1) new))))
      '()))
  
;; Overide positions 1 and 2 in CODE with NOUN and VERB
(define (program-alarm code noun verb)
  (replace-val (replace-val code 1 noun) 2 verb))

;; Return memory pointed to by address at position X in CODE
(define (address code x)
  (list-ref code (list-ref code x)))

;; Perform operation F on CODE at addresses in positions A, B and C
(define (op f code a b c)
  (replace-val code (list-ref code c) (f (address code a) (address code b))))

;; Execute program from CODE at instruction pointer IP
(define (run code ip)
  (if (<= ip (length code))
      (case (list-ref code ip)
	;; Intcode 1 is addition
	((1) (run (op + code (+ ip 1) (+ ip 2) (+ ip 3)) (+ ip 4)))
	;; Intcode 2 is multiplication
	((2) (run (op * code (+ ip 1) (+ ip 2) (+ ip 3)) (+ ip 4)))
	;; Intcode 99 halts the program, returning the value at address 0
	((99) (list-ref code 0))
	;; No other intcodes specified
	(else (list-ref code 0)))
      ;; Reached end of program without halting
      (list-ref code 0)))

;; Read intcode program from stdin
(define (read-code)
  (map string->number (string-split (read-line) #\,)))

;; Part 1 solution for input CODE
(define (part-one code)
  (run (program-alarm code 12 2) 0))

;; Recurse over possible nouns and verbs
(define (noun-verb-iter code noun verb)
  (if (<= verb 99)
      (if (= (run (program-alarm code noun verb) 0) 19690720)
	   (values noun verb (+ (* 100 noun) verb))
           (noun-verb-iter code noun (+ verb 1)))
      (if (<= noun 99)
	  (noun-verb-iter code (+ noun 1) 0)
	  (values "?" "?" "?"))))

;; Part 2 solution for input CODE
(define (part-two code)
  (noun-verb-iter code 0 0))

;; Print results
(define (main args)
  (let ((code (read-code)))
    ;; Part 1
    (format #t "Part 1) The value left at position 0 after the program halts = ~a\n" (part-one code))
    ;; Part 2
    (call-with-values (lambda () (part-two code))
      (lambda (a b c) (format #t "Part 2) Noun = ~a, verb = ~a, 100 * noun + verb = ~a\n" a b c)))))
