;; 1. member?
;; This function determines if a specific item 'x' exists within the top level of list 'y'.
(define (member? x y)
  (cond
    ;; Case: The list is empty. We've exhausted all elements without a match.
    [(null? y) #f]
    ;; Case: The current head (car) matches 'x' using equal?.
    [(equal? x (car y)) #t]
    ;; Case: The head doesn't match; recursively check the remainder (cdr) of the list.
    [else (member? x (cdr y))]))

;; 2. append-element
;; This function takes a list 'x' and adds a new element 'y' to the very end of it.
(define (append-element x y)
  (cond
    ;; Case: We've reached the end of the original list; place 'y' inside a new list.
    [(null? x) (list y)]
    ;; Case: Reconstruct the list by keeping the current head and recursing on the tail.
    ;; This allows us to "walk" to the end of the list to attach the new element.
    [else (cons (car x) (append-element (cdr x) y))]))

;; 3. union
;; Combines two lists, preserving order and ensuring no duplicates from 'y' are added.
(define (union x y)
  (cond
    ;; Case: List 'y' is empty; the union is simply whatever we have in 'x'.
    [(null? y) x]
    ;; Case: The first element of 'y' is already in 'x'. Skip it to avoid duplicates.
    [(member? (car y) x) (union x (cdr y))]
    ;; Case: The element is unique. Add it to the end of 'x' and continue with the rest of 'y'.
    [else (union (append-element x (car y)) (cdr y))]))

;; 4. intersect
;; Filters list 'x' to keep only the elements that also appear in list 'y'.
(define (intersect x y)
  (cond
    ;; Case: List 'x' is empty; there are no more elements to compare.
    [(null? x) '()]
    ;; Case: The first element of 'x' exists in 'y'. Keep it and recurse.
    [(member? (car x) y) 
     (cons (car x) (intersect (cdr x) y))]
    ;; Case: The element is not in 'y'. Discard it and check the rest of 'x'.
    [else (intersect (cdr x) y)]))