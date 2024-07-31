Divide←{𝕨𝕊0:0}⎊÷ # Division but with x÷0 = 0
M ← (√+´∘×˜)¨ # Vector magnitude.
# TODO Improve performance. Spatial indexing is the obvious next step.
Flock ⇐ {dt 𝕊  ⟨x,v,target⟩ :
	dt ⌊↩ 50
	⟨x,v,target⟩ ⇐
	n←≠x
	offsets ← x -⌜ x
	distance ← M offsets
	direction ← Divide⟜M offsets
	Where ← {𝕩 <∘(/⊸⊏)˘ n‿n⊸⥊𝕨}
	v+↩0.005×dt×+´⟨
		0.05 × - x - (+´Divide≠)¨ x Where (distance ≤ 100) ∧ distance > 30, # Rule 1: Clump.
		0.22 × (+´Divide≠)¨ v Where distance < 100,                         # Rule 2: Align.
		0.70 × x - (+´Divide≠)¨ x Where distance < 25,                      # Rule 3: Repel.
	⟩
	v ×↩ 0.99 # Friction
	v ↩ ¯25 ⌈ 25 ⌊ v # Terminal velocity
	x +↩  dt×v
	x ↩ 500 | x # Wrap around the edges of the canvas.
}
