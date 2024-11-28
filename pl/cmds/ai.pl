%% AI interface
:- module(_, [main/1], [library(utility/common)]).
:- use_module(library(system), [current_env/2]).
:- use_module(library(http/http_client), [fetch_url/3]).
:- use_module(library(http/url), [url_info/2]).
:- use_module(library(http/http_messages), [http_request_str/4]).

%% WIP - doens't work yet
main(Request) :-
  UserPrompt = ~atom_concat(~spaces_(Request)),
	current_env('OPENAI_API_KEY', ApiKey),
	write(prompt:UserPrompt), nl,
  url_info('http://api.openai.com/v1/chat/completions', URL),
	write(url:URL), nl,

	Req = [
    method(post),
    option('content-type'('application/json')),
		option(authorization(~atom_concat('Bearer ', ApiKey)))
	],
	http_request_str(URL, Req, RequestBytes, []),
	format("rb ~s~n", [RequestBytes]),

	%fetch_url(~url_info("http://neverssl.com/"), [method(get)], Response),


	fetch_url(URL, Req, Response),

	write(rsp:Response), nl,
	member(content(Content), Response),
	format("content: ~s~n", [Content])
.

spaces_(L, L) :- L = ([] | [_]).
spaces_([A, B|T0], [A, ' '|T]) :- spaces_([B|T0], T).
