define({|TYPE|}, {|const t_$1 = $2, tag_$1 = $2 << 30;|})
TYPE(lvr, 0b00) // Logic variables
TYPE(atm, 0b01) // Atoms
TYPE(num, 0b10) // Small numbers
TYPE(trm, 0b11) // Compound terms
undefine({|TYPE|})

const tag_mask = tag_trm;
const value_mask = ~tag_mask;


const engine = () => {
	const stack = [];
	const x = stack[stack.length-1];
	const tag = x & tag_mask;
	const val = x & value_mask;

	const atoms = [
		Symbol('[builtin_predicate]'), // Reserved value: proxy to host
		'$store', // one-sided unification
		'='
	];
	// hm, maybe i just need a different type:
	// "operator": apply some code to the stack
	// term: unify with clause
	const exec_native = tag_atm & 
	const clauses = [/*TODO*/];

	const step() = {
		let arity = 0;
		switch(tag) {
			default: throw new Error("Not callable: " + x);
			case tag_trm:
				arity = stack[stack.length-2]&value_mask; // Always a small int.
				break;
			case tag_atm:
				// Exit switch.
		}
		const matchingClauses = clauses.get(val).get(arity);
		for (const [head, body] of matchingClauses) {
			if (body.length === 1)
		}
	}
	// 1. Find matching clause
	// 2. If builtin: execute, then continue;
	// 2. Replace current term with: 
	// [...reversed clause body, clause head, x, unify]
}


