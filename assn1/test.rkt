#lang racket/base
(require racket/include rackunit rackunit/text-ui)
(include "a1.rkt")

;; Handle missing definitions
(define-namespace-anchor here)
(define test-ns (namespace-anchor->namespace here))
(define (maybe-binding sym)
  (parameterize ([current-namespace test-ns])
    (namespace-variable-value sym #t (lambda () #f))))
(define (with-proc sym k)
  (let ([v (maybe-binding sym)])
    (cond
      [(not v) (fail (format "~a is not defined" sym))]
      [(not (procedure? v)) (fail (format "~a is defined but is not a procedure" sym))]
      [else (k v)])))

;; Command line argument for verbosity
(define args (vector->list (current-command-line-arguments)))
(define mode
  (cond
    [(null? args) 'normal]
    [(string-ci=? (car args) "quiet")  'quiet]
    [else 'normal]))

(run-tests
  (test-suite
    "a1"
    (test-suite
      "member?"
      (test-case "ex1" (with-proc 'member? (lambda (member?-proc) (check-true (member?-proc '(4 5 (6)) '(1 2 3 (4 5 (6))))))))
      (test-case "ex2" (with-proc 'member? (lambda (member?-proc) (check-false (member?-proc 4 '(1 2 3 (4 5 (6))))))))
      (test-case "simple number" (with-proc 'member? (lambda (member?-proc) (check-true (member?-proc 1 '(1 2 3))))))
      (test-case "simple symbol" (with-proc 'member? (lambda (member?-proc) (check-true (member?-proc 'a '(b a c))))))
      (test-case "simple string" (with-proc 'member? (lambda (member?-proc) (check-true (member?-proc "hi" '("yo" "hi" "sup"))))))
      (test-case "null element absent" (with-proc 'member? (lambda (member?-proc) (check-false (member?-proc 'a '())))))
      (test-case "null element present" (with-proc 'member? (lambda (member?-proc) (check-true (member?-proc '() '(1 () 2))))))
      (test-case "nested top level list" (with-proc 'member? (lambda (member?-proc) (check-true (member?-proc '(1 2) '(1 2 3 (1 2) 4))))))
      (test-case "nested not top level" (with-proc 'member? (lambda (member?-proc) (check-false (member?-proc '(1 2) '(1 2 3 ((1 2)) 4))))))
      (test-case "nested element only" (with-proc 'member? (lambda (member?-proc) (check-false (member?-proc 2 '(1 (2) 3))))))
    )
    (test-suite
      "append-element"
      (test-case "ex1" (with-proc 'append-element (lambda (append-element-proc) (check-equal? (append-element-proc '(1 2 3) 4) '(1 2 3 4)))))
      (test-case "ex2" (with-proc 'append-element (lambda (append-element-proc) (check-equal? (append-element-proc '(1 2 3) '(4 5 6)) '(1 2 3 (4 5 6))))))
      (test-case "append null" (with-proc 'append-element (lambda (append-element-proc) (check-equal? (append-element-proc '(1 2 3) '()) '(1 2 3 ())))))
      (test-case "append to null" (with-proc 'append-element (lambda (append-element-proc) (check-equal? (append-element-proc '() 4) '(4)))))
      (test-case "append null to null" (with-proc 'append-element (lambda (append-element-proc) (check-equal? (append-element-proc '() '()) '(())))))
      (test-case "append list to null" (with-proc 'append-element (lambda (append-element-proc) (check-equal? (append-element-proc '() '(4 5 6)) '((4 5 6))))))
      (test-case "x has nested" (with-proc 'append-element (lambda (append-element-proc) (check-equal? (append-element-proc '(1 (2) 3) 4) '(1 (2) 3 4)))))
      (test-case "y has nested" (with-proc 'append-element (lambda (append-element-proc) (check-equal? (append-element-proc '(1 2 3) '(4 (5) 6)) '(1 2 3 (4 (5) 6))))))
      (test-case "single element x" (with-proc 'append-element (lambda (append-element-proc) (check-equal? (append-element-proc '(1) 2) '(1 2)))))
      (test-case "pair" (with-proc 'append-element (lambda (append-element-proc) (check-equal? (append-element-proc '(1 2 3) '(4 . 5)) '(1 2 3 (4 . 5))))))
    )
    (test-suite
      "union"
      (test-case "ex" (with-proc 'union (lambda (union-proc) (check-equal? (union-proc '(1 3 5 7 9) '(1 2 3 4 5 6 7)) '(1 3 5 7 9 2 4 6)))))
      (test-case "disjoint" (with-proc 'union (lambda (union-proc) (check-equal? (union-proc '(1 2 3) '(4 5 6)) '(1 2 3 4 5 6)))))
      (test-case "null x" (with-proc 'union (lambda (union-proc) (check-equal? (union-proc '() '(2 4 6 8 10)) '(2 4 6 8 10)))))
      (test-case "null y" (with-proc 'union (lambda (union-proc) (check-equal? (union-proc '(1 2 3 4 5 6) '()) '(1 2 3 4 5 6)))))
      (test-case "null x and y" (with-proc 'union (lambda (union-proc) (check-equal? (union-proc '() '()) '()))))
      (test-case "all match" (with-proc 'union (lambda (union-proc) (check-equal? (union-proc '(2 3 1) '(3 1 2)) '(2 3 1)))))
      (test-case "x single" (with-proc 'union (lambda (union-proc) (check-equal? (union-proc '(1) '(2 3 1 4)) '(1 2 3 4)))))
      (test-case "symbols" (with-proc 'union (lambda (union-proc) (check-equal? (union-proc '(a c e) '(b c d e)) '(a c e b d)))))
      (test-case "strings" (with-proc 'union (lambda (union-proc) (check-equal? (union-proc '("a" "b") '("b" "c")) '("a" "b" "c")))))
      (test-case "list elements" (with-proc 'union (lambda (union-proc) (check-equal? (union-proc '((1 2) (3 4)) '((1 2) (5 6))) '((1 2) (3 4) (5 6))))))
    )
    (test-suite
      "intersect"
      (test-case "ex" (with-proc 'intersect (lambda (intersect-proc) (check-equal? (intersect-proc '(1 3 5 7 9) '(1 2 3 4 5 6 7)) '(1 3 5 7)))))
      (test-case "disjoint" (with-proc 'intersect (lambda (intersect-proc) (check-equal? (intersect-proc '(1 2 3) '(4 5 6)) '()))))
      (test-case "null x" (with-proc 'intersect (lambda (intersect-proc) (check-equal? (intersect-proc '() '(4 5 6)) '()))))
      (test-case "null y" (with-proc 'intersect (lambda (intersect-proc) (check-equal? (intersect-proc '(1 2 3) '()) '()))))
      (test-case "null x and y" (with-proc 'intersect (lambda (intersect-proc) (check-equal? (intersect-proc '() '()) '()))))
      (test-case "all match" (with-proc 'intersect (lambda (intersect-proc) (check-equal? (intersect-proc '(2 3 1) '(3 1 2)) '(2 3 1)))))
      (test-case "x single" (with-proc 'intersect (lambda (intersect-proc) (check-equal? (intersect-proc '(1) '(2 3 1 4)) '(1)))))
      (test-case "symbols" (with-proc 'intersect (lambda (intersect-proc) (check-equal? (intersect-proc '(a b c d) '(c a e)) '(a c)))))
      (test-case "strings" (with-proc 'intersect (lambda (intersect-proc) (check-equal? (intersect-proc '("a" "b" "c") '("c" "a")) '("a" "c")))))
      (test-case "list elements" (with-proc 'intersect (lambda (intersect-proc) (check-equal? (intersect-proc '((1 2) (3 4) (5 6)) '((5 6) (1 2))) '((1 2) (5 6))))))
    )
  )
  mode
)
