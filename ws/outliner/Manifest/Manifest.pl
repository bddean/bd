:- bundle(outliner).
version('0.1').
depends([
	core
]).
alias_paths([
  outliner=src,
  library=lib
]).
lib(lib).
cmd(outliner, [main= 'cmds/serve']).
