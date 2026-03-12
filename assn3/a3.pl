%% Assignment 3 – Family Relationships - Colby Hanna (001254515)

%% 1. child(X, Y)
%% Logical Meaning: X is a child of Y if Y is a parent of X.

child(X,Y) :-
    parent(Y,X).


%% 2. sibling(X, Y)
%% Logical Meaning: X and Y are siblings if they share a common 
%% parent P, and X and Y are not the same individual.

%% 2. sibling(X, Y)
sibling(X,Y) :-
    % 1. Find a parent of X
    parent(P, X),
    % 2. Check if that same person is a parent of Y
    parent(P, Y),
    X \= Y,
    % 3. If they share TWO parents, only succeed for the first one found.
    % This prevents duplicate siblings
    \+ (parent(P2, X), parent(P2, Y), P2 @< P).


%% Helper: ancestor_of_dist(Anc, Desc, Dist)
%% Logical Meaning: Anc is an ancestor of Desc at a distance of 
%% Dist generations.
%% Base Case: If Anc is the parent of Desc, the distance is 1.
%% Recursive Step: Anc is an ancestor of Desc if Anc is a parent 
%% of some person Z, and Z is an ancestor of Desc at distance D.

ancestor_level(X,Y,1) :-
    parent(X,Y).

ancestor_level(X,Y,N) :-
    parent(X,Z),
    ancestor_level(Z,Y,M),
    N is M + 1.


%% 3. grandparent(X, Y, N)
%% Logical Meaning: X is a (great)^N grandparent of Y.
%% A grandparent (N=0) is 2 generations away. Each "great" (N) 
%% adds 1 more generation, so the distance is N + 2.

grandparent(X,Y,N) :-
    G is N + 2,
    ancestor_level(X,Y,G).


%% 4. grandchild(X, Y, N)
%% Logical Meaning: X is a (great)^N grandchild of Y. [cite: 14]
%% This is the logical inverse of the grandparent relationship.

grandchild(X,Y,N) :-
    grandparent(Y,X,N).


%% Helper predicate: ancestor(X,Y,D)
%% X is an ancestor of Y with generation distance D.
%% D = 1 means parent
%% D = 2 means grandparent

ancestor(X,Y,1) :-
    parent(X,Y).

ancestor(X,Y,D) :-
    parent(X,Z),
    ancestor(Z,Y,M),
    D is M + 1.


%% 5. cousin(X, Y, M, N)
%% Logical Meaning: X is an M-th cousin N  removed of Y. [cite: 15]
%% M is the cousin degree (M >= 1) and N is the removal (N >= 0). [cite: 17, 18]

%% 5. cousin(X, Y, M, N)
cousin(X,Y,M,N) :-
    ancestor(A,X,DX),
    ancestor(A,Y,DY),
    DX > 1,
    DY > 1,
    X \= Y,
     
    % To get rid of duplication only succeed for the alphabetically first common ancestor found.
    \+ (ancestor(OtherA, X, DX), ancestor(OtherA, Y, DY), OtherA @< A),

    M is min(DX,DY) - 1,
    N is abs(DX - DY),
    M >= 1,
    N >= 0.