#!/usr/bin/env bash

primary='{{colors.primary.default.hex}}'
hex=${primary

r=$((16
g=$((16
b=$((16
ansi=$((16 + (r * 5 + 127) / 255 * 36 + (g * 5 + 127) / 255 * 6 + (b * 5 + 127) / 255))

ORIG_PATH=$(echo "$PATH" | tr ":" "\n" | grep -v "$HOME/.local/bin" | tr "\n" ":")

exec env PATH="$ORIG_PATH" pipes.sh -c "$ansi" "$@"
