:- module(_, [], [ciaobld(bundlehooks)]).

% Adapted from core
:- use_module(ciaobld(ciaoc_aux), [runtests_dir/2]).

'$builder_hook'(test) :- !,
	runtests_dir(pl, 'lib').

