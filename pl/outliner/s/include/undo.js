// since undoing also generates mutations we can just do it emacs style...
const undoStack = [];
const processMutations = records => {
	for(const rec of records) {
		undoStack.push(() => undoMut(rec));
	}
};
const mo = new MutationObserver(processMutations);
function undoMut(mut) {
	switch(mut.type) {
	}
}
let nextTick = 1;
addEventListener('DOMContentLoaded', () => {
	document.body.insertAdjacentHTML('beforeend', `
		<input type="text" value=0 id=_undo_tick style="
			opacity: 0;
			position: static;
			pointer-events: none;
		">
	`);
	_undo_tick.oninput = e => {
		switch(e.inputType) {
			case 'insertText':
				console.log('Undo boundary marked', _undo_tick.value);
				break;
			case 'historyUndo':
				console.log('Undo detected', _undo_tick.value);
				break;
			case 'historyRedo':
				console.log('Redo detected', _undo_tick.value);
				break;
		}
	}

  mo.observe(_allcards, {
  	subtree: true,
  	attributes: true,
  	childList: true,
  	attributeOldValue: true,
  	characterData: true,
  	characterDataOldValue: true,
	});
});



export function markUndoBoundary() {
	console.log('@@ markUndoBoundary...');
	let r;
	try {
		r = getSelection().getRangeAt(0);
	} catch(_) {
		r = null;
	}
	try {
		processMutations(mo.takeRecords());
		_undo_tick.focus();
		document.execCommand('selectAll', false, null);
		document.execCommand('insertText', false, nextTick++);
		console.log('@@ next tick:', nextTick);
	} finally {
		if (r) {
			getSelection().setBaseAndExtent(r.startContainer, r.startOffset, r.endContainer, r.endOffset);
		}
	}
}
