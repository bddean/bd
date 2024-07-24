:- module(serve, [main/0, main/1, last_req/1], [ol(common)]).

:- use_module(library(http/http_server)).
:- use_module(library(bundle/bundle_paths)).
:- use_module(library(toplevel)).

:- include(library(http/http_server_hooks)).

:- use_module(ol(app), [handle/4]).

:- data last_req/1.

%% Server-side hot reloading.
'httpserv.handle'(Path, Req, Rsp) :-
	set_fact(last_req('httpserv.handle'(Path, Req, Rsp))),
	fail.

'httpserv.handle'(_, _, _) :-
	toplevel:use_module('cmds/serve'),
	toplevel:use_module(ol(app)),
	fail.

'httpserv.handle'(Path, Req, Rsp) :-
	member(method(Method), Req),
	app:handle(Method, Path, Req, Rsp).

'httpserv.file_path'('/s') := ~bundle_path(outliner, s).


main :- main([]).
main(_) :-
	Port=4442,
	format("Serving at localhost:~w~n", [Port]),

	http_bind(Port),
	http_loop(_).
