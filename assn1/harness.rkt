#lang racket/base
(require racket/include rackunit rackunit/text-ui)
(include "a1.rkt")

(run-tests
  (test-suite
    "a1"
    (test-case "member? ex1" (check-true (member? '(4 5 (6)) '(1 2 3 (4 5 (6))))))
    (test-case "member? ex2" (check-false (member? 4 '(1 2 3 (4 5 (6))))))
    (test-case "append-element ex1" (check-equal? (append-element '(1 2 3) 4) '(1 2 3 4)))
    (test-case "append-element ex2" (check-equal? (append-element '(1 2 3) '(4 5 6)) '(1 2 3 (4 5 6))))
    (test-case "union ex" (check-equal? (union '(1 3 5 7 9) '(1 2 3 4 5 6 7)) '(1 3 5 7 9 2 4 6)))
    (test-case "intersect ex" (check-equal? (intersect '(1 3 5 7 9) '(1 2 3 4 5 6 7)) '(1 3 5 7)))
  )
)
