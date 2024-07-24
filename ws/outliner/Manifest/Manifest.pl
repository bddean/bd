:- bundle(outliner).
version('0.1').
depends([
	core
]).
alias_paths([
  ol=src,
  library=lib
]).
lib(lib).
cmd(outliner, [main= 'cmds/serve']).
