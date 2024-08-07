%% Work In Progress...
:- module(tictactoe, [
	handle/4
], [
	utility/common
]).
:- use_module(library(webapp/dom), [dom_html/2]).
:- use_module(library(toplevel)).

%% For debugging:
handle(_, _, _, _) :-	toplevel:use_module(library(tictactoe)), fail.

handle(get, "/", _) := html_string(~dom_html(Dom)) :-
	Dom = [
		inline_html("<!DOCTYPE html>"),
		style> inline_html(~css),
		~uttt
	].

ttt(X) := div$[class=board]>Rows :-
	length(Rows, 3),
	maplist(=(
		div$[class=row]>Cells
	), Rows),
	length(Cells, 3),
	maplist(=(
		div$[class=cell]>X
	), Cells).

uttt := ~ttt(~ttt([])).

css := "
	* { box-sizing: border-box; }
	:not(.cell)>.board { /* outer board */
		margin: auto;
	  	width: 80vw; height: 80vw;
	  	max-width: 80vh; max-height: 80vh; }
	.row { width: 100%; height: 33.3333%; }
	.cell {
		height:100%; width: 33.3333%;
		display: inline-block; vertical-align: top; }
	.cell>.board {
		display: inline-block; height: 100%; width: 100%;	}

	:root                    { --border-style: 2px solid #555; }
	.cell >.board>.row>.cell { --border-style: 1px solid #AAA;
		text-align: center; padding-top: auto; vertical-align: middle; }

	:nth-child(1)>.cell { border-bottom: var(--border-style); }
	:nth-child(3)>.cell { border-top: var(--border-style); }
	.cell:nth-child(1) { border-right: var(--border-style); }
	.cell:nth-child(3) { border-left: var(--border-style); }

	#board.started .cell.outer:not(.active) {
		background-color: #ddd;
		cursor: not-allowed; }
	.cell.inner.last-placed {
		background-color: white; }
	.cell.inner.last-placed > svg > * {
		stroke: #D00;	}

	cell:before { content: 'X'; display: none; }
	cell:after  { content: 'O'; display: none; }
".
