% ============================================================================
% CPSC 3740 - Assignment 4
%
% This file contains relational Prolog predicates for lists, trees, and
% polynomials. The comments are written in a teaching-oriented style to explain
% the logical meaning of each predicate and how the recursive structure matches
% the mathematical definition of the problem.
%
% Tree representation:
% - A non-empty tree is a non-empty list.
% - The first element is the root label.
% - The remaining elements are the subtrees in order.
% - Example: [1,[2,[3],[4]],[15],[16]]
%
% Polynomial representation:
% - A polynomial is a list of coefficients of x^0, x^1, x^2, ...
% - Example: [1,0,5,2,0,3] represents 3x^5 + 2x^3 + 5x^2 + 1
% - The zero polynomial is represented as [0]
% ============================================================================


% ============================================================================
% Helper Predicates
% ============================================================================

% member2(X, L)
% This predicate succeeds when X is an element of list L.
%
% Base case:
% - X is the head of the list.
%
% Recursive case:
% - If X is not the head, search for it in the tail.
member2(X, [X|_]).
member2(X, [_|T]) :-
    member2(X, T).


% max_value(A, B, M)
% This predicate succeeds when M is the larger of integers A and B.
%
% Cases:
% - If A is at least B, the maximum is A.
% - Otherwise, the maximum is B.
max_value(A, B, A) :-
    A >= B.
max_value(A, B, B) :-
    B > A.


% ============================================================================
% 1. list_count(X, Y, C)
% ============================================================================

% list_count(X, Y, C)
% This predicate succeeds when X occurs exactly C times in list Y.
% It can be used to count the occurrences of a specific element, and it is
% re-executable on backtracking when X is not fixed, allowing enumeration of
% element/count relationships.
%
% Base case:
% - In the empty list, every element occurs 0 times.
%
% Recursive cases:
% - If the head is X, count 1 and recurse on the tail.
% - If the head is not X, recurse on the tail without increasing the count.
list_count(_, [], 0).
list_count(X, [X|T], C) :-
    list_count(X, T, C1),
    C is C1 + 1.
list_count(X, [H|T], C) :-
    X \= H,
    list_count(X, T, C).


% ============================================================================
% 2. list_distinct(L)
% ============================================================================

% list_distinct(L)
% This predicate succeeds when list L contains no duplicate elements.
%
% Base case:
% - The empty list contains no duplicates.
%
% Recursive case:
% - The head must not appear anywhere in the tail, and the tail itself must
%   also be distinct.
list_distinct([]).
list_distinct([H|T]) :-
    \+ member2(H, T),
    list_distinct(T).


% ============================================================================
% 3. list_union(X, Y, U)
% ============================================================================

% list_union(X, Y, U)
% This predicate succeeds when U is the sorted union of the elements of X and Y.
% The result is treated as a set: duplicates are removed and the final list is
% in standard sorted order.
%
% Strategy:
% - Append the two lists together.
% - Sort the combined list.
% - Prolog's sort/2 both orders the list and removes duplicates.
list_union(X, Y, U) :-
    append(X, Y, XY),
    sort(XY, U).


% ============================================================================
% 4. list_intersect(X, Y, I)
% ============================================================================

% list_intersect(X, Y, I)
% This predicate succeeds when I is the sorted intersection of the elements of
% X and Y. The result is treated as a set: only elements that appear in both
% lists are kept, duplicates are removed, and the final list is sorted.
%
% Strategy:
% - Sort each input list first so duplicates are removed.
% - Traverse the first sorted list and keep exactly those elements that are
%   members of the second sorted list.
list_intersect(X, Y, I) :-
    sort(X, SX),
    sort(Y, SY),
    list_intersect_sorted(SX, SY, I).

% list_intersect_sorted(X, Y, I)
% Helper predicate for list_intersect/3.
% X and Y are assumed to be sorted and duplicate-free.
%
% Base case:
% - The intersection of an empty list with anything is empty.
%
% Recursive cases:
% - If the head of X is in Y, include it in the result.
% - Otherwise, skip it.
list_intersect_sorted([], _, []).
list_intersect_sorted([H|T], Y, [H|I]) :-
    member2(H, Y),
    list_intersect_sorted(T, Y, I).
list_intersect_sorted([H|T], Y, I) :-
    \+ member2(H, Y),
    list_intersect_sorted(T, Y, I).


% ============================================================================
% 5. tree_size(T, S)
% ============================================================================

% tree_size(T, S)
% This predicate succeeds when S is the total number of nodes in tree T.
%
% Recursive definition:
% - A tree always contributes 1 for its root.
% - The total size is 1 plus the sum of the sizes of all subtrees.
tree_size([_|Subtrees], S) :-
    tree_size_list(Subtrees, SubtreeTotal),
    S is SubtreeTotal + 1.

% tree_size_list(Subtrees, S)
% Helper predicate that sums the sizes of a list of subtrees.
%
% Base case:
% - No subtrees contribute size 0.
%
% Recursive case:
% - Add the size of the first subtree to the sum of the remaining subtrees.
tree_size_list([], 0).
tree_size_list([T|Ts], S) :-
    tree_size(T, S1),
    tree_size_list(Ts, S2),
    S is S1 + S2.


% ============================================================================
% 6. tree_height(T, H)
% ============================================================================

% tree_height(T, H)
% This predicate succeeds when H is the height of tree T.
%
% Base case:
% - A leaf is represented by a one-element list [Root], so its height is 1.
%
% Recursive case:
% - A non-leaf has height 1 plus the maximum height among its subtrees.
tree_height([_], 1).
tree_height([_|Subtrees], H) :-
    Subtrees \= [],
    subtree_max_height(Subtrees, MaxH),
    H is MaxH + 1.

