:- module(dom, [
	dom_html/2
], [
	utility(common),
	pillow,
	block,
	assertions, nativeprops, regtypes
]).

%% TODO support both modes
dom_html(Dom, Html) :-
	dom_pillow(Dom, Pillow),
	html2terms(Html, Pillow).
:- test dom_html([input$[type=text], div$[]>[+hi]], H)
	=> H = "<input type=\"text\"><div>hi</div>".

:- test dom_html(div> +"hello", H) => H = "<div>hello</div>".

:- prop dom/1.
:- export(dom/1).
dom(_). %% TODO

:- export(dom_pillow/2).
:- pred dom_pillow/2 :: dom * term.

dom_pillow([], []).
dom_pillow([D|Ds], [P|Ps]) :-
	dom_pillow(D, P), %% Assumes 1:1 -- is this valid?
	dom_pillow(Ds, Ps).
dom_pillow(inline_html(S)) := S. %% Unescaped inline html.

dom_pillow(+S) := verbatim(S).
dom_pillow(Env+S) := ~dom_pillow(Env > + S).

dom_pillow(T$As) := ~dom_pillow(T$As>[]).
dom_pillow(T>Cs) := ~dom_pillow(T$[]>Cs) :- atm(T).

dom_pillow(T$As>Cs) := Term :-
	if((self_closing(T), Cs=[]),
			Term = T$As,
		Term = env(T, As, ~dom_pillow(Cs))
	).

:- test dom_pillow(+"hello", P) => (P = verbatim("hello")).
:- test dom_pillow(Tag$[type=text], P)
	: (Tag = input) => (P = input$[type=text]).
:- test dom_pillow(Tag$[type=text], P)
	: (Tag = div) => (P = env(div, [type=text], [])).

%%% Self-closing tags: %%%
% From http://xahlee.info/js/html5_non-closing_tag.html 
self_closing(area).  self_closing(base).
self_closing(br).    self_closing(col).
self_closing(embed). self_closing(hr).
self_closing(img).   self_closing(input).
self_closing(link).  self_closing(meta).
self_closing(param). self_closing(source).
self_closing(track). self_closing(wbr).
%% Obsolete tags:
self_closing(command).  self_closing(keygen).
self_closing(menuitem). self_closing(frame).
