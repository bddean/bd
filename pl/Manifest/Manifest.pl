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
%cmd(bendean_dot_name, [main= 'cmds/serve']).
