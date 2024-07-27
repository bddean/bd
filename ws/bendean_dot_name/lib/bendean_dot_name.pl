:- module(bendean_dot_name, [
	handle/4,
	static_page/2
], [pillow,  utility(common)]).
:- use_module(webapp(dom), [dom_html/2]).
:- use_module(library(toplevel)).

:- use_module(library(outliner), [handle/4]).

:- fun_eval hiord(true).

handle(get, Path, _Request) := html_string(Html) :-
	%for debugging.
	toplevel:use_module(library(bendean_dot_name)),
	static_page(Path, Dom),
	dom_html(Dom, Html).

handle(Method, "/outliner", Req) := ~(outliner:handle(Method, "/", Req)).

static_page("/") := [
	inline_html("<!DOCTYPE html>"),
	head>[],
	body>[
		h1>[+"Ben Dean"],
		p>[+"Ok, next thing to do: finalize outliner. This
			means, first of all, making it installable as
			a path in the bendean_dot_name app and populating
			it with demo data.

			Also, consider giving it a a real name!
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
project("Notes", "Note / task management webapp", "https://github.com/bddean/bd/tree/main/ws/outliner", "/outliner").
project("[TODO] Boids", "Simple flocking simulation written in BQN", "#TODO", "#TODO").
project("[TODO] aibox", "TODO!!", "#TODO", "#TODO").
project("[TODO] srs?? maybe??", "TODO!!", "#TODO", "#TODO").
project("[TODO] solitaire?? maybe??", "TODO!!", "#TODO", "#TODO").

:- pop_prolog_flag(multi_arity_warnings).
