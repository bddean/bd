import { PROPS } from './templates.js';
export const rehydrate = el => {
	if (!el || ! el.insertAdjacentHTML) return;

	if (el.tagName == 'DIV' && el.classList.contains('card') && ! el.querySelector('.props')) {
  	insertPropControls(el);

  	bindDataToCssVars(el);
	}

	rehydrate(el.firstElementChild);
	rehydrate(el.nextElementSibling);
}

export const dehydrate = el => {
	if (! el) return;
	const { nextSibling } = el;

	let removedEl = false;
	if(el.hasAttribute?.('ephemeral')) {
		// Presentation-only subtree inserted programatically.
		el.parentNode.removeChild(el);
		removedEl = true;
	}

	el.removeAttribute?.('style');

	if (! removedEl) dehydrate(el.firstChild);
	dehydrate(nextSibling);
}

document.addEventListener('DOMContentLoaded',
	() => rehydrate(_allcards),
	{once: true}
);


const insertPropControls = card => {
	card.insertAdjacentHTML('afterbegin', PROPS);
	const propForm = card.firstElementChild;
	// Initial bound values.
	for (const inputish of propForm.querySelectorAll(`[name]`)) {
		const name = inputish.name;
		if (name in card.dataset) {
			inputish.value = card.dataset[name];
		} else {
			card.dataset[name] = inputish.value;
		}
		// Dynamically bind input=>attr.
		inputish.onchange = () => card.dataset[name] = inputish.value;
	}
	// Finally, dynamically bind attrs => inputs...
	// TODO
}

const bindDataToCssVars = card => {
	const copyToCss = aName => {
		if (! aName.startsWith('data-')) return;
		if (card.hasAttribute(aName)) {
			card.style.setProperty('--'+aName, card.getAttribute(aName));
		} else {
			card.style.removeProperty('--'+aName);
		}
	}
	for (const att of card.attributes) copyToCss(att.name);
	const obs = new MutationObserver(muts => {
	  for (const m of muts) copyToCss(m.attributeName)
	});
	obs.observe(card, { attributes: true });
}

