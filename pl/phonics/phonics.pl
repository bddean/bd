%% Work In Progress...
:- module(phonics, [handle/4], [utility/common]).
:- use_module(library(webapp/dom), [dom_html/2]).
:- use_module(library(toplevel), [use_module/1]).

libroot(Base) :-
	absolute_file_name(library(phonics), '_opt', '.pl', '.', _, _, Base).

handle(get, Path, _, _) :-
	format("PATH ~s~n", [Path]),
	fail.
handle(get, "/s/"||Path, _) := file_if_newer(~libroot/s/Path).
handle(get, "/", _) := html_string(~dom_html(Dom)) :-
	Dom = [
		inline_html("<!DOCTYPE html>"),
		link$[rel=stylesheet, href="./s/phonics.css"],
		audio$[id=aud],
		main$[id="main", style="
			font-size: 200px;
		"]> +"?",
		script> inline_html("
			const bg = ['#000000', '#333333', '#0000AA', '#006600', '#660000'];
			const fg = ['#FFFF99', '#CCFFFF', '#FFCCCC', '#CCFFCC', '#FFCCFF'];
			onkeypress=e => {
				e.preventDefault();
				e.stopPropagation();
				aud.src=`./s/sounds/${e.key}.mp3`;
				main.textContent=e.key;
				document.body.style.background=bg[Math.floor(Math.random()*6)];
				document.body.style.color=fg[Math.floor(Math.random()*6)];
				aud.play();
			}

		")
	].
