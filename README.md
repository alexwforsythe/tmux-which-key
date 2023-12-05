# tmux-which-key

A plugin for tmux that allows users to select actions from a customizable popup
menu. Inspired by the likes of
[vscode-which-key](https://github.com/VSpaceCode/vscode-which-key),
[emacs-which-key](https://github.com/justbur/emacs-which-key), and
[which-key.nvim](https://github.com/folke/which-key.nvim).

## Features

- An action menu with many of the common tmux commands
- Mnemonic layout for easy memorization
- Easily customizable extensible via YAML configuration
- Support for user macros (multiple commands in one action)
- Transient states (menus that stay open for repeated commands)
- Runs in pure tmux script for speed

## Installation

### Requirements

- tmux>=3.0
- python>=3.8 (optional)

### TPM ([Tmux Plugin Manager](https://github.com/tmux-plugins/tpm/tree/master#installing-plugins))

Add the plugin to the list of TPM plugins in your `~/.tmux.conf`:

```tmux
set -g @plugin 'alexwforsythe/tmux-which-key'
```

Hit <kbd>prefix</kbd> + <kbd>I</kbd> to install and load the plugin. You'll be
presented with a wizard to complete the installation.

### Manual

1. Clone this repository flag using the `--recursive` flag:

```sh
git clone --recursive https://github.com/alexwforsythe/tmux-which-key $HOME/.tmux/plugins/
```

2. Register the plugin in your `~/.tmux.conf`:

```tmux
run-shell $PATH_TO_PLUGIN/plugin.sh.tmux
```

3. Reload your tmux config to load the plugin:

```sh
tmux source-file $HOME/.tmux.conf
```

## Customization

Menus can be customized by either:

1. Editing `config.yaml` (requires python3), or
2. Editing `plugin/init.tmux` directly

### YAML configuration

This method requires python3 to be installed on your system. Most Unix systems
ship with it installed by default these days, so it shouldn't be a problem for
most users. If you don't have python3 installed and aren't willing to use it,
you'll need to edit `plugin/init.tmux` directly.

You can find the default configuration in `config.example.yaml`. The config file
follows this structure:

```yaml
# The starting index to use for the command-alias option, used for macros
# (required). This value must be at least 200
command_alias_start_index: 200
# The keybindings that open the action menu (required)
keybindings:
  prefix_table: Space # The keybinding for the prefix key table (required)
  root_table: C-Space # The keybinding for the root key table (optional)
# The menu title config (optional)
title:
  style: align=centre,bold # The title style
  prefix: tmux # A prefix added to every menu title
  prefix_style: fg=green,align=centre,bold # The prefix style
# The menu position (optional)
position:
  x: R
  y: P
# tmux-only environment variables that can be used in commands and macros
# (optional)
custom_variables:
  my_var: my_value
# User-defined macros that can be triggered by the menu (optional)
macros:
  restart-pane: # The macro name
    # The macro commands
    - "respawnp -k -c #{pane_current_path}"
    - display "#{log_info} Pane restarted"
# The root menu items (required)
items:
  - name: Next pane
    key: space # The key that triggers this action
    command: next-pane # A command to run
  - name: Respawn pane
    key: R
    macro: restart-pane # A custom macro (defined above)
  - separator: true # A menu separator
  - name: +Layout # A submenu
    key: l
    menu: # The submenu items
      - name: Next
        key: l
        command: nextl
        transient: true # Whether to keep the menu open until ESC is pressed
```

#### User options

##### @tmux-which-key-disable-autobuild

By default, the menu is rebuilt from `config.yaml` each time the plugin is
initialized by TPM. If you aren't using the YAML configuration or want to reduce
the plugin's impact on tmux startup time, you can disable this behavior by
adding this to your `~/.tmux.conf` **before** loading the plugin:

```tmux
set -g @tmux-which-key-disable-autobuild=1
# ...
set -g @plugin 'alexwforsythe/tmux-which-key'
```

### Manual configuration

I strongly recommend using YAML to customize your action menu because editing
tmux script can be error-prone and difficult to debug.

You can customize the action menu by editing `plugin/init.tmux` directly.

## Common issues

### My menu or submenu isn't appearing

Menus will silently fail to open if the number of items causes them to exceed
the height of the terminal. If you run into this issue frequently, consider
breaking you menu into multiple submenus.

### The plugin is overriding my custom aliases

tmux-which-key uses tmux `command-alias` to execute certain actions, such as
macros, quickly. `command-alias` is a global option, though, so these actions
can collide with user aliases or ones defined by other plugins.

This plugin's aliases start at index 200 by default, but if there are already
aliases mapped in this range, you can change the default starting index in
`config.yaml`.

## TODO

Actions

- [ ] Add action to swap windows
- [ ] Add action to join panes
- [ ] Add backspace keybinding to go to previous menu

Customization

- [ ] Inject each menus name into the title

## Resources

- `man tmux`
- [Tmux Wiki](https://github.com/tmux/tmux/wiki)
- [How to create Tmux plugins](https://github.com/tmux-plugins/tpm/blob/master/docs/how_to_create_plugin.md)
- [The Tao of tmux](https://leanpub.com/the-tao-of-tmux/read)
