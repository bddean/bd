:- module(app, [
	handle/4,
	static_page/2
], [pillow, fsyntax, hiord]).

%handle(get, "/", _Request) := html_string("
	%<!DOCTYPE html>
	%<h1>I have a website! neat!</h1>
%").
%
handle(get, Path, _Request) := html_string(Html) :-
	static_page(Path, Terms),
	html2terms(Html, Terms).

static_page("/") := [
	"<!DOCTYPE html>",
	head([], [
	]),
	body([], [
		h1([], ["Welcome!"])
	])

].
