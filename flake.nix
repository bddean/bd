{ ###### TOPLEVEL

inputs = {
  # Ciao prolog bundles. In theory we should be able to just put these
  # in our CIAOPATH workspace, but sometimes they only work when installed
  # in CIAOROOT.
  ciaodbg = {
  	url = "github:ciao-lang/ciaodbg";
  	flake = false;
  };
};

outputs = { self, nixpkgs, ciaodbg }: let
	pkgs = nixpkgs.legacyPackages.x86_64-linux;
	my-ciao = pkgs.ciao.overrideAttrs(oldAttrs : {
		buildPhase =  ''
			cp -r ${ciaodbg} ./ciaodbg
			chmod -R u+w ./ciaodbg
			${oldAttrs.buildPhase}
		'';
	});
in {
	devShells.x86_64-linux.default = pkgs.mkShell {
		buildInputs = with pkgs; [
			caddy
			rsync
			my-ciao
		];
		shellHook = ''
			export CIAOPATH="$PWD/ws"
			export PATH="$PWD/ws/build/bin:$PATH"
		'';
	};
};

} ###### TOPLEVEL
