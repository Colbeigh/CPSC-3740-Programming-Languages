#lang racket/base
(require racket/include rackunit rackunit/text-ui)
(include "a2.rkt")

(define ex-tree '(1 (2 (3) (4)) (15) (16)))
(define ex-poly '(1 0 5 2 0 3))
(run-tests
  (test-suite
    "a2"
    (test-case "tree-size" (check-equal? (tree-size ex-tree) 6))
    (test-case "tree-height" (check-equal? (tree-height ex-tree) 3))
    (test-case "tree-prune" (check-equal? (tree-prune ex-tree 2) '(1 (2) (15) (16))))
    (test-case "tree-level" (check-equal? (tree-level ex-tree 2) '(2 15 16)))
    (test-case "tree-sum?" (check-true (tree-sum? ex-tree 6)))
    (test-case "tree-count" (check-equal? (tree-count ex-tree 1) 1))
    (test-case "poly-degree" (check-equal? (poly-degree ex-poly) 5))
    (test-case "poly-coeff" (check-equal? (poly-coeff ex-poly 3) 2))
    (test-case "poly-eval" (check-equal? (poly-eval ex-poly 4) 3281))
    (test-case "poly-derivative" (check-equal? (poly-derivative ex-poly) '(0 10 6 0 15)))
  )
)
