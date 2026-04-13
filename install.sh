#!/bin/bash

export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_BIN_HOME="${XDG_BIN_HOME:-$HOME/.local/bin}"

mkdir -p "$XDG_CONFIG_HOME"
mkdir -p "$XDG_DATA_HOME"
mkdir -p "$XDG_BIN_HOME"

cd "$(dirname "$0")"

echo "Installing packages from pkglist-base.txt"
paru -S --needed stow binutils $(cat pkglist-base.txt)

if lspci | grep -iE 'vga|3d' | grep -iq nvidia; then
    echo "Seems like you need nvidia drivers too >:3"
    paru -S --needed $(cat pkglist-nvidia.txt)
else
    echo "Skipping NVIDIA-specific packages."
fi

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
    konsave -a my_desktop
fi

echo "Done!"
