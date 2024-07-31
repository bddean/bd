:- module(webapp, [
	serve/2,

	%% For testing:
	path_atom_/2,
	expand_response/3
], [
	utility(common)
]).

:- use_module(library(http/http_server)).
:- include(library(http/http_server_hooks)).
:- include(library(webapp/webapp_hooks)).

% TODO reconsider traits
% TODO: Add optional "init" hook.
% TODO: Add static + dynamic type checks (ensure target is a module)
% TODO: And catch errors

'httpserv.handle'(Path, Req, Rsp) :-
	member(method(Method), Req),
	current_handler(Handler),
	call(Handler, Method, Path, Req, Rsp0)
	%% Some extensions to builtin http repsonse term format: Support
	%% file_if_newer/1.
	%%
	%% TODO: HTTP lib just times out the request if response is misformatted.
		-> expand_response(Req, Rsp0, Rsp)
		; Rsp = not_found(Path).

expand_response(Req, Rsp0, Rsp) :-
	expand_response_(Req, Rsp0, Rsp1)
		-> expand_response(Req, Rsp1, Rsp)
		; Rsp = Rsp0.

expand_response_(Req, file_if_newer(F)) :=
	member(if_modified_since(OldModifDate), Req)
		? if_modified_since(OldModifDate, F)
		| file(F).

expand_response_(_, R0, R) :-
	member(R0-R, [
		file_if_newer(D, F0)-file_if_newer(D, F),
		file(F0)-file(F)
	]),
	expand_path_(F0, F).
	%% TODO: If file does not exist need to explicitly switch to not found
	%% since http lib does not do that automatically...
	%%
	%% Make sure not to leak the local file path!

expand_path_(P, A) :- path_atom_(P, A), P \= A.

:- test expand_response([], file_if_newer(base/"name"), file('base/name')) + not_fails.

%% TODO build list from dcg then call atom_cocnat; likely more efficnet
%% OTOH deep recursion may be rare...
path_atom_(A, A) :- atom(A).
path_atom_(N, A) :- number(N), atom_number(A, N).
path_atom_(S, A) :- string(S), atom_codes(A, S).
path_atom_(A1 / A2) := ~atom_concat(
	[~path_atom_(A1), '/',	~path_atom_(A2)]
).

:- pred path_atom_(T, A) : term * var => term * atm + not_fails.
:- pred path_atom_(T, A) : term * atm => term * atm + not_fails.

:- test path_atom_(f, f).
:- test path_atom_(f/g, 'f/g').
:- test path_atom_(f/1, 'f/1').
:- test path_atom_(base/"filename", 'base/filename').
:- test path_atom_('/home/ben/bd/ws/outliner/s'/"filename", '/home/ben/bd/ws/outliner/s/filename').

:- meta_predicate current_handler(pred(4)).
:- data current_handler/1.

:- meta_predicate serve(pred(4), +).
serve(Handler, Port) :-
	set_fact(current_handler(Handler)),
	http_bind(Port),
	format("Serving :~w~n", [Port]),
	http_loop(_).
