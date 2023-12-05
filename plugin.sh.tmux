#!/usr/bin/env sh

set -e

#
# plugin.sh.tmux: initializes the plugin when tmux is started.
#
# TPM loads the plugin by executing all *.tmux files in the root directory, so
# this file has the "tmux" extension despite being a shell script.
#

root_dir="$(dirname "$(readlink -f "$0")")"
plugin_dir="$root_dir/plugin"
init_file="$plugin_dir/init.tmux"

# Copy the default config to the root directory if it doesn't exist yet. The
# root file is gitignored so users can customize it without breaking git
# updates.
[ ! -f "$init_file" ] && cp "$plugin_dir/init.example.tmux" "$init_file"

# Load the plugin.
tmux source-file "$init_file"
