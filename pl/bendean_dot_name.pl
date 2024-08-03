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
handle(get, "/previewer/"||_, _) := %% (Need ||_ to ignore ?search)
	file_if_newer(~bd_root/s/'previewer.html').

static_page("/") := [
	inline_html("<!DOCTYPE html>"),
	head>[],
	body>[
		h1> +"Ben Dean",
		p> [
			+"This personal website is a work in progress.",
			+" You can check out some of my projects below.",
			+" I'm looking for work. See my ", a$[href=LinkedIn]> +"LinkedIn profile."
		],
		h2> +"Projects",
		ul>Lis
	]
] :-
	LinkedIn="https://www.linkedin.com/in/ben-dean-b007bb91/",
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
project("Previewer", "View a webpage in different viewports side-by-side, implemented as a single HTML file", "https://github.com/bddean/bd/tree/main/s/previewer.html", "/previewer/").

%% Not-yet-presentable projects..
%%project("Ultimate tic-tac-toe", "TODO!!", "#TODO", "#TODO").
	%% ^ In ~/tictactoe/, but I should add ai or network play or something
%%project("aibox", "TODO!!", "#TODO", "#TODO").
%%project("srs?? maybe??", "TODO!!", "#TODO", "#TODO").
%%project("solitaire?? maybe??", "TODO!!", "#TODO", "#TODO").

:- pop_prolog_flag(multi_arity_warnings).
