:- module(app, [
	handle/4,
	gather_head_inclusions/1, %% TEMP -- for testing
	gather_head_inclusions_/2 %% TEMP -- for testing
], [utility(common), pillow]).
:- use_module(library(stream_utils), [file_to_string/2, string_to_file/2]).
:- use_package(dcg/dcg_phrase).

filepath := '/home/ben/ol.html'.

handle(post, "/save", Request) := string_(
	status(success, 200, "OK"),
 	%% TODO what is the right content type ???
	content_type(text, plain, []),
	""
) :-
	member(content(Content), Request),
	string_to_file(Content, ~filepath).

handle(get, "/", _Request) := html_string(HTML) :-
	doc_dom(~file_to_string(~filepath), DocTerms, []),
	html2terms(HTML, DocTerms).

%% TODO extract my dom_expand stuff here??
%% TODO let's query dir for this
doc_dom(CardsHtml) -->
	[
		declare("DOCTYPE HTML"),
		html([], [
			head([], HeadDom),
			body([], BodyDom)
		])
	], {
		head_dom(HeadDom, []),
		body_dom(CardsHtml, BodyDom, [])
	}.
head_dom --> [
	meta$[charset="utf-8"],
	title([], [verbatim("Outliner!")]),
	style([id="_filter_style"], []),
	style([id="_action_style"], [])
	%script([src="/s/main.js"], []),
	%link$[rel="stylesheet", href="/s/main.css"],
], {gather_head_inclusions(Etc)}, Etc.

%% TODO convert to terms, I guess.
body_dom(CardsHtml) -->
	{
		phrase((
			filter_dom,
			toolbar_dom,
			[div([id="_allcards", class="catalog"], [CardsHtml])]
		), Kids)
	},
	[div([id="main"], Kids)].

filter_dom --> [
	div([id="filter"], [
		"<textarea id=_filter_input oninput='OL.updateFilter(this.value)'>*</textarea>
		<div>
			<button onclick='
				location.hash = _filter_input.value;
			'>Save filter to url</button>
		</div>
		<!-- Initialization -->
		<script>
			_filter_input.value = decodeURIComponent(location.hash.substring(1)) || '*'; // Trim leading '#'
		</script>"
	])
].

toolbar_dom --> [div([id=toolbar, class=toolbar], [
	~maplist(toolbar_dom__action_btn_, [
		''-'make/',
		make-kid,
		make-sib,
		make-drop,
		make-pop,

		''-'shows/',
		shows-prose,
		shows-rows,
		shows-close
	])
])].
toolbar_dom__action_btn_(G-A) := button([group=G,action=A], []).


:- use_module(library(bundle/bundle_paths), [bundle_path/3]).
:- use_module(library(system), [directory_files/2, file_property/2]).
:- use_module(library(pathnames), [path_concat/3, path_dirname/2]).

gather_head_inclusions := ~gather_head_inclusions_(~bundle_path(outliner,  's/include/')).

suffix_(A, End)  :- atom_concat(_, End, A).

%% TODO sort these?
gather_head_inclusions_(F, []) :- suffix_(F, ('/.' | '/..')), !.
gather_head_inclusions_(F, [T]) :-
	file_property(F, type(regular)),
	%% TODO: Generalize, obviously!
	atom_concat(~bundle_path(outliner,  '.'), RelPath, F),
	member(Suffix-T, [
		'.js' -script([type=module, src=RelPath], []),
		'.css'-link$[rel=stylesheet, href=RelPath]
	]),
	suffix_(F, Suffix),
	!.
gather_head_inclusions_(Dir, Files) :- file_property(Dir, type(directory)), !,
	directory_files(Dir, Kids),
	maplist(gather_head_inclusions__iter_(Dir), Kids, Fileses),
	append(Fileses, Files).
gather_head_inclusions_(_, []). %% Default.

%% TODO anon version didn't work -- why??
gather_head_inclusions__iter_(Dir, Name, Fs) :-
		path_concat(Dir, Name, Path),
		gather_head_inclusions_(Path, Fs).
