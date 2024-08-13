import { setAsSelectedCard, selectedCard, focusCard, deleteCard } from './focus.js';
import { CARD }  from './templates.js';
import { rehydrate } from './hydration.js';
import { firstAncestorMatching } from './util.js';

export const action = {}; // Registered interactive commands.
export const helpdoc = {};
export function define_action(name, doc, fn) {
	action[name] = fn;
	helpdoc[name] = fn;
}
export function carry_out_action(name) {
	if (! action[name]) {
		// TODO Error handling UI.
		console.error(`I don't know how to "${name}"`);
		return;
	}
	action[name]();
	// Update focus if necessary.
	requestAnimationFrame(() => focusCard(selectedCard()));
}

define_action('kid', `
	Add a new child of the current note. Go to the new
	child note.
`, () => {
	const p = selectedCard();
	const kids = p.querySelector('.catalog');
	kids.insertAdjacentHTML('beforeend', CARD);
	const c = kids.lastElementChild;
	rehydrate(c);
	setAsSelectedCard(c);
});

define_action('sib', `
	Add a new sibling of the current note. Go to the new
	sibling note.
`, () => {
	const s = selectedCard();
	if (s.parentElement === _allcards) { return; }
	s.insertAdjacentHTML('afterend', CARD);
	const c = s.nextElementSibling;
	rehydrate(c);
	setAsSelectedCard(c);
});

define_action('drop', `
	Delete the current note.
`, () => {
	const c = selectedCard();
	deleteCard(c);
});

define_action('pop', `
	Reduce the nesting level of the current note by one. In
	other words, the current note is adopted by its grandparent.
`, () => {
	const c = selectedCard();
	const p = firstAncestorMatching(c.parentElement, '.card');
	const gp = p.parentElement;
	if (! gp?.matches?.('.catalog')) throw new Error('?');
	gp.insertBefore(c, p.nextElementSibling);
	setAsSelectedCard(c);
});

{
	const def_layout_action = (n, h) => define_action(n, h, () => {
		document.documentElement.setAttribute('view', n);
	});
	def_layout_action('prose', `
		Switch to (default) outline-tree view showing note contents.`);
	def_layout_action('rows', `
		Switch to column-oriented tabular view.`);
	def_layout_action('close', `
		Switch to compact one-line outline-tree view.`);
}

define_action('wrap', `
`, () => {
	const c = selectedCard();
	const cat = c.parentElement;
	cat.insertAdjacentHTML('beforeend', CARD);
	const k = cat.lastElementChild;
	rehydrate(k);
	setAsSelectedCard(k);
	k.querySelector('catalog').appendChild(c);
});

define_action('raise', `
`, () => {
	const c = selectedCard();
	const p = firstAncestorMatching(c.parentElement, '.card');
	if (!p) throw new Error("Already at top.")
	p.replaceWith(c);
});

