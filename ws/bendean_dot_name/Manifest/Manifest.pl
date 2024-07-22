:- bundle(bendean_dot_name).
version('0.1').
depends([
	core
]).
alias_paths([
  bendean_dot_name=src,
  library=lib
]).
lib(lib).
cmd(bendean_dot_name, [main= 'cmds/serve']).
