#!/usr/bin/env bash
set -e

echo "=== Step 4: Configurar Neovim ==="

# 1. Verificar se Neovim está instalado
if ! command -v nvim &> /dev/null; then
    echo "Neovim não encontrado. Instalando via Homebrew..."
    brew install neovim
else
    echo "Neovim já instalado."
fi

# 2. Criar pasta de config se não existir
mkdir -p ~/.config/nvim

# 3. Instalar packer.nvim se não existir
PACKER_DIR="${HOME}/.local/share/nvim/site/pack/packer/start/packer.nvim"
if [ ! -d "$PACKER_DIR" ]; then
    echo "Instalando packer.nvim..."
    git clone --depth 1 https://github.com/wbthomason/packer.nvim "$PACKER_DIR"
else
    echo "packer.nvim já instalado."
fi

# 4. Copiar config do Neovim
echo "Copiando configuração do Neovim..."
cp -r ../dotfiles/nvim/* ~/.config/nvim/

# 5. Instalar Mason + LSPs + formatadores
echo "Instalando LSPs e ferramentas..."
nvim --headless +"MasonInstall clangd lua-language-server pyright rust-analyzer gopls typescript-language-server eslint_d omnisharp csharpier jdtls google-java-format" +qall

# 6. Instalar Treesitter e plugins
echo "Instalando plugins e Treesitter..."
nvim --headless +PackerSync +TSUpdate +qall

echo "=== Neovim configurado com sucesso! ==="
echo "✅ Done. Open Neovim and run :Lazy sync, :Mason, :TSUpdate"