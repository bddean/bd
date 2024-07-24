#!/usr/bin/env bash
set -e

ciao build outliner

# Start server in background with repl running.
ciao toplevel                                   \
	-u 'cmds/serve.pl'                   \
	-e 'use_module(library(concurrency))'\
	-e 'use_module(library(listing))'\
	-e 'use_module(library(librowser))'\
	-e 'eng_call(serve:main, create, create)'
