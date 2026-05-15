#!/usr/bin/env bash
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if command -v brew >/dev/null 2>&1; then
    brew bundle --file="$DIR/Brewfile"
elif command -v apt >/dev/null 2>&1; then
    sudo apt update
    xargs -a "$DIR/apt-packages.txt" sudo apt install -y
    echo "ghostty not in apt: install manually (https://ghostty.org)"
else
    echo "no brew or apt found" >&2
    exit 1
fi

mkdir -p "$HOME/.config"
for d in nvim tmux ghostty; do
    ln -sfn "$DIR/$d" "$HOME/.config/$d"
done

echo "done"
