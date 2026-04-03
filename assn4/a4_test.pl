% a4_test.pl
% GNU Prolog-safe test file for Assignment 4
% IMPORTANT: load a4.pl manually before loading this file.

% ----------------------------------------
% Entry point
% ----------------------------------------

run_tests :-
    nl,
    write('=============================='), nl,
    write('Testing list predicates'), nl,
    write('=============================='), nl,
    test_list_count,
    test_list_distinct,
    test_list_union,
    test_list_intersect,

    nl,
    write('=============================='), nl,
    write('Testing tree predicates'), nl,
    write('=============================='), nl,
    test_tree_size,
    test_tree_height,
    test_tree_sum,

    nl,
    write('=============================='), nl,
    write('Testing polynomial predicates'), nl,
    write('=============================='), nl,
    test_poly_degree,
    test_poly_coeff,
    test_poly_derivative,

    nl,
    write('=============================='), nl,
    write('All tests finished.'), nl,
    write('=============================='), nl.

% ----------------------------------------
% Utility
% ----------------------------------------

show_result(Goal) :-
    ( call(Goal) ->
        write('PASS: '), write(Goal), nl
    ;
        write('FAIL: '), write(Goal), nl
    ).

% ----------------------------------------
% List predicate tests
% ----------------------------------------

test_list_count :-
    nl, write('--- list_count/3 ---'), nl,
    show_result(list_count(a, [a,b,a,c,a], 3)),
    show_result(list_count(x, [a,b,c], 0)),
    show_result(list_count(2, [2,2,2,2], 4)).

test_list_distinct :-
    nl, write('--- list_distinct/1 ---'), nl,
    show_result(list_distinct([a,b,c])),
    show_result(\+ list_distinct([a,b,a])),
    show_result(list_distinct([])).

test_list_union :-
    nl, write('--- list_union/3 ---'), nl,
    show_result(list_union([a,b,c], [b,c,d], [a,b,c,d])),
    show_result(list_union([], [x,y], [x,y])),
    show_result(list_union([1,2], [], [1,2])).

test_list_intersect :-
    nl, write('--- list_intersect/3 ---'), nl,
    show_result(list_intersect([a,b,c], [b,c,d], [b,c])),
    show_result(list_intersect([1,2,3], [4,5], [])),
    show_result(list_intersect([], [x,y], [])).

% ----------------------------------------
% Tree predicate tests
% Tree format from Assignment 2:
% [Root, Subtree1, Subtree2, ...]
% A leaf is [Value]
% ----------------------------------------

test_tree_size :-
    nl, write('--- tree_size/2 ---'), nl,
    show_result(tree_size([5], 1)),
    show_result(tree_size([1,[2],[3]], 3)),
    show_result(tree_size([1,[2,[3],[4]],[15],[16]], 6)).

test_tree_height :-
    nl, write('--- tree_height/2 ---'), nl,
    show_result(tree_height([5], 1)),
    show_result(tree_height([1,[2],[3]], 2)),
    show_result(tree_height([1,[2,[3],[4]],[15],[16]], 3)).

test_tree_sum :-
    nl, write('--- tree_sum/2 ---'), nl,
    show_result(tree_sum([5], 5)),
    show_result(tree_sum([1,[2],[3]], 3)),
    show_result(tree_sum([1,[2],[3]], 4)),
    show_result(tree_sum([1,[2,[3],[4]],[15],[16]], 6)),
    show_result(tree_sum([1,[2,[3],[4]],[15],[16]], 7)),
    show_result(tree_sum([1,[2,[3],[4]],[15],[16]], 16)),
    show_result(tree_sum([1,[2,[3],[4]],[15],[16]], 17)).

% ----------------------------------------
% Polynomial predicate tests
% Polynomial format from Assignment 2:
% [c0, c1, c2, ...]
% represents c0 + c1*x + c2*x^2 + ...
% Zero polynomial is [0]
% ----------------------------------------

test_poly_degree :-
    nl, write('--- poly_degree/2 ---'), nl,
    show_result(poly_degree([0], -1)),
    show_result(poly_degree([5], 0)),
    show_result(poly_degree([0,1], 1)),
    show_result(poly_degree([3,1], 1)),
    show_result(poly_degree([0,0,1], 2)),
    show_result(poly_degree([1,0,5,2,0,3], 5)).

test_poly_coeff :-
    nl, write('--- poly_coeff/3 ---'), nl,
    show_result(poly_coeff([0], 0, 0)),
    show_result(poly_coeff([5], 0, 5)),
    show_result(poly_coeff([5], 1, 0)),
    show_result(poly_coeff([0,1], 1, 1)),
    show_result(poly_coeff([0,1], 0, 0)),
    show_result(poly_coeff([3,1], 0, 3)),
    show_result(poly_coeff([3,1], 1, 1)),
    show_result(poly_coeff([0,0,1], 2, 1)),
    show_result(poly_coeff([0,0,1], 1, 0)),
    show_result(poly_coeff([1,0,5,2,0,3], 0, 1)),
    show_result(poly_coeff([1,0,5,2,0,3], 3, 2)),
    show_result(poly_coeff([1,0,5,2,0,3], 5, 3)),
    show_result(poly_coeff([1,0,5,2,0,3], 6, 0)).

test_poly_derivative :-
    nl, write('--- poly_derivative/2 ---'), nl,
    show_result(poly_derivative([0], [0])),
    show_result(poly_derivative([5], [0])),
    show_result(poly_derivative([0,1], [1])),
    show_result(poly_derivative([3,1], [1])),
    show_result(poly_derivative([0,0,1], [0,2])),
    show_result(poly_derivative([1,0,5,2,0,3], [0,10,6,0,15])).