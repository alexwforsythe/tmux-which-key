#!/usr/bin/env sh

set -e

#
# plugin.sh.tmux: initializes the plugin when tmux is started.
#
# TPM loads the plugin by executing all *.tmux files in the root directory, so
# this file has the "tmux" extension despite being a shell script.
#

XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-$HOME/.config}
XDG_DATA_HOME=${XDG_DATA_HOME:-$HOME/.local/share}
DEFAULT_XDG_PLUGIN_REL_PATH="tmux/plugins/tmux-which-key"

root_dir="$(cd "$(dirname "$0")" && pwd -P)"
config_file="$root_dir/config.yaml"
plugin_dir="$root_dir/plugin"
init_file="$plugin_dir/init.tmux"

# XDG

# Canonicalizes the given path.
canonicalize() {
    # We use realpath with --canonicalize-missing to handle paths that don't
    # exist. Not all versions of realpath support the flag, e.g. on macOS, but
    # GNU realpath does. grealpath may be in the path, even if it's not aliased
    # to realpath, so try it first.
    if command -v grealpath >/dev/null 2>&1; then
        grealpath --canonicalize-missing "$1"
    # The --version flag indicates GNU realpath.
    elif command -v realpath >/dev/null 2>&1 && realpath --version >/dev/null 2>&1; then
        realpath --canonicalize-missing "$1"
    # MacOS ships with python3, and it's an optional dependency of this plugin,
    # so try it next.
    elif command -v python3 >/dev/null 2>&1; then
        python3 -c "import os,sys; print(os.path.realpath(sys.argv[1]))" "$1"
    else
        # shellcheck disable=SC3028
        case $OSTYPE in
        darwin*)
            # Fall back to readlink on MacOS.
            # Note: this only works for paths that don't exist if all but the
            # last segment do exist.
            if command -v readlink >/dev/null 2>&1; then
                readlink -f "$1"
            else
                (cd "$1" 2>/dev/null && pwd -P) || printf '%s\n' "$1"
            fi
            ;;
        *)
            # Last resort: cd to the path and print the absolute path.
            (cd "$1" 2>/dev/null && pwd -P) || printf '%s\n' "$1"
            ;;
        esac

    fi
}

# Create an XDG path and set the spec's default permissions of 0700 to newly
# created directories only.
make_xdg_path() {
    old_ifs=$IFS
    IFS=/
    current_dir=""
    # Walk the path and create each directory that doesn't exist.
    for seg in $1; do
        # Skip the empty string produced by the leading slash.
        [ -z "$seg" ] && continue

        # Only create the directory and apply the mode if it doesn't exist.
        current_dir="$current_dir/$seg"
        if [ ! -d "$current_dir" ]; then
            mkdir -p "$current_dir"
            chmod 0700 "$current_dir"
        fi
    done
    IFS=$old_ifs
}

case "$(tmux show-option -gvq @tmux-which-key-xdg-enable)" in
1 | true)
    if [ -z "$HOME" ]; then
        echo "[tmux-which-key] HOME is not set. XDG support is limited to users only."
        exit 1
    fi

    # Get the relative XDG path for the plugin, or use the default.
    xdg_plugin_rel_path=$(tmux show-option -gvq @tmux-which-key-xdg-plugin-path)
    xdg_plugin_rel_path=${xdg_plugin_rel_path:-$DEFAULT_XDG_PLUGIN_REL_PATH}

    # Compute the absolute paths.
    home_dir="$(canonicalize "$HOME")"
    xdg_config_dir="$(canonicalize "$XDG_CONFIG_HOME")"
    xdg_data_dir="$(canonicalize "$XDG_DATA_HOME")"

    # Ensure the XDG paths are inside the home directory.
    case "$xdg_config_dir" in
    "$home_dir"/*) ;;
    "$home_dir") ;;
    *)
        echo "[tmux-which-key] XDG_CONFIG_HOME is outside HOME: $xdg_config_plugin_dir"
        exit 1
        ;;
    esac
    case "$xdg_data_dir" in
    "$home_dir"/*) ;;
    "$home_dir") ;;
    *)
        echo "[tmux-which-key] XDG_DATA_HOME is outside HOME: $xdg_data_plugin_dir"
        exit 1
        ;;
    esac

    # Ensure the XDG plugin paths exist.
    xdg_config_plugin_dir="$xdg_config_dir/$xdg_plugin_rel_path"
    make_xdg_path "$xdg_config_plugin_dir"
    xdg_data_plugin_dir="$xdg_data_dir/$xdg_plugin_rel_path"
    make_xdg_path "$xdg_data_plugin_dir"

    # Use the XDG plugin paths.
    config_file="$xdg_config_plugin_dir/config.yaml"
    init_file="$xdg_data_plugin_dir/init.tmux"
    ;;
esac

# /XDG

# Copy the default configs to the root directory if they don't exist yet. The
# root files are gitignored so users can customize them without breaking git
# updates.
if [ ! -f "$config_file" ]; then
    cp "$root_dir/config.example.yaml" "$config_file"
fi
if [ ! -f "$init_file" ]; then
    cp "$plugin_dir/init.example.tmux" "$init_file"
fi

# If enabled, rebuild the menu from the user config.
case "$(tmux show-option -gvq @tmux-which-key-disable-autobuild)" in
1 | true) ;;
*)
    echo "[tmux-which-key] Rebuilding menu ..."
    if command -v python3 >/dev/null 2>&1; then
        python3 -c "import sys; sys.exit(0 if sys.version_info >= (3, 8) else 1)" || {
            echo "[tmux-which-key] Python 3.8+ required" >&2
            exit 1
        }
        "$plugin_dir/build.py" "$config_file" "$init_file"
    else
        echo "[tmux-which-key] Skipping rebuild: python3 not found in PATH"
    fi
    ;;
esac

# Load the plugin.
tmux source-file "$init_file"
