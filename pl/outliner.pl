:- module(outliner, [
	handle/5,
	gather_head_inclusions/1, %% TEMP -- for testing
	gather_head_inclusions_/2 %% TEMP -- for testing
], [library(utility/common), pillow]).
:- use_package(dcg/dcg_phrase).
:- use_module(library(stream_utils), [file_to_string/2, string_to_file/2]).
:- use_module(library(webapp/dom), [dom_html/2]).

:- include(library(webapp/webapp_hooks)).
:- use_module(library(bundle/bundle_paths), [bundle_path/3]).

mode := demo | local. %% TODO not referenced; use as a type
filepath := '/home/ben/ol.html'.
get_doc_contents_(local) := ~file_to_string(~filepath).
%% TODO NEXT: Column view broke!
get_doc_contents_(demo) := ~dom_html([
	NoteCard > [
		Content > [
			+"Notes / outliner / task management app",
			div+"A work in progress. My goal is to implement some of Emacs Org-Mode's features along with my personal workflow.",
			div+"This demo page can be edited, but your changes won't be saved."
		],
		Catalog > [
			NoteCard > [
				Content > +"Try me!",
				Catalog > [
					TodoCard > [Content > +"Press alt/option" , Catalog>[]],
					TodoCard > [Content > [
						+"Toggle views with the `shows/' commands",
						div > +"(Alt-z to cancel a command.)",
						div > +"(This is pure CSS!)"
					], Catalog>[]],
					TodoCard > [Content > [
						+"Edit the outline with the `make/' commands",
						div > +"(These are not really complete)"
					], Catalog>[]]
				]
			],
			NoteCard > [
				Content > [
					+"Obligatory Lorem Ipsum",
					div > +"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
				],
				Catalog > []
			]
		]
	]
]) :-
	NoteCard = div $ [class=card],
	TodoCard = div $ [class=card, 'data-task'='TODO'],
	Content = div $ [class=content, contenteditable],
	Catalog = div $ [class=catalog].


	%"<h1>TODO!!</h1>".

handle(Mode, post, "/save", Request) := string_(
	status(success, 200, "OK"),
 	%% TODO what is the right content type ???
	content_type(text, plain, []),
	""
) :-
	Mode = demo, !
	;	member(content(Content), Request),
		string_to_file(Content, ~filepath).

handle(Mode, get, "/", _Request) := html_string(HTML) :-
	doc_dom(~get_doc_contents_(Mode), DocTerms, []),
	html2terms(HTML, DocTerms).

handle(_, get, "/s/"||RelPath, _) := file_if_newer(Base/RelPath) :-
	%% TODO check security.
	bundle_path(outliner, s, Base).

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

:- use_module(library(system), [directory_files/2, file_property/2]).
:- use_module(library(pathnames), [path_concat/3, path_dirname/2]).

gather_head_inclusions := ~gather_head_inclusions_(~bundle_path(outliner,  's/include/')).

suffix_(A, End)  :- atom_concat(_, End, A).

%% TODO ok this is tricky
%% We can't set <base> dynamically b/c it messes up prefetching
%% So I think ideally, we would
%% - copy to build dir
%% - and then support general absolute path

%% TODO sort these?
gather_head_inclusions_(F, []) :- suffix_(F, ('/.' | '/..')), !.
gather_head_inclusions_(F, [T]) :-
	file_property(F, type(regular)),
	%% TODO: Generalize, obviously!
	atom_concat([
		~bundle_path(outliner,  '.'), '/', RelPath
	], F),
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
