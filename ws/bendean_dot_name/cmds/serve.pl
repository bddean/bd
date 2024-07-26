:- module(serve, [main/0, main/1], [utility(common)]).

:- use_module(library(http/http_server)).
:- use_module(library(bundle/bundle_paths)).
:- use_module(library(toplevel)).

:- include(library(http/http_server_hooks)).

:- use_module(bendean_dot_name(app), [handle/4]).

%% Server-side hot reloading.

%'httpserv.handle'(_, _, _) :-
%	toplevel:use_module('cmds/serve'),
%	toplevel:use_module(bendean_dot_name(app)),
%	fail.

'httpserv.handle'(Path, Req, Rsp) :-
	member(method(Method), Req),
	app:handle(Method, Path, Req, Rsp).

'httpserv.file_path'('/s') := ~bundle_path(bendean_dot_name, s).

main :- main([]).
main([]) :- main(['8080']).
main([PortA]) :- atom_number(PortA, Port),
	format("Serving at localhost:~w~n", [Port]),
	http_bind(Port),
	http_loop(_).
