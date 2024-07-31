#!/usr/bin/env bqn
ns ← •Import "./flock.bqn"
•Show ns
s ← ns.Flock{
	target⇐0‿0
	x⇐⟨1‿2, 3‿5, 5‿6⟩
	v⇐⟨1‿2, 3‿2, ¯1‿¯1⟩
}
•Show (s.x)‿(s.v)‿(s.target)

VisBoid ← {
	x1‿x2 ← 𝕨
	v1‿v2 ← 𝕩
	∾ "<circle r='15' cx='"‿(•Repr ⌊ x1)‿"' cy='"‿(•Repr ⌊ x2)‿"'>"‿"</circle>"
}¨

VisState ← {
	⟨x, v, target⟩← 𝕩
	∾ ⟨
	"<svg xmlns='http://www.w3.org/2000/svg'>"
		(∾ x VisBoid v )
	"</svg>"
	⟩
}

#•Show VisState s

# Another CBQN bug, I think (but haven't tested): Destructuring is an
# error, and also namespaces have no Repr.
