Output layouts.gif

Require tmux

Set FontSize 16
Set FontFamily "MesloLGS Nerd Font Mono"
Set Theme { "name": "Tomorrow Night Eighties", "black": "#2d2d2d", "red": "#f2777a", "green": "#99cc99", "yellow": "#ffcc66", "blue": "#6699cc", "magenta": "#cc99cc", "cyan": "#66cccc", "white": "#ffffff", "brightBlack": "#999999", "brightRed": "#f2777a", "brightGreen": "#99cc99", "brightYellow": "#ffcc66", "brightBlue": "#6699cc", "brightMagenta": "#cc99cc", "brightCyan": "#66cccc", "brightWhite": "#ffffff", "background": "#2d2d2d", "foreground": "#cccccc", "cursor": "#cccccc", "selection": "#515151" }
Set Padding 0
Set PlaybackSpeed 0.75

Hide
Type "tmux" Sleep .5
Enter Sleep 1
Enter Sleep 1
Show
Sleep 1

Enter@100ms 3
Type `echo pane 0` Sleep .5
Enter Sleep 1

Ctrl+Space Sleep 1
Type "w" Sleep .5
Type "/" Sleep .5

Enter@100ms 2
Type `echo pane 1` Sleep .5
Enter Sleep 1

Ctrl+Space Sleep 1
Type "w" Sleep .5
Type "-" Sleep .5

Enter@100ms 2
Type `echo pane 2` Sleep .5
Enter Sleep 1

Type `echo "Now, let's cycle through some layouts."` Sleep .5
Enter Sleep 1

Ctrl+Space Sleep 1
Type "w" Sleep 1
Type "l" Sleep 1
Type "l" Sleep 1
Type "l" Sleep 1
Sleep 2
Type "l" Sleep 1
Type "l" Sleep 1
Type "l" Sleep 1
Escape
Sleep 1

Ctrl+Space Sleep 1
Type "p" Sleep 1
Type "p" Sleep 1
Type "0" Sleep 1

Type `echo Welcome back.` Sleep .5
Enter Sleep 1

Sleep 2
