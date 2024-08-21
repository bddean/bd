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
		main$[id=main, style="
		"]> [
			div$[id=right, onclick="(async () => {
				await say(`./s/sounds/nice_work.mp3`);
				await present()
			})()"], div$[id=wrong, onclick="(async () => {
				await say(`./s/sounds/try_again.mp3`);
				await present();
			})()"]
		],
		style> inline_html("
			* { box-sizing: border-box; }
			#main { user-select: none; height: 100vh; width: 100vw; }
			#main { font-size: 20vw; }
			#main { display: grid; grid-template-columns: 1fr 1fr; }
		"),
		script> inline_html("
			const bg = ['#000000', '#333333', '#0000AA', '#006600', '#660000'];
			const fg = ['#FFFF99', '#CCFFFF', '#FFCCCC', '#CCFFCC', '#FFCCFF'];
			const say = async src => {
				aud.pause();
				aud.src=src;
				const ended = new Promise(r => {
					aud.addEventListener('ended', r, {once:true})
				});
				await aud.play();
				await ended;
			}
			const alphabet='catmb';
			const choose2=xs=>{
				const n = xs.length;
				const i = Math.floor(Math.random()*n);
				let j = Math.floor(Math.random()*(n-1));
				if(j===i)j=n-1;
				return [xs[i], xs[j]];
			}
			present=async () => {
				const [fgs, bgs, cs] = [fg, bg, alphabet].map(choose2);
				[right.style.background, wrong.style.background] = bgs;
				[right.style.color     , wrong.style.color] = fgs;
				[right.textContent     , wrong.textContent] = cs;
				main.appendChild(Math.random()>0.5 ? right : wrong); // Shuffle order.
				await say(`./s/sounds/${cs[0]}.mp3`);
			}
			present();
		")
	].
