#!/usr/bin/env bash
sleep 5
konsole --separate -e bash -lc 'exec "$HOME/.local/bin/rice-cmatrix"' &
matrix_pid=$!
sleep 2
konsole --separate -e bash -lc 'exec "$HOME/.local/bin/rice-cava"' &
cava_pid=$!
"$HOME/.local/bin/rice-position-startup" "$matrix_pid" "$cava_pid" &
