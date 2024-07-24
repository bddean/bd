import { firstAncestorMatching } from './util.js';
import { selectedCard, focusCard } from './focus.js';
import { CARD, PROPS } from './templates.js';
import { rehydrate, dehydrate } from './hydration.js';

window.OL = window.OL || {};
/***********/(() => {/**********/

const cardContaining = (c=selectedCard()) => firstAncestorMatching(c.parentNode, '.card');

const clear = () => {
	_allcards.innerHTML = '';
	_allcards.insertAdjacentHTML('afterbegin', CARD);
	rehydrate(_allcards);
}

let dirty = true;
const mo = new MutationObserver(() => dirty=true);
mo.observe(document, {
	childList: true,
	attributes: true,
	characterData: true,
	subtree: true
});


const save = async () => {
	if(! dirty) return;
	dirty = false;
  const clone = _allcards.cloneNode(true);
  dehydrate(clone);
  await fetch('/save', {
  	method: 'POST',
  	body: clone.innerHTML
  });
};
addEventListener('DOMContentLoaded', () => {
	// TODO...
	setInterval(save, 750); // TODO...
	save();
}, { once: true })



/*****************************/

const updateFilter = (value) => {
	_filter_style.textContent=`
		.card:not(:is(${value})) > :not(.catalog) { display: none; }
	`;
}
document.addEventListener('DOMContentLoaded',
	() => {
		updateFilter(location.hash.substring(1) || "*");
	},
	{once: true}
);

Object.assign(OL, {
	updateFilter
});
/**********/})();/**************************/
