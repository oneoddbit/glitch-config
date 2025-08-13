#!/usr/bin/env bash
set -Eeuo pipefail

# ==========================================
# macOS bootstrap — Saturn Pursuit (idempotente)
# ==========================================
# Usa:  ./install-macos-full.sh
# Flags: --apps-only --dotfiles-only --dev-only --no-casks --dry-run

DRY_RUN=0
APPS=1 DOTFILES=1 DEV=1 CASKS=1

for arg in "$@"; do
  case "$arg" in
    --apps-only)     DOTFILES=0; DEV=0 ;;
    --dotfiles-only) APPS=0; DEV=0 ;;
    --dev-only)      APPS=0; DOTFILES=0 ;;
    --no-casks)      CASKS=0 ;;
    --dry-run)       DRY_RUN=1 ;;
    *) ;;
  esac
done

say() { printf "\033[1;36m==>\033[0m %s\n" "$*"; }
warn(){ printf "\033[1;33m⚠\033[0m %s\n" "$*"; }
err() { printf "\033[1;31m✘ %s\033[0m\n" "$*" >&2; }
doit(){ if [[ $DRY_RUN -eq 1 ]]; then echo "DRY: $*"; else eval "$@"; fi }

# ---------- Pré-requisitos ----------
ensure_xcode_clt() {
  if ! xcode-select -p >/dev/null 2>&1; then
    say "A instalar Xcode Command Line Tools…"
    doit "xcode-select --install || true"
    warn "Se aparecer um diálogo do macOS, aceita e volta a correr o script quando terminar."
  else
    say "Xcode CLT OK"
  fi
}

ensure_homebrew() {
  if ! command -v brew >/dev/null 2>&1; then
    say "Homebrew não encontrado — a instalar…"
    doit '/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"'
    # shellenv
    if [[ -x /opt/homebrew/bin/brew ]]; then
      eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [[ -x /usr/local/bin/brew ]]; then
      eval "$(/usr/local/bin/brew shellenv)"
    fi
  else
    say "Homebrew OK — brew update…"
    doit "brew update"
  fi
}

brew_prefix() {
  brew --prefix 2>/dev/null || echo "/opt/homebrew"
}

has_formula() { brew list --formula --versions "$1" >/dev/null 2>&1; }
has_cask()    { brew list --cask --versions "$1"    >/dev/null 2>&1; }

install_formula() {
  local f="$1"
  if has_formula "$f"; then
    say "formula já instalada: $f"
  else
    say "brew install $f"
    doit "brew install \"$f\""
  fi
}

install_cask() {
  local c="$1"
  if [[ $CASKS -eq 0 ]]; then
    warn "saltado (no-casks): $c"
    return
  fi
  if has_cask "$c"; then
    say "cask já instalado: $c"
  else
    say "brew install --cask $c"
    doit "brew install --cask \"$c\""
  fi
}

# ---------- Listas de instalação ----------
FORMULAE=(
  # shell & utils
  git tmux zsh starship neovim eza bat btop fzf ripgrep fd thefuck tree jq zoxide
  # linguagens & toolchains
  python lua@5.4 go rustup-init
  # dev helpers
  cmake make clang-format cppcheck
  # editors/cli
  # (VS Code CLI é instalado pelo app; aqui só garantimos nvim)
  # ai / ollama
  ollama
)

CASKS=(
  wezterm
  visual-studio-code
  docker
  # browsers
  brave-browser firefox
  # barras/ux
  rectangle hiddenbar stats shottr
  # bar/tiling (requere permissões mais tarde)
  skhd sketchybar
)

# Yabai é especial (exige permissões e por vezes assinatura); ainda assim instalamos via cask
CASKS_YABAI=( yabai )

# Opcional: fontes — evitar tap antigo; tenta instalar JetBrains Mono (Nerd Font) se disponível
CASKS_FONTS=( font-jetbrains-mono-nerd-font )

# ---------- Apps ----------
install_apps() {
  say "Instalar/atualizar fórmulas…"
  for f in "${FORMULAE[@]}"; do install_formula "$f"; done

  say "Instalar/atualizar casks…"
  for c in "${CASKS[@]}"; do install_cask "$c"; done

  # Yabai separado para caso falhe assinatura/SIP
  say "Instalar yabai (cask)…"
  install_cask "yabai" || warn "yabai pode requerer permissões/ajustes manuais."

  # Nerd Font (tenta, mas não falha se indisponível)
  if brew search --casks font-jetbrains-mono-nerd-font >/dev/null 2>&1; then
    install_cask "font-jetbrains-mono-nerd-font"
  else
    warn "Nerd Font via cask não disponível — certifica-te que tens uma Nerd Font instalada (JetBrainsMono, FiraCode, etc.)."
  fi

  # fzf keybindings/completion
  if [[ $DRY_RUN -eq 0 ]]; then
    local FZF_INST="$(brew_prefix)/opt/fzf/install"
    [[ -x "$FZF_INST" ]] && "$FZF_INST" --key-bindings --completion --no-update-rc || true
  fi

  # ollama + modelo olmo2
  if command -v ollama >/dev/null 2>&1 && [[ $DRY_RUN -eq 0 ]]; then
    say "Ollama pull olmo2…"
    ollama pull olmo2 || warn "falhou o pull do modelo olmo2 (tenta manualmente depois)."
  fi

  # Rust toolchain + rustfmt
  if command -v rustup >/dev/null 2>&1; then
    doit "rustup show >/dev/null 2>&1 || rustup-init -y"
    doit "rustup component add rustfmt || true"
  else
    doit "rustup-init -y"
    doit "~/.cargo/bin/rustup component add rustfmt || true"
  fi
}

