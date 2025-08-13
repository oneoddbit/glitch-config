#!/usr/bin/env bash
set -Eeuo pipefail

echo "🧩 Step 3: Editors & Native Mobile Dev (Neovim, VS Code, Android Studio, Xcode CLT)"

say() { printf "\033[1;36m==>\033[0m %s\n" "$*"; }
warn(){ printf "\033[1;33m⚠\033[0m %s\n" "$*"; }
ok()  { printf "\033[1;32m✔\033[0m %s\n" "$*"; }
is_installed() { command -v "$1" >/dev/null 2>&1; }
has_formula()  { brew list --formula --versions "$1" >/dev/null 2>&1; }
has_cask()     { brew list --cask --versions "$1"    >/dev/null 2>&1; }

install_formula() {
  local f="$1"
  if has_formula "$f"; then ok "formula: $f (já instalada)"; else
    say "brew install $f"
    brew install "$f"
  fi
}
install_cask() {
  local c="$1"
  if has_cask "$c"; then ok "cask: $c (já instalado)"; else
    say "brew install --cask $c"
    brew install --cask "$c"
  fi
}

# 0) Homebrew
if ! is_installed brew; then
  say "Homebrew não encontrado — a instalar…"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  # shellenv
  [[ -x /opt/homebrew/bin/brew ]] && eval "$(/opt/homebrew/bin/brew shellenv)"
  [[ -x /usr/local/bin/brew   ]] && eval "$(/usr/local/bin/brew shellenv)"
else
  say "Homebrew OK — brew update…"
  brew update
fi

# 1) Neovim
install_formula neovim
# (Opcional) aplica a tua config do pack se existir
if [[ -d "$HOME/conf-files/dotfiles/nvim" ]]; then
  mkdir -p "$HOME/.config/nvim"
  rsync -avh --delete "$HOME/conf-files/dotfiles/nvim/" "$HOME/.config/nvim/"
  ok "Neovim config sincronizada de conf-files/dotfiles/nvim"
  # dicas pós:
  echo "   → abre o Neovim e corre :Lazy sync, :Mason, :TSUpdate"
fi

# 2) VS Code
install_cask visual-studio-code

# VS Code: instalar extensões a partir do pack (se existir)
VS_EXT_TXT="$HOME/conf-files/dotfiles/vscode/extensions.txt"
if is_installed code && [[ -f "$VS_EXT_TXT" ]]; then
  say "Instalar extensões VS Code de $VS_EXT_TXT…"
  while IFS= read -r ext; do
    [[ -z "$ext" ]] && continue
    code --install-extension "$ext" || true
  done < "$VS_EXT_TXT"
  ok "Extensões VS Code aplicadas"
else
  warn "VS Code extensions.txt não encontrado ou 'code' não no PATH."
  echo "   Abra o VS Code → Command Palette → “Shell Command: Install 'code' command in PATH”."
fi

# VS Code: copiar settings/keybindings se existirem
VS_CONF_DIR="$HOME/conf-files/dotfiles/vscode"
if [[ -d "$VS_CONF_DIR" ]]; then
  # caminhos do VS Code (User)
  if [[ "$OSTYPE" == "darwin"* ]]; then
    USER_DIR="$HOME/Library/Application Support/Code/User"
  else
    USER_DIR="$HOME/.config/Code/User"
  fi
  mkdir -p "$USER_DIR"
  [[ -f "$VS_CONF_DIR/settings.json"    ]] && cp -a "$VS_CONF_DIR/settings.json"    "$USER_DIR/settings.json"
  [[ -f "$VS_CONF_DIR/keybindings.json" ]] && cp -a "$VS_CONF_DIR/keybindings.json" "$USER_DIR/keybindings.json"
  ok "VS Code settings/keybindings aplicados"
fi

# 3) Android Studio + Platform Tools
install_cask android-studio
install_cask android-platform-tools  # adb/fastboot

# (Opcional) preparar ANDROID_HOME se SDK já existir
SDK_DIR="$HOME/Library/Android/sdk"
if [[ -d "$SDK_DIR" ]]; then
  PROFILE="$HOME/.zprofile"
  if ! grep -q "ANDROID_HOME" "$PROFILE" 2>/dev/null; then
    say "A definir ANDROID_HOME em $PROFILE"
    {
      echo ""
      echo "# Android SDK"
      echo "export ANDROID_HOME=\"$SDK_DIR\""
      echo "export PATH=\"\$ANDROID_HOME/platform-tools:\$ANDROID_HOME/emulator:\$PATH\""
    } >> "$PROFILE"
    ok "ANDROID_HOME definido em .zprofile (reabre o terminal para carregar)"
  else
    ok "ANDROID_HOME já definido em .zprofile"
  fi
else
  warn "SDK Android ainda não existe. Abre o Android Studio e instala via SDK Manager."
fi

# 4) Xcode (CLT) + nota sobre App Store
if ! xcode-select -p >/dev/null 2>&1; then
  say "A instalar Xcode Command Line Tools…"
  xcode-select --install || true
  warn "Aceita o diálogo do macOS e volta a correr este passo no fim, se necessário."
else
  ok "Xcode CLT OK"
fi
echo "ℹ️  Para o Xcode completo (iOS dev): abre a App Store e instala “Xcode” (grande download)."

echo "✅ Step 3 concluído."
