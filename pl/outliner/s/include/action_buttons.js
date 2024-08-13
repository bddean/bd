import { selectedCard } from './focus.js';
import { carry_out_action } from './actions.js';

/* TODO
ui stuff
	- when successfully selecting an action: highlight it in activated state for a bit before switching to main list
		- but if user starts new kbd sequence immediately switch
	- when cancelling key sequence:
		- flash red or something to indicate cancellation
	- sound effects might help too!
*/

let visibleActionSelector = '[group=""]';
document.addEventListener('click', e => {
	const b = e.target;
	if (! b.matches('button[action]')) { return; }
	const act = b.getAttribute('action');
	if (act.endsWith('/')) {
		const groupName = act.substring(0, act.length-1);
		// TODO escape
		// TODO clean up redundant show/hide css
		visibleActionSelector = `button[group="${groupName}"]`;
		const nbsp = '\xa0';
		_action_style.textContent=`#toolbar>* {
			display: none;
			&:is(${visibleActionSelector}) {
				display: block !important;
			}
		}
		#toolbar {
			background: #fff6c2;
			font-family: monospace;
			&::before {
				content: "${groupName}/"
			}
		}`;
		// TODO timeout?
	} else {
		// Restore visibility settings.
		visibleActionSelector = '[group=""]';
		_action_style.textContent = '';

		carry_out_action(act);

	}
});

// TODO sync automatically with actions.css. Use a Prolog-generated
// script/style pair.
const hotkeys = ['a', 's', 'd', 'f', 'j', 'k', 'l', ';', 'g', 'h'];
addEventListener('keydown', e => {
	if(! e.altKey) {
		return;
	}
	const idx = hotkeys.indexOf(e.key);
	const btn = document.querySelectorAll(visibleActionSelector)[idx];
	if (btn) {
		btn.click();
	}	else if (e.key.length === 1) {
		// TODO flash red or otherwise indicate "cancelled"
		visibleActionSelector = '[group=""]';
		_action_style.textContent = '';
		return;
	}
});
addEventListener('keypress', e =>	e.altKey && e.preventDefault());

addEventListener('keydown', e => e.key === 'Alt' && document.body.setAttribute('keypress', ''));
addEventListener('keyup', e => e.key === 'Alt' && document.body.removeAttribute('keypress'));


