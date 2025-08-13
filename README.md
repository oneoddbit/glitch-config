# 🛠️ Mac Dev Environment Setup

Este repositório contém um conjunto de scripts e configurações para configurar rapidamente um ambiente de desenvolvimento no macOS.

## Passos

### **Step 0** — Instalar base do sistema:
   1. git clone https://github.com/oneoddbit/glitch-config.git
   2. cd glitch-config
   3. chmod +x setup-mac.sh
   4. ./setup-mac.sh

Este passo:
- Instala Homebrew (se não existir)
- Instala ferramentas CLI essenciais (git, zsh, starship, fzf, zoxide, tmux, neovim, etc.)
- Instala Nerd Fonts (JetBrainsMono NF, FiraCode NF, CascadiaCode NF, Hack NF, MesloLGS NF)
- Instala aplicativos GUI básicos (WezTerm, Rectangle, Obsidian, Stats, Shottr, HiddenBar)


### **Step 1** — Configurar WM (Yabai + SKHD + SketchyBar):
   1. chmod +x step1-base.sh
   2. ./step1-base.sh

Este passo:
- Base CLI (brew, git, zsh, curl, wget, fzf, zoxide, starship)
- Fonts Nerd (JetBrainsMono NF, Fira Code NF, Caskaydia Cove NF, Hack NF)
- Window Manager:
    - Yabai
    - SKHD
    - SketchyBar


### **Step 2** — Instalar e aplicar dotfiles:
   1. chmod +x step2-apply-dotfiles.sh 
   2. ./step2-apply-dotfiles.sh

Este passo:
- **Zsh** + **Starship** (tema Saturn 2-linhas)
- **WezTerm** (sem barra de título; integra com tmux)
- **tmux** (atalhos alinhados com Yabai)
- **Neovim** (config modular com LSP/formatters)
- **Git** (`.gitconfig` + `.gitignore_global`)
- **Yabai / SKHD / SketchyBar** (configs + scripts auxiliares)


### **Step 3** — Configurar Neovim com suporte a múltiplas linguagens:
    1. chmod +x step3-setup-editors.sh
    2. ./step3-setup-editors.sh

Este passo:
- **Neovim** (com a tua config do pack, se existir)
- **VS Code** (+ extensões e settings do pack)
- **Android Studio** (+ adb/fastboot via `android-platform-tools`)
- **Xcode Command Line Tools** (nota: o **Xcode completo** instala-se na App Store)
- Neovim: :Lazy sync, :Mason, :TSUpdate
- Android: abrir Android Studio → SDK Manager → instalar SDKs/NDK necessários
- iOS: abrir App Store → instalar Xcode → abrir uma vez para concordar com licenças
- VS Code: se o comando code não existir, no VS Code: Command Palette → “Shell Command: Install 'code' command in PATH”


### **Step 4** — Ajustes de sistema (macOS tweaks):
   1. 

Este passo:
- ...




