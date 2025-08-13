#!/usr/bin/env bash
set -e

echo "📦 Installing dotfiles (with backup)..."

copy_with_backup() {
    local src=$1
    local dest=$2
    local current_time=$(date +"%Y%m%d%H%M%S")

    if [ -f "$dest" ]; then
        backup_file="${dest}.${current_time}.bak"
        cp "$dest" "$backup_file"
        echo "🔹 Backup $dest created as $backup_file."
    fi

    cp "$src" "$dest"
    echo "✅ Copied $src → $dest"
}

# Zsh
copy_with_backup "$(pwd)/zsh/.zshrc" "$HOME/.zshrc"
copy_with_backup "$(pwd)/zsh/.p10k.zsh" "$HOME/.p10k.zsh"
mkdir -p "$HOME/.config"
copy_with_backup "$(pwd)/zsh/starship.toml" "$HOME/.config/starship.toml"

# Tmux
copy_with_backup "$(pwd)/tmux/.tmux.conf" "$HOME/.tmux.conf"

# Git
copy_with_backup "$(pwd)/git/.gitconfig" "$HOME/.gitconfig"

# Neovim
mkdir -p "$HOME/.config/nvim"
copy_with_backup "$(pwd)/nvim/init.lua" "$HOME/.config/nvim/init.lua"

echo "✨ All dotfiles installed with backup!"
