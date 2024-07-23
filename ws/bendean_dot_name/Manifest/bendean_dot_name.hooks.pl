:- module(_, [], [ciaobld(bundlehooks)]).

% Adapted from core
:- use_module(ciaobld(ciaoc_aux), [runtests_dir/2]).
:- use_module(library(bundle/bundle_paths), [bundle_path/3]).

'$builder_hook'(test) :- !,
	runtests_dir(noot, 'lib'),
	runtests_dir(noot, 'src').

