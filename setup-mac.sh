#!/usr/bin/env bash
set -e

echo "🚀 Step 0: Starting Mac setup..."

# -----------------------
# Helper functions
# -----------------------
install_brew_pkg() {
    if ! brew list --formula | grep -q "^$1\$"; then
        echo "📦 Installing formula: $1"
        brew install "$1"
    else
        echo "✅ Formula already installed: $1"
    fi
}

install_brew_cask() {
    if ! brew list --cask | grep -q "^$1\$"; then
        echo "📦 Installing cask: $1"
        brew install --cask "$1"
    else
        echo "✅ Cask already installed: $1"
    fi
}

install_font() {
    local font_name=$1
    if ! ls ~/Library/Fonts | grep -qi "$font_name"; then
        echo "📦 Installing font: $font_name"
        brew install --cask "font-${font_name}"
    else
        echo "✅ Font already installed: $font_name"
    fi
}

# -----------------------
# Homebrew
# -----------------------
if ! command -v brew &>/dev/null; then
    echo "📦 Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
    echo "✅ Homebrew already installed."
fi

brew update

# Tap for fonts
brew tap homebrew/cask-fonts

# -----------------------
# CLI tools
# -----------------------
CLI_TOOLS=(
    git
    zsh
    starship
    fzf
    zoxide
    tmux
    neovim
    wget
    curl
    htop
)

for pkg in "${CLI_TOOLS[@]}"; do
    install_brew_pkg "$pkg"
done

# -----------------------
# Fonts
# -----------------------
NERD_FONTS=(
    jetbrains-mono-nerd-font
    fira-code-nerd-font
    cascadia-code-nerd-font
    hack-nerd-font
    meslo-lg-nerd-font
)

for font in "${NERD_FONTS[@]}"; do
    install_font "$font"
done

# -----------------------
# GUI Apps
# -----------------------
GUI_APPS=(
    wezterm
    rectangle
    obsidian
    stats
    shottr
    hiddenbar
)

for app in "${GUI_APPS[@]}"; do
    install_brew_cask "$app"
done

echo "✨ Step 0 completed — base Mac setup done!"