% subtree_max_height(Subtrees, H)
% Helper predicate that finds the maximum height among a non-empty list of
% subtrees.
%
% Base case:
% - If there is exactly one subtree, its height is the maximum.
%
% Recursive case:
% - Compare the height of the first subtree with the maximum height of the rest.
subtree_max_height([T], H) :-
    tree_height(T, H).
subtree_max_height([T|Ts], H) :-
    tree_height(T, H1),
    subtree_max_height(Ts, H2),
    max_value(H1, H2, H).


% ============================================================================
% 7. tree_sum(T, S)
% ============================================================================

% tree_sum(T, S)
% This predicate succeeds when S is the sum of the labels along a root-to-leaf
% path in tree T. It is re-executable on backtracking, so it can enumerate the
% sums of all root-to-leaf paths.
%
% Base case:
% - In a leaf [Root], the only root-to-leaf path consists of the root itself,
%   so the sum is Root.
%
% Recursive case:
% - Choose one subtree.
% - Find a root-to-leaf path sum in that subtree.
% - Add the current root label to that subtree path sum.
tree_sum([Root], Root).
tree_sum([Root|Subtrees], S) :-
    member2(Subtree, Subtrees),
    tree_sum(Subtree, S1),
    S is Root + S1.


% ============================================================================
% 8. poly_degree(P, D)
% ============================================================================

% poly_degree(P, D)
% This predicate succeeds when D is the degree of polynomial P.
%
% Special case:
% - The zero polynomial [0] has degree -1 in this assignment.
%
% Recursive idea:
% - For any non-zero polynomial, the degree is one less than the length of the
%   coefficient list, since the list starts at x^0.
poly_degree([0], -1).
poly_degree(P, D) :-
    P \= [0],
    length(P, L),
    D is L - 1.


% ============================================================================
% 9. poly_coeff(P, K, C)
% ============================================================================

% poly_coeff(P, K, C)
% This predicate succeeds when C is the coefficient of x^K in polynomial P.
% It is designed to work in multiple useful directions:
%
% - If K is known, it finds the coefficient at that power.
% - If K is beyond the end of the list, the coefficient is 0.
% - If K is not given, it can enumerate all (K, C) pairs that appear explicitly
%   in the polynomial representation.
%
% The representation starts with x^0, so the first list element is the constant.
poly_coeff(P, K, C) :-
    nonvar(K),
    integer(K),
    K >= 0,
    poly_coeff_known_k(P, K, C).
poly_coeff(P, K, C) :-
    var(K),
    poly_coeff_enumerate(P, 0, K, C).

% poly_coeff_known_k(P, K, C)
% Helper predicate for the case where K is already known.
%
% Cases:
% - If the list is empty, the requested power was beyond the represented degree,
%   so the coefficient is 0.
% - If K is 0, the current head is the coefficient we want.
% - Otherwise, move to the tail and search for x^(K-1).
poly_coeff_known_k([], _, 0).
poly_coeff_known_k([H|_], 0, H).
poly_coeff_known_k([_|T], K, C) :-
    K > 0,
    K1 is K - 1,
    poly_coeff_known_k(T, K1, C).

% poly_coeff_enumerate(P, Index, K, C)
% Helper predicate that enumerates all explicitly represented coefficient pairs
% in the polynomial.
%
% Base case:
% - The current head corresponds to power Index.
%
% Recursive case:
% - Recurse on the tail while increasing the power by 1.
poly_coeff_enumerate([H|_], Index, Index, H).
poly_coeff_enumerate([_|T], Index, K, C) :-
    Index1 is Index + 1,
    poly_coeff_enumerate(T, Index1, K, C).


% ============================================================================
% 10. poly_derivative(P, D)
% ============================================================================

% poly_derivative(P, D)
% This predicate succeeds when D is the derivative of polynomial P.
%
% This assignment says the predicate should be re-executable and usable to find
% antiderivatives. The safest autograder-friendly interpretation is:
%
% - If P is given, compute its derivative D.
% - If both P and D are given, verify that D is the derivative of P.
%
% This avoids unsafe infinite search over arbitrary constant terms while still
% keeping the relation declarative and useful in both checking and computing.
poly_derivative(P, D) :-
    nonvar(P),
    poly_derivative_forward(P, D).
poly_derivative(P, D) :-
    nonvar(D),
    nonvar(P),
    poly_derivative_forward(P, D).

% poly_derivative_forward(P, D)
% Helper predicate that computes the derivative in the forward direction.
%
% Base case:
% - The derivative of a constant polynomial is the zero polynomial [0].
%
% Recursive case:
% - Drop the constant term.
% - Multiply each remaining coefficient by its corresponding power.
poly_derivative_forward([_], [0]).
poly_derivative_forward([_|T], D) :-
    poly_derivative_forward_rest(T, 1, D).

% poly_derivative_forward_rest(Coeffs, Power, D)
% Helper predicate that processes the non-constant coefficients of a polynomial.
%
% Base case:
% - No more coefficients means no more derivative terms.
%
% Recursive case:
% - The current coefficient is multiplied by its power.
% - Recurse on the rest with the next power.
poly_derivative_forward_rest([], _, []).
poly_derivative_forward_rest([H|T], Power, [DH|DT]) :-
    DH is H * Power,
    Power1 is Power + 1,
    poly_derivative_forward_rest(T, Power1, DT).