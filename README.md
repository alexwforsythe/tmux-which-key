# tmux-which-key

A plugin for tmux that allows users to select actions from a customizable popup
menu. Inspired by the likes of
[vscode-which-key](https://github.com/VSpaceCode/vscode-which-key),
[emacs-which-key](https://github.com/justbur/emacs-which-key), and
[which-key.nvim](https://github.com/folke/which-key.nvim).

## Features

- An action menu with many of the common tmux commands
- Mnemonic layout for easy memorization
- Transient states (menus that stay open for repeated commands)

## Installation

### Requirements

- tmux>=3.0

### TPM ([Tmux Plugin Manager](https://github.com/tmux-plugins/tpm/tree/master#installing-plugins))

Add the plugin to the list of TPM plugins in your `~/.tmux.conf`:

```tmux
set -g @plugin 'alexwforsythe/tmux-which-key'
```

Hit <kbd>prefix</kbd> + <kbd>I</kbd> to install and load the plugin. You'll be
presented with a wizard to complete the installation.

### Manual

1. Clone this repository flag:

```sh
git clone https://github.com/alexwforsythe/tmux-which-key $HOME/.tmux/plugins/
```

2. Register the plugin in your `~/.tmux.conf`:

```tmux
run-shell $PATH_TO_PLUGIN/plugin.sh.tmux
```

3. Reload your tmux config to load the plugin:

```sh
tmux source-file $HOME/.tmux.conf
```

## TODO

Actions

- [ ] Add action to swap windows
- [ ] Add action to join panes

Customization

- [ ] Allow customizing menus without changing the git working tree (this breaks
      upgrades with TPM)
- [ ] Allow customization via YAML config

Performance

- [ ] Reimplement in pure tmux script for speed
- [ ] Bind menu keys to the tmux key-table until escape, or maybe we can use
      `command-prompt -k -i` to repeat commands

## Resources

- [How to create Tmux plugins](https://github.com/tmux-plugins/tpm/blob/master/docs/how_to_create_plugin.md)