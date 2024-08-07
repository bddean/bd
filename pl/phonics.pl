%% Work In Progress...
:- module(phonics, [handle/4], [utility/common]).
:- use_module(library(webapp/dom), [dom_html/2]).

handle(get, "/", _) := html_string(~dom_html(Dom)) :-
	Dom = [
		inline_html("<!DOCTYPE html>"),
		style> + ""
	].

