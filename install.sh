#!/bin/bash

export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_BIN_HOME="${XDG_BIN_HOME:-$HOME/.local/bin}"

mkdir -p "$XDG_CONFIG_HOME"
mkdir -p "$XDG_DATA_HOME"
mkdir -p "$XDG_BIN_HOME"

cd "$(dirname "$0")"

echo "Installing packages from pkglist.txt"
paru -S --needed stow binutils $(cat pkglist.txt)

echo "Applying config using Stow"
stow -v -t "$HOME" fish
stow -v -t "$HOME" konsole
stow -v -t "$HOME" scripts
stow -v -t "$HOME" kde
stow -v -t "$HOME" vim

if [ ! -d "$XDG_DATA_HOME/vim/undo" ]; then
    mkdir -p "$XDG_DATA_HOME/vim/"{undo,swap,backup}
fi

echo "vim plugin time"
vim +PlugInstall +qall

echo "Making KDE look familiar again"
if command -v konsave &> /dev/null; then
    konsave -i my_desktop.knsv
fi

echo "Done!"
