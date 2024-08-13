export const firstAncestorMatching = (n, sel) => {
	if (! n) return null;
	if (n.matches?.(sel)) return n;
	return firstAncestorMatching(n.parentElement, sel);
}


