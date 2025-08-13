#!/usr/bin/env bash
set -e

echo "===== STEP 1: Base macOS Setup ====="

# Função para verificar se um comando existe
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Instalar Xcode Command Line Tools
if ! xcode-select -p &>/dev/null; then
    echo "[+] Installing Xcode Command Line Tools..."
    xcode-select --install
    echo "[i] Please complete the installation and rerun the script."
    exit 0
else
    echo "[✓] Xcode Command Line Tools already installed."
fi

# Instalar Homebrew
if ! command_exists brew; then
    echo "[+] Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
    eval "$(/opt/homebrew/bin/brew shellenv)"
else
    echo "[✓] Homebrew already installed."
    brew update
fi

# Lista de pacotes essenciais
ESSENTIALS=(
    git
    zsh
    curl
    wget
    fzf
    zoxide
    starship
)

echo "[+] Installing essential CLI tools..."
brew install "${ESSENTIALS[@]}"

# Instalar Nerd Fonts
FONTS=(
    font-jetbrains-mono-nerd-font
    font-fira-code-nerd-font
    font-caskaydia-cove-nerd-font
    font-hack-nerd-font
)

echo "[+] Installing Nerd Fonts..."
brew tap homebrew/cask-fonts
for font in "${FONTS[@]}"; do
    if brew list --cask "$font" &>/dev/null; then
        echo "[✓] $font already installed."
    else
        brew install --cask "$font"
    fi
done

# Window Manager & Bar
WM_APPS=(
    yabai
    skhd
    sketchybar
)
# Instalar ferramentas de gerenciamento de janelas
echo "[+] Installing WM tools..."
brew install "${WM_APPS[@]}"

echo "[✓] STEP 1 completed successfully."