# ---------- Dev extras (linters/formatters) ----------
install_dev_tools() {
  say "Ferramentas de dev (linters/formatters)…"
  local extra=(
    golangci-lint
    prettierd eslint_d black flake8 stylua
    google-java-format
    csharpier
    openjdk
    dotnet-sdk
  )
  for f in "${extra[@]}"; do
    # alguns são casks (dotnet-sdk), outros fórmulas
    if brew info --cask "$f" >/dev/null 2>&1; then
      install_cask "$f"
    else
      install_formula "$f"
    fi
  done

  # Link do JDK (evita problemas com jdtls)
  if [[ $DRY_RUN -eq 0 ]]; then
    sudo ln -sfn "$(brew --prefix)/opt/openjdk/libexec/openjdk.jdk" \
      /Library/Java/JavaVirtualMachines/openjdk.jdk 2>/dev/null || true
  fi
}

# ---------- Dotfiles ----------
apply_dotfiles() {
  local ROOT="$HOME/conf-files/dotfiles"
  if [[ ! -d "$ROOT" ]]; then
    err "Pasta de dotfiles não encontrada em ~/conf-files/dotfiles"
    warn "Clona ou move o teu pack para ~/conf-files/dotfiles e volta a correr."
    return 1
  fi

  say "Aplicar dotfiles (com backup)…"
  if [[ -x "$ROOT/install-dotfiles-copy.sh" ]]; then
    (cd "$ROOT" && doit "./install-dotfiles-copy.sh")
  else
    warn "Script install-dotfiles-copy.sh não encontrado — a copiar manualmente o essencial…"
    doit "mkdir -p ~/.config"
    # Zsh / Starship
    doit "cp -a \"$ROOT/zsh/.zshrc\" ~/"
    doit "cp -a \"$ROOT/zsh/.zprofile\" ~/"
    doit "mkdir -p ~/.config && cp -a \"$ROOT/zsh/starship.toml\" ~/.config/starship.toml"
    # tmux
    doit "cp -a \"$ROOT/tmux/.tmux.conf\" ~/"
    # WezTerm
    doit "cp -a \"$ROOT/wezterm/.wezterm.lua\" ~/"
    # Yabai / SKHD / Sketchybar / NVIM / Git
    doit "mkdir -p ~/.config/yabai ~/.config/skhd ~/.config/sketchybar ~/.config/nvim"
    doit "cp -a \"$ROOT/yabai/yabairc\" ~/.config/yabai/yabairc"
    doit "cp -a \"$ROOT/skhd/skhdrc\" ~/.config/skhd/skhdrc"
    doit "cp -a \"$ROOT/sketchybar/sketchybarrc\" ~/.config/sketchybar/sketchybarrc"
    doit "cp -a \"$ROOT/nvim/\"* ~/.config/nvim/"
    doit "cp -a \"$ROOT/git/.gitconfig\" ~/"
    [[ -f \"$ROOT/git/.gitignore_global\" ]] && doit "cp -a \"$ROOT/git/.gitignore_global\" ~/"
  fi

  # Garantir executáveis dos helpers
  [[ -x "$HOME/conf-files/shellscripts/tmux_git.sh" ]] || \
    { [[ -f "$HOME/conf-files/shellscripts/tmux_git.sh" ]] && doit "chmod +x \"$HOME/conf-files/shellscripts/tmux_git.sh\""; }

  for s in sb_spaces_setup.sh sb_spaces_update.sh sb_cpu.sh sb_mem.sh sb_temp.sh; do
    [[ -x "$HOME/conf-files/shellscripts/$s" ]] || \
      { [[ -f "$HOME/conf-files/shellscripts/$s" ]] && doit "chmod +x \"$HOME/conf-files/shellscripts/$s\""; }
  done
}

# ---------- Serviços ----------
start_services() {
  say "A iniciar serviços (brew services)…"
  for svc in yabai skhd sketchybar; do
    if brew list --cask --versions "$svc" >/dev/null 2>&1 || brew list --formula --versions "$svc" >/dev/null 2>&1; then
      doit "brew services restart $svc || brew services start $svc || true"
    fi
  done
  warn "Permissões necessárias:
  • System Settings → Privacy & Security → Accessibility: ativar 'yabai' e 'skhd'
  • System Settings → Privacy & Security → Screen Recording: ativar 'yabai'
  • (Opcional) scripting-addition do yabai requer SIP parcialmente desligado — faz apenas se precisares de features avançadas."
}

# ---------- Default shell ----------
ensure_zsh_default() {
  if [[ "$SHELL" != */zsh ]]; then
    say "Definir Zsh como shell por omissão…"
    local zbin
    zbin="$(command -v zsh || echo /bin/zsh)"
    if ! grep -q "$zbin" /etc/shells; then
      doit "echo \"$zbin\" | sudo tee -a /etc/shells >/dev/null"
    fi
    doit "chsh -s \"$zbin\" \"$USER\""
  else
    say "Zsh já é a shell por omissão"
  fi
}

# ---------- Execução ----------
main() {
  ensure_xcode_clt
  ensure_homebrew

  (( APPS ))    && install_apps
  (( DEV ))     && install_dev_tools
  (( DOTFILES ))&& apply_dotfiles

  ensure_zsh_default
  start_services

  say "Tudo pronto. Passos finais recomendados:"
  echo "  • Abre WezTerm → já entra em tmux (main)"
  echo "  • Neovim: :Lazy sync, :Mason, :TSUpdate"
  echo "  • Ollama: verifica com 'ollama run olmo2'"
  echo "  • Dá permissões ao yabai/skhd/sketchybar em Privacy & Security"
  echo "  • (Opcional) Instala Nerd Font (JetBrainsMono NF) se não estiver"
}

main "$@"
