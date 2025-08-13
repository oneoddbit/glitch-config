#!/usr/bin/env bash
set -Eeuo pipefail

echo "🧩 Step 2: Apply dotfiles & bootstrap WM/Terminal/Editor"

# ========== helpers ==========
cyan(){ printf "\033[1;36m==>\033[0m %s\n" "$*"; }
warn(){ printf "\033[1;33m⚠\033[0m %s\n" "$*"; }
ok(){   printf "\033[1;32m✔\033[0m %s\n" "$*"; }

backup_copy() {
  # backup_copy <src> <dest>
  local SRC="$1" DEST="$2"
  local TS; TS="$(date +%Y%m%d%H%M%S)"
  if [[ -f "$DEST" || -d "$DEST" ]]; then
    cp -a "$DEST" "${DEST}.${TS}.bak"
    warn "backup → ${DEST}.${TS}.bak"
  fi
  # cria pasta de destino se necessário
  mkdir -p "$(dirname "$DEST")"
  cp -a "$SRC" "$DEST"
  ok "copied: $SRC → $DEST"
}

ensure_exec() {
  for f in "$@"; do
    [[ -f "$f" ]] && chmod +x "$f" && ok "exec: $f"
  done
}

has_brew(){ command -v brew >/dev/null 2>&1; }

# ========== paths ==========
ROOT="$HOME/conf-files/dotfiles"
SHROOT="$HOME/conf-files/shellscripts"

# ========== sanity ==========
if [[ ! -d "$ROOT" ]]; then
  echo "✘ dotfiles not found in $ROOT"
  echo "  clone/move your pack to ~/conf-files/dotfiles and rerun."
  exit 1
fi

# ========== Zsh & Starship ==========
cyan "Zsh + Starship"
backup_copy "$ROOT/zsh/.zshrc"      "$HOME/.zshrc"
backup_copy "$ROOT/zsh/.zprofile"   "$HOME/.zprofile"
backup_copy "$ROOT/zsh/starship.toml" "$HOME/.config/starship.toml"

# ========== WezTerm ==========
cyan "WezTerm"
backup_copy "$ROOT/wezterm/.wezterm.lua" "$HOME/.wezterm.lua"

# ========== tmux ==========
cyan "tmux"
backup_copy "$ROOT/tmux/.tmux.conf" "$HOME/.tmux.conf"

# ========== Git ==========
cyan "Git"
backup_copy "$ROOT/git/.gitconfig" "$HOME/.gitconfig"
[[ -f "$ROOT/git/.gitignore_global" ]] && backup_copy "$ROOT/git/.gitignore_global" "$HOME/.gitignore_global"

# ========== Neovim (modular) ==========
cyan "Neovim"
mkdir -p "$HOME/.config/nvim"
backup_copy "$ROOT/nvim/init.lua"            "$HOME/.config/nvim/init.lua"
cp -a "$ROOT/nvim/lua"                       "$HOME/.config/nvim/" && ok "synced nvim/lua/"

# ========== Yabai / SKHD / SketchyBar ==========
cyan "Yabai / SKHD / SketchyBar"
mkdir -p "$HOME/.config/yabai" "$HOME/.config/skhd" "$HOME/.config/sketchybar"
backup_copy "$ROOT/yabai/yabairc"            "$HOME/.config/yabai/yabairc"
backup_copy "$ROOT/skhd/skhdrc"              "$HOME/.config/skhd/skhdrc"
backup_copy "$ROOT/sketchybar/sketchybarrc"  "$HOME/.config/sketchybar/sketchybarrc"

# ========== shell helpers (tmux & sketchybar scripts) ==========
cyan "Helper scripts"
mkdir -p "$SHROOT"
for s in \
  "tmux_git.sh" \
  "sb_spaces_setup.sh" "sb_spaces_update.sh" \
  "sb_cpu.sh" "sb_mem.sh" "sb_temp.sh"
do
  [[ -f "$SHROOT/$s" ]] || warn "missing: $SHROOT/$s (skip)"
done
ensure_exec \
  "$SHROOT/tmux_git.sh" \
  "$SHROOT/sb_spaces_setup.sh" "$SHROOT/sb_spaces_update.sh" \
  "$SHROOT/sb_cpu.sh" "$SHROOT/sb_mem.sh" "$SHROOT/sb_temp.sh"

# ========== brew services (yabai/skhd/sketchybar) ==========
cyan "Restarting services (brew services)…"
if has_brew; then
  brew services restart yabai      || brew services start yabai      || true
  brew services restart skhd       || brew services start skhd       || true
  brew services restart sketchybar || brew services start sketchybar || true
else
  warn "Homebrew not detected; skip services."
fi

# ========== notes ==========
cat <<'EOF'

ℹ️  Next steps / notes:
  • macOS → System Settings → Privacy & Security:
      - Accessibility: enable "yabai" and "skhd"
      - Screen Recording: enable "yabai"
  • WezTerm já arranca em tmux (session 'main')
  • Neovim: abra e execute :Lazy sync, :Mason, :TSUpdate
  • tmux: reload com prefix r (ou: tmux source-file ~/.tmux.conf)

✅ Step 2 concluído.
EOF
# ========== end ==========