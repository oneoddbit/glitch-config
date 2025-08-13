#!/usr/bin/env bash
set -e

echo "📦 Syncing dotfiles (rsync mode)..."

sync_dotfiles() {
    local src=$1
    local dest=$2
    rsync -avh --progress "$src" "$dest"
    echo "✅ Synced $src → $dest"
}

# Zsh
sync_dotfiles "$(pwd)/zsh/.zshrc" "$HOME/"
sync_dotfiles "$(pwd)/zsh/.p10k.zsh" "$HOME/"
mkdir -p "$HOME/.config"
sync_dotfiles "$(pwd)/zsh/starship.toml" "$HOME/.config/"

# Tmux
sync_dotfiles "$(pwd)/tmux/.tmux.conf" "$HOME/"

# Git
sync_dotfiles "$(pwd)/git/.gitconfig" "$HOME/"

# Neovim
mkdir -p "$HOME/.config/nvim"
sync_dotfiles "$(pwd)/nvim/init.lua" "$HOME/.config/nvim/"

echo "✨ All dotfiles synced!"
