import { firstAncestorMatching } from './util.js';
// TODO: Using "active" was actually good: Updates faster so more
// repsonsive. Otherwise have to wait a little beat.

export const selectedCard = () =>	document.querySelector('[_selected]');

export const deleteCard = (c=selectedCard()) => {
	if(!c)return;
	let p = c.parentElement;
	if (p===_allcards)return;//Can't remove root
	p.removeChild(c);
	setAsSelectedCard(firstAncestorMatching(p.parentElement, '.card'));
}
// (Maybe... I think. idk).
/*
- focus new card
		-> restore selection if it exists AND if we aren't selecting the card already othe rthan at the front
		-> set _selected attr

applications
	- action on a card: always apply to [_selected]
	- to focus a card: just use content.focus like before.
*/

// TODO NEXT -- [_selected] is on catalog instead of card
// wtf
export const activeCard = () => firstAncestorMatching(document.activeElement, 'card');



document.addEventListener('focusin', e => {
	if (! e.target.matches('.card>.content')) return;
	const contentEl = e.target;
	const c = contentEl.parentElement;
	setAsSelectedCard(c);
	// Restore previous selection of this card's content, if any.
	const r = dormantSelections.get(c);
	if (! r) return;
	const content = c.querySelector('.content');
	const sel = getSelection();
	getSelection().setBaseAndExtent(r.startContainer, r.startOffset, r.endContainer, r.endOffset);
});


export const focusCard = (c = selectedCard()) => c?.querySelector('.content').focus();
export const setAsSelectedCard = (c) => {
	if (c && ! c.classList.contains('card')) { throw new Error(`Not a card: ${c}`); }
	if (c?.hasAttribute?.('_selected')) return;
	let lastSel;
	for (lastSel of document.querySelectorAll('[_selected]')) {
		// (We expect this loop to iterate only once.)
		lastSel.removeAttribute('_selected');
	}
	if (
		lastSel && lastSel !== c
		&& lastSel.querySelector('.content').textContent.trim() === ""
		&& ! lastSel.querySelector('.catalog').firstElementChild
		&& lastSel.parentNode !== _allcards
	) {
		console.log('deleting', ! lastSel.querySelector('.catalog').firstElementChild, lastSel.outerHTML);
		save_excursion(() => deleteCard(lastSel));
	}
	c?.setAttribute('_selected', '');
}

const dormantSelections = new Map();
document.addEventListener('selectionchange', () => {
	const sel = getSelection();
	const selectedCard = firstAncestorMatching(sel.focusNode, '.content')?.parentElement;
	if (! selectedCard) return;
	// Set "_selected" attribute.
	// TODO Accidentally duplicated this code but it works worse if I remove it???
	setAsSelectedCard(selectedCard);

	// Save this selection to potentially restore later.
	dormantSelections.set(selectedCard, sel.getRangeAt(0));
});

// TODO save selected ranges too
export const save_excursion = fn => {
	const c = selectedCard();
	try {
		fn();
	} finally {
		// TODO handle if c has been removed
		setAsSelectedCard(c);
	}
}
