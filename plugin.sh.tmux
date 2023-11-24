#!/usr/bin/env sh

#
# plugin.sh.tmux: initializes the plugin when tmux is started.
#
# TPM runs the plugin by executing all *.tmux files in the root directory, so
# despite being a shell script, it uses the "tmux" extension.
#

set -e

script_dir="$(dirname "$(readlink -f "$0")")"

tmux bind-key -n -N 'Open the tmux-action-menu' \
    "C-space run '$script_dir/which-key.sh tmux'"
