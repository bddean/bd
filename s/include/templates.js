
export const CARD = `<div class="card">
	<div class=content contenteditable="true"></div>
	<div class=catalog></div>
</div>`;
window.cycleSelectForward = sel => {
	sel.selectedIndex++;
	if(sel.selectedIndex<0)sel.selectedIndex=0;
  sel.dispatchEvent(new Event('change'), { bubbles: true }); // Notify listeners.
}
export const PROPS = `<div class="props" ephemeral>
	<label>task</label>
	<div style="display: inline-flex;">
		<select tabindex="-1" name=task>
			<option selected value="">no task</option>
			<option value="TODO">TODO</option>
			<option value="PROG">PROG</option>
			<option value="DONE">DONE</option>
		</select>
		<button tabindex="-1" class="face-right" onclick="cycleSelectForward(this.previousElementSibling)">
			➤
		</button>
	</div>

	<label>due</label>
	<input required tabindex="-1" name=due type="datetime-local">

	<label>scheduled</label>
	<input required tabindex="-1" name=scheduled type="datetime-local">

	<label>tags</label>
	<textarea required tabindex="-1" name=tags rows=2></textarea>
</div>`;
