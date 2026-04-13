# installation

1. clone the repo, obviously
2. make the installer executable, obviously
3. run these:
    ```bash
    rm -rf ~/.config/fish
    rm -rf ~/.local/share/konsole

    rm -f ~/.local/bin/{backup-excludes.txt,daily-backup.sh}
    rm -f ~/.config/{kdeglobals,konsolerc,kwinrc,plasmarc}

    rm -rf ~/.config/vim
    ```
4. run `./install.sh`
