#!/usr/bin/env bash
set -e


(
cat <<'EOF'
	changequote(`{|', `|}')dnl
	define({|CAT|}, {|$1$2$2$4$5|})
	define({|REPEAT|}, {|ifelse(eval({|$2 <= 0|}), {|1|}, {||}, {|$1{||}ifelse(eval({|$2 > 1|}), {|1|}, {|REPEAT({|$1|}, eval({|$2 - 1|}))|})|})|})dnl
EOF

	cat pl.m4.js
) | m4 > pl.js
