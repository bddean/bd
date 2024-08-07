%% Work In Progress...
:- module(array, [

], [clpfd, block, regtypes, library(utility/common)]).
:- use_module(library(lazy/lazy_lib)).

:- regtype array/1.
array := array(S, V) :-
	shape_size_(S, N),
	vector_size(V, N).

shape_size_(S, N) :- lazy_foldl(times_, S, 0, N).
times_(X, Y, Z) :- Z #= X * Y.

:- block vector_size(-, -).
vector_size(V, N) :- functor(V, vec, N).

reshape(S, array(_, V), array(S, V)) :-
	array( array(S, V) ).

%% TODO off by one i think... need to work this out on paper
shape_coords_idx([S], [I], I) :- I #< S.
shape_coords_idx([S|Ss], [C|Cs], I) :-
	I #= S * C +  In.
	shape_coords_idx(Ss, Cs, In).
