{ ###### TOPLEVEL

inputs = {
  #nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
};

outputs = { self, nixpkgs }: let
	pkgs = nixpkgs.legacyPackages.x86_64-linux;
in {
	devShells.x86_64-linux.default = pkgs.mkShell {
		buildInputs = with pkgs; [
			ciao
			rsync
		];
		shellHook = ''
			export CIAOPATH="$PWD/ws"
			export PATH="$PWD/ws/build/bin:$PATH"
		'';
	};
};

} ###### TOPLEVEL
