#!/usr/bin/env bash
set -euo pipefail

echo "🔧 Installing dev tools via Homebrew…"

# Core utils
brew install ripgrep fd fzf jq

# LSP helpers / linters / formatters
brew install \
  clang-format cppcheck \
  go golangci-lint \
  rustup-init \
  prettierd eslint_d black flake8 stylua

# C# / .NET
brew install --cask dotnet-sdk
brew install csharpier

# Java
brew install openjdk google-java-format

# Optional: build tools
brew install cmake make

# Rust toolchain + rustfmt
if ! command -v rustup >/dev/null 2>&1; then
  rustup-init -y
fi
~/.cargo/bin/rustup component add rustfmt || true

# fzf keybindings (se ainda não corridos)
"$(brew --prefix 2>/dev/null)"/opt/fzf/install --key-bindings --completion --no-update-rc || true
# Linkar Java (caso necessário)
sudo ln -sfn $(brew --prefix)/opt/openjdk/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk.jdk || true


echo "✅ Done. Open Neovim and run :Lazy sync, :Mason, :TSUpdate"
