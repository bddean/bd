%% Application launcher
:- module(_, [main/1], [library(utility/common)]).
:- use_module(library(webapp), [serve/2]).
:- use_module(library(outliner), [handle/5]).
:- use_module(library(bendean_dot_name), [handle/4]).


%!opt(+Names, +Handler, +DefaultPort)
opt([bendean_dot_name, bd], bendean_dot_name:handle, 8080).
opt([outliner, ol]        , outliner:handle(local) , 4440).
%TODO
%opt([tictactoe, ttt]      , tictactoe:handle       , 5550).

main([Name]) :-
	opt(Aliases, Handle, DefaultPort),
	member(Name, Aliases),
	serve(Handle, DefaultPort).
main([Name, Port]) :-
	opt(Aliases, Handle, _),
	member(Name, Aliases),
	serve(Handle, Port).
