%% Application launcher
:- module(_, [main/1], [library(utility/common)]).
:- use_module(library(webapp), [serve/2]).
:- use_module(library(outliner), [handle/5]).
:- use_module(library(bendean_dot_name), [handle/4]).
:- use_module(library(tictactoe), [handle/4]).


%!app(+Names, +Handler, +DefaultPort)
app([bendean_dot_name, bd], bendean_dot_name:handle, 8080).
app([outliner, ol]        , outliner:handle(local) , 4440).
app([ttt,uttt,tictactoe]  , tictactoe:handle       , 9990).
%TODO
%app([tictactoe, ttt]      , tictactoe:handle       , 5550).

main([Name]) :-
	app(Aliases, Handle, DefaultPort),
	member(Name, Aliases),
	serve(Handle, DefaultPort).
main([Name, Port]) :-
	app(Aliases, Handle, _),
	member(Name, Aliases),
	serve(Handle, Port).
