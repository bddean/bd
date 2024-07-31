:- bundle(pl).
version('0.1').
depends([
	core,
	unittest
]).
alias_paths([
  library=lib
]).
lib(lib).
%cmd(bendean_dot_name, [main= 'cmds/serve']).
