		{#BEGIN
inputs = {
	nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
	ciaodbg = {
		url = "github:ciao-lang/ciaodbg";
		flake = false;
	};
};

outputs = { self, nixpkgs, ciaodbg }: let
		supportedSystems = [ "x86_64-linux" "x86_64-darwin" "aarch64-darwin" ];
		forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
		nixpkgsFor = forAllSystems (system: import nixpkgs { inherit system; });
in {
	devShells = forAllSystems (system:
		let
			pkgs = nixpkgsFor.${system};
			my-ciao = pkgs.ciao.overrideAttrs(oldAttrs : {
				buildPhase = ''
					cp -r ${ciaodbg} ./ciaodbg
					chmod -R u+w ./ciaodbg
					${oldAttrs.buildPhase}
				'';
			});
		in
		{
			default = pkgs.mkShell {
				buildInputs = with pkgs; [
					caddy
					rsync
					my-ciao
					gnum4
				];
				shellHook = ''
					export BD_ROOT="$PWD"
					export CIAOPATH="$PWD"
					export PATH="$PWD/build/bin:$PATH"
				'';
			};
		}
	);
};
		}#END
