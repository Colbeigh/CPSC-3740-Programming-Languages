;; 1. member?
;; This function determines if an element 'x' exists within the top level of list 'y'.
(define (member? x y)
  (cond
    ;; The list 'y' is empty, thus we've looked through it all
    [(null? y) #f]
    ;; The current head matches 'x'.
    [(equal? x (car y)) #t]
    ;; The head doesn't match, recursively calls the function to check the remainder of the list
    [else (member? x (cdr y))]))

;; 2. append-element
;; This function takes a list 'x' and adds a new element 'y' to the very end of it.
(define (append-element x y)
  (cond
    ;; We've reached the end of the original list 'x', place 'y' inside a new list.
    [(null? x) (list y)]
    ;; Reconstruct the list by keeping the current head and recursing on the tail.
    ;; This allows us to "walk" to the end of the list to attach the new element.
    ;; We do this by "holding onto" the current item (car x) and tell the rest of the list 
    ;; to go find the end. Once the end is found, we glue (cons) it all back together.
    [else (cons (car x) (append-element (cdr x) y))]))

;; 3. union
;; Combines two lists, preserving order and ensuring no duplicates from 'y' are added.
(define (union x y)
  (cond
    ;; List 'y' is empty; the union is simply whatever we have in 'x'.
    [(null? y) x]
    ;; The first element of 'y' is already in 'x'. Skip it to avoid duplicates.
    [(member? (car y) x) (union x (cdr y))]
    ;; The element is unique. Add it to the end of 'x' and continue with the rest of 'y'.
    [else (union (append-element x (car y)) (cdr y))]))

;; 4. intersect
;; Filters list 'x' to keep only the elements that also appear in list 'y'.
(define (intersect x y)
  (cond
    ;; List 'x' is empty; there are no more elements to compare.
    [(null? x) '()]
    ;; The first element of 'x' exists in 'y'. Keep it and recurse.
    [(member? (car x) y) 
     (cons (car x) (intersect (cdr x) y))]
    ;; The element is not in 'y'. Discard it and check the rest of 'x'.
    [else (intersect (cdr x) y)]))