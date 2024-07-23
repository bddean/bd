:- module(dom, [
], [
	utility(common),
	pillow,
	block,
	assertions, nativeprops, regtypes
]).

dom(_). %% TODO

:- pred dom_pillow/2 :: dom * term.

dom_pillow(text(S), verbatim(S)).

:- test dom_pillow(D, P) : (D = text("hello")) => (P = verbatim("hi")).
