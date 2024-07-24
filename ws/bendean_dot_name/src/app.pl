:- module(app, [
	handle/4,
	static_page/2
], [pillow, fsyntax, hiord]).
:- use_module(webapp(dom), [dom_html/2]).

handle(get, Path, _Request) := html_string(Html) :-
	static_page(Path, Dom),
	dom_html(Dom, Html).

static_page("/") := [
	inline_html("<!DOCTYPE html>"),
	head>[],
	body>[
		h1>[+"My personal website -- under construction!"]
	]
].


