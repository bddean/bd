:- module(_, [], [ciaobld(bundlehooks), library(utility/common)]).
:- use_module(library(unittest)).

'$builder_hook'(test) :- !,
	run_tests_in_dir_rec('.', [], Code),
	%% ??? Doesn't seem to work
	halt(Code).
