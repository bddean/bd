:- module(bendean_dot_name, [
	handle/4,
	static_page/2
], [pillow,  library(utility/common)]).
:- use_module(library(webapp/dom), [dom_html/2]).
:- use_module(library(toplevel)).
:- use_module(library(system), [current_env/2]).

:- use_module(library(outliner), [handle/5]).

:- fun_eval hiord(true).

bd_root := ~current_env('BD_ROOT').

handle(get, Path, _Request) := html_string(Html) :-
	%for debugging.
	toplevel:use_module(library(bendean_dot_name)),
	static_page(Path, Dom),
	dom_html(Dom, Html).

%% Routes for project demos....
%% TODO clean static file serving
handle(M, "/outliner/"||P, R) := ~(outliner:handle(demo, M, "/"||P, R)).
handle(get, "/boids/"||P, _) :=
	file_if_newer(~bd_root/s/'bqn-boids'/RelPath)
:- member(P-RelPath, [
	""-'index.html',
	[_|_]-P
]).
handle(get, "/previewer/", _) :=
	file_if_newer(~bd_root/s/'previewer.html').

static_page("/") := [
	inline_html("<!DOCTYPE html>"),
	head>[],
	body>[
		h1>[+"Ben Dean"],
		p>[+"Ok, next thing to do: finish outliner (see my todo note)

		And maybe restructure dir one more time: one big lib/
		"],
		h2>[+"Projects"],
		ul>Lis
	]
] :-
	findall(Li, project_listitem(Li), Lis).

project_listitem := li>[
	strong>[+Name, +": "], +Desc, +" ",
	a$[href=Code]>[+"(code)"] | Tail
] :-
	project(Name, Desc, Code), Tail = []
	; project(Name, Desc, Code, Demo),
	Tail = [+" ", a$[href=Demo]>[+"(demo)"]].

:- push_prolog_flag(multi_arity_warnings, off).

project(_, _, _) :- fail. %% TODO...
project("Outliner", "Note / task management webapp written mostly in vanilla JS and CSS", "https://github.com/bddean/bd/tree/main/pl/outliner.pl", "/outliner/").
project("Boids", "Simple flocking simulation written in BQN", "https://github.com/bddean/bd/tree/main/s/bqn-boids/flock.bqn", "/boids/").
project("Previewer", "Preview your page in multiple viewport sizes", "https://github.com/bddean/bd/tree/main/s/previewer.html", "/previewer/").
project("[TODO] aibox", "TODO!!", "#TODO", "#TODO").
project("[TODO] srs?? maybe??", "TODO!!", "#TODO", "#TODO").
project("[TODO] solitaire?? maybe??", "TODO!!", "#TODO", "#TODO").

:- pop_prolog_flag(multi_arity_warnings).
