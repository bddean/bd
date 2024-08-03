:- bundle(pl).
version('0.1').
depends([
	core,
	ciaodbg
]).
alias_paths([
  library='.'
]).
lib('.').
cmd(bd, [main='cmds/bd']).
