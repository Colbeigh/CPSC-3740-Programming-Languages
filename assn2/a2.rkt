;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; TREE FUNCTIONS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; 1. tree-size
;; This function computes the total number of nodes in the tree 't'.
;; Every tree contributes 1 for its root, plus the sizes of all its subtrees.
(define (tree-size t)
  (cond
    ;; A tree always has at least a root.
    ;; The size is 1 plus the size of each subtree.
    [else
     (+ 1
        (apply +
               (map tree-size (cdr t))))]))

;; 2. tree-height
;; This function computes the height of the tree 't'.
;; The height is 1 for a leaf, otherwise 1 plus the maximum height of its subtrees.
(define (tree-height t)
  (cond
    ;; If there are no subtrees, this is a leaf.
    [(null? (cdr t)) 1]
    ;; Otherwise, take 1 plus the maximum subtree height.
    [else
     (+ 1
        (apply max
               (map tree-height (cdr t))))]))

;; 3. tree-prune
;; This function removes all nodes deeper than the given 'level'.
;; The root is considered level 1.
(define (tree-prune t level)
  (cond
    ;; If level is 1, keep only the root and remove all children.
    [(= level 1) (list (car t))]
    ;; Otherwise, keep the root and recursively prune each subtree
    ;; at one level lower.
    [else
     (cons (car t)
           (map (lambda (sub)
                  (tree-prune sub (- level 1)))
                (cdr t)))]))

;; 4. tree-level
;; This function returns a list of all labels at the given 'level'.
;; The root is considered level 1.
(define (tree-level t level)
  (cond
    ;; If level is 1, return the root label in a list.
    [(= level 1) (list (car t))]
    ;; Otherwise, recursively collect labels from subtrees
    ;; at one level lower, and append the results together.
    [else
     (apply append
            (map (lambda (sub)
                   (tree-level sub (- level 1)))
                 (cdr t)))]))

;; 5. tree-sum?
;; This function determines whether there exists a root-to-leaf path
;; whose node labels sum to 'target'.
(define (tree-sum? t target)
  (cond
    ;; Compute remaining sum after subtracting the current root.
    [else
     (let ((remaining (- target (car t))))
       (cond
         ;; If this is a leaf, check whether the remaining sum is zero.
         [(null? (cdr t)) (= remaining 0)]
         ;; Otherwise, check if ANY subtree satisfies the condition.
         [else
          (ormap (lambda (sub)
                   (tree-sum? sub remaining))
                 (cdr t))]))]))

;; 6. tree-count
;; This function counts how many times 'target' appears in the tree.
;; Each node contributes 1 if it matches, plus counts from subtrees.
(define (tree-count t target)
  (cond
    ;; Count 1 if the root matches, otherwise 0.
    [else
     (+ (if (= (car t) target) 1 0)
        (apply +
               (map (lambda (sub)
                      (tree-count sub target))
                    (cdr t))))]))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; POLYNOMIAL FUNCTIONS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; 7. poly-degree
;; This function returns the degree of polynomial 'p'.
;; The degree is the highest power present.
;; The zero polynomial '(0) has degree -inf.0.
(define (poly-degree p)
  (cond
    ;; Special case: zero polynomial.
    [(and (= (length p) 1) (= (car p) 0)) -inf.0]
    ;; Otherwise, degree is length minus 1.
    [else (- (length p) 1)]))

;; 8. poly-coeff
;; This function returns the coefficient of x^k in polynomial 'p'.
;; If k exceeds the degree, return 0.
(define (poly-coeff p k)
  (cond
    ;; If k is within the list bounds, return that coefficient.
    [(< k (length p)) (list-ref p k)]
    ;; Otherwise, coefficient is 0.
    [else 0]))

;; 9. poly-eval
;; This function evaluates polynomial 'p' at value 'a'.
;; Each coefficient contributes c * a^power.
(define (poly-eval p a)
  (define (helper coeffs power)
    (cond
      ;; No more coefficients left to process.
      [(null? coeffs) 0]
      ;; Add current term and recurse on the rest.
      [else
       (+ (* (car coeffs) power)
          (helper (cdr coeffs) (* power a)))]))
  (helper p 1))

;; 10. poly-derivative
;; This function returns the derivative of polynomial 'p'.
;; The derivative multiplies each coefficient by its power
;; and shifts powers down by one.
(define (poly-derivative p)
  (cond
    ;; If polynomial is constant, derivative is '(0).
    [(<= (length p) 1) '(0)]
    ;; Otherwise, drop the constant term and multiply
    ;; each remaining coefficient by its original power.
    [else
     (map *
          (cdr p)
          (build-list (- (length p) 1)
                      (lambda (i) (+ i 1))))]))