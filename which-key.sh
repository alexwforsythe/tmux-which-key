#!/usr/bin/env dash
#
# Use dash because of its fast startup time.
#

set -e

script_path="$(readlink -f "$0")"
readonly cmd_show_menu=$script_path
readonly menu_name=${1:-tmux}
readonly plugins_dir="$HOME/.tmux/plugins"

show_menu() {
    tmux menu -x R -y P -T "#[align=centre,bold fg=green]$menu_name" "$@"
}

cmd_menu_reopen="run '$cmd_show_menu $menu_name'"
readonly cmd_menu_reopen

case $menu_name in
tmux)
    show_menu \
        Run space command-prompt \
        'Last window' tab last-window \
        'Last pane' '`' lastp \
        +Copy c "run '$cmd_show_menu Copy'" \
        '' \
        +Windows w "run '$cmd_show_menu Windows'" \
        +Panes p "run '$cmd_show_menu Panes'" \
        +Buffers b "run '$cmd_show_menu Buffers'" \
        +Sessions s "run '$cmd_show_menu Sessions'" \
        +Client C "run '$cmd_show_menu Client'" \
        '' \
        'Time' T clock-mode \
        'Show messages' '~' showmsgs \
        +Keys '?' 'list-keys -N'
    ;;
Copy)
    show_menu \
        Copy c 'copy-mode' \
        'List buffers' '#' lsb
    ;;
Windows)
    show_menu \
        Last tab lastw \
        Choose w 'choose-tree -Zw' \
        Previous p prev \
        Next n next \
        New c 'neww -c "#{pane_current_path}"' \
        '' \
        +Layout l "run '$cmd_show_menu Layout'" \
        'Split horizontal' / 'splitw -h -c "#{pane_current_path}"' \
        'Split vertical ' - 'splitw -v -c "#{pane_current_path}"' \
        'Rotate' o rotatew \
        'Rotate reverse' O 'rotatew -D' \
        '' \
        Rename R "command-prompt -I \"#W\" \"renamew -- '%%'\"" \
        Kill X 'confirm -p "Kill window #W? (y/n)" killw'
    ;;
Panes)
    show_menu \
        Last tab lastp \
        Choose p 'displayp -d 0' \
        '' \
        Left h 'selectp -L' \
        Down j 'selectp -D' \
        Up k 'selectp -U' \
        Right l 'selectp -R' \
        '' \
        Zoom z 'resizep -Z' \
        +Resize r "run '$cmd_show_menu Resize'" \
        'Swap left' H 'swapp -L' \
        'Swap down' J 'swapp -D' \
        'Swap up' K 'swapp -U' \
        'Swap right' L 'swapp -R' \
        'Break' '!' break-pane \
        '' \
        Mark m 'selectp -m' \
        Unmark M 'selectp -M' \
        Capture C capturep \
        Respawn R 'confirm -p "Respawn pane #P? (y/n)" "respawnp -k"' \
        Kill X 'confirm -p "Kill pane #P? (y/n)" killp'
    ;;
Resize)
    tmux_resize() {
        echo resizep "$@" \; "$cmd_menu_reopen"
    }

    show_menu \
        Zoom z 'resizep -Z' \
        Left h "$(tmux_resize -L 10)" \
        Down j "$(tmux_resize -D 10)" \
        Up k "$(tmux_resize -U 10)" \
        Right l "$(tmux_resize -R 10)" \
        'Left less' H "$(tmux_resize -L)" \
        'Down less' J "$(tmux_resize -D)" \
        'Up less' K "$(tmux_resize -U)" \
        'Right less' L "$(tmux_resize -R)"
    ;;
Layout)
    show_menu \
        Next l 'nextl' \
        Tiled t 'selectl tiled' \
        Horizontal h 'selectl even-horizontal' \
        Vertical v 'selectl even-vertical' \
        'Horizontal main' H 'selectl main-horizontal' \
        'Vertical main' V 'selectl main-vertical'
    ;;
Buffers)
    show_menu \
        Choose b 'choose-buffer -Z' \
        List l lsb \
        Paste p pasteb
    ;;
Sessions)
    show_menu \
        Choose s 'choose-tree -Zs' \
        New N new \
        Rename r rename
    ;;
Client)
    show_menu \
        Choose c 'choose-client -Z' \
        Last l 'switchc -l' \
        Previous p 'switchc -p' \
        Next n 'switchc -n' \
        '' \
        Refresh R refresh \
        +Plugins P "run '$cmd_show_menu Plugins'" \
        Detach D detach \
        'Suspend' Z suspendc \
        '' \
        'Reload config' r "source $HOME/.tmux.conf \; display \"#{E:'\\ueb37'}\" Config loaded" \
        'Customize' , 'customize-mode -Z'
    ;;
Plugins)
    readonly tpm_dir="$plugins_dir/tpm/bindings"

    show_menu \
        Install i "$tpm_dir/install_plugins" \
        Update u "$tpm_dir/update_plugins" \
        Clean c "$tpm_dir/clean_plugins"
    ;;
esac
