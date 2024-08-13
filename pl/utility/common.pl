:- package(common).
:- use_package([
	fsyntax, hiord,
	pillow, dcg,

	datafacts,

	assertions, nativeprops
]).
:- use_module(library(format)).
:- use_module(engine(stream_basic)).
:- use_module(library(iso_misc)).
:- use_module(library(hiordlib)).
:- use_module(library(aggregates)).
:- use_module(library(llists)).
:- use_module(library(lists)).
:- use_module(library(terms)).

:- fun_eval hiord(true).


