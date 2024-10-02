{
description = "My cross-platform system config flake";

inputs = {
  nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
};

outputs = { self, nixpkgs }: let
	supportedSystems = [ "x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin" ];
	forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
  pkgs = forAllSystems(system: import nixpkgs {
    inherit system;
    config.allowUnfree = true;
  });
  common-packages = (syspkgs: with syspkgs; [ #TODO
  ]);
in {
packages = forAllSystems (system: let
	syspkgs = pkgs.${system};
in with syspkgs; [
	ed
	kakoune kak-lsp emacs29 vim

	 # programming languages
	teyjus picolisp

	qmk vial # keyboard stuff

	picolisp
	droidcam android-tools scrcpy

	sqlite # for srs

	#rnix-lsp # language server protocol (for kakoune) # TODO find alt
	silver-searcher
	espeak

	#whisperWithCuda

	nethack nethack-qt

	google-cloud-sdk

	anki
	orca-c
	vscode

	ffmpeg

	direnv nix-direnv

	tigervnc
	write_stylus # just for fun
	portmidi
	picom pick-colour-picker
	hplip
	audacity
	simple-scan
	libreoffice-fresh
	imagemagick pywal wpgtk
	feh

	pcre2
	xorg.xbacklight nitrogen

	socat

	clang
	mplayer

	zoom-us
	inotify-tools
	rlwrap

	edbrowse

	# j # Stopped working after recent channel upgrade...
	#(j.overrideAttrs (oldAttrs: {
	#  postInstall = oldAttrs.postInstall or "" + ''
	#    echo "install 'all' | $JLIB/bin/jconsole"
	#    echo "install 'net/websocket' | $JLIB/bin/jconsole"
	#  '';
	#}))

	firefox w3m
	wget
	mkpasswd
	pandoc
	xclip
	jq

	pavucontrol

	cups-bjnp # printer drivers

	spotify spotifyd

	ranger tree usbutils pmount
	calibre
	rxvt_unicode kitty
	zathura #pdf reader

	polybarFull

	git zip unzip openssl

	rustc rustup
	python3Full
	swiProlog nodejs_latest tcl tk racket go
	teyjus

	bc

	plover.dev

	gcc gnumake

	qutebrowser chromium
]);
#devShells = forAllSystems (system: let
#	syspkgs = pkgs.legacyPackages.${system};
#in import ./shells.nix { inherit pkgs; }
#);
};
} #TOP
