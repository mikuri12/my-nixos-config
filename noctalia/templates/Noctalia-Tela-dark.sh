#!/usr/bin/env bash
PRI="{{colors.primary.default.hex}}"
C1="${PRI:1}"
THEME_NAME="Noctalia-Tela-dark"
T_DIR="$HOME/.icons/$THEME_NAME"
BRANCH="color-${C1}"

if [[ ! -d "$T_DIR/.git" ]]; then
    git -C "$T_DIR" init -q
    git -C "$T_DIR" add -A
    git -C "$T_DIR" commit -q -m "original"
    git -C "$T_DIR" tag "original"
fi

git -C "$T_DIR" checkout -q main
git -C "$T_DIR" checkout -q "original" -- .
git -C "$T_DIR" add -A
git -C "$T_DIR" commit -q --allow-empty -m "restored"

git -C "$T_DIR" branch | grep "color-" | xargs -r git -C "$T_DIR" branch -D 2>/dev/null || true
git -C "$T_DIR" checkout -q -b "$BRANCH"

find "$T_DIR" -name "*.svg" -path "*/places/*" -type f -print0 | xargs -0 sed -i \
    -e "s/\.ColorScheme-Highlight { color:#[0-9a-fA-F]\{6\}/\.ColorScheme-Highlight { color:#${C1}/gI" \
    -e "s/\.ColorScheme-Text { color:#[0-9a-fA-F]\{6\}/\.ColorScheme-Text { color:#${C1}/gI" \
    -e "s/fill=\"currentColor\"/fill=\"#${C1}\"/gI"

git -C "$T_DIR" add -A
git -C "$T_DIR" commit -q -m "color-$C1"

gtk-update-icon-cache -f -t "$T_DIR" 2>/dev/null

CURRENT=$(gsettings get org.gnome.desktop.interface icon-theme | tr -d "'")
if [[ "$CURRENT" == "$THEME_NAME" ]]; then
    gsettings set org.gnome.desktop.interface icon-theme "hicolor" 2>/dev/null
    sleep 0.3
fi
gsettings set org.gnome.desktop.interface icon-theme "$THEME_NAME" 2>/dev/null

gio set ~/Escritorio metadata::custom-icon-name "user-desktop" 2>/dev/null || true
gio set ~/Desktop metadata::custom-icon-name "user-desktop" 2>/dev/null || true
