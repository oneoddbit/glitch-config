# ~/.zshrc — Saturn Pursuit (clean, no OMZ)

# --- Locale & editors ---
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"
export EDITOR="nvim"
export VISUAL="nvim"

# --- Homebrew (Apple Silicon/Intel) ---
[[ -x /opt/homebrew/bin/brew ]] && eval "$(/opt/homebrew/bin/brew shellenv)"
[[ -x /usr/local/bin/brew   ]] && eval "$(/usr/local/bin/brew shellenv)"

# --- PATHs úteis ---
export PATH="$HOME/.local/bin:$HOME/bin:$PATH"
[ -d "$HOME/.dotnet/tools" ] && export PATH="$HOME/.dotnet/tools:$PATH"
[ -x "/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code" ] && \
  export PATH="/Applications/Visual Studio Code.app/Contents/Resources/app/bin:$PATH"

# --- History & completion ---
setopt HIST_IGNORE_ALL_DUPS HIST_REDUCE_BLANKS SHARE_HISTORY INC_APPEND_HISTORY
export HISTSIZE=200000 SAVEHIST=200000 HISTFILE="$HOME/.zsh_history"
setopt AUTO_CD CORRECT EXTENDED_GLOB
autoload -Uz compinit && compinit -u

# --- zinit (plugin manager leve) ---
if [[ ! -f $HOME/.zinit/bin/zinit.zsh ]]; then
  mkdir -p "$HOME/.zinit/bin"
  curl -fsSL https://raw.githubusercontent.com/zdharma-continuum/zinit/refs/heads/main/doc/install.sh | bash
fi
source "$HOME/.zinit/bin/zinit.zsh"

# Plugins essenciais
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions

# --- fzf (bindings + default command com ripgrep) ---
if command -v brew >/dev/null 2>&1; then
  FZF_BASE="$(brew --prefix 2>/dev/null)/opt/fzf"
  [[ -r "$FZF_BASE/shell/completion.zsh"   ]] && source "$FZF_BASE/shell/completion.zsh"
  [[ -r "$FZF_BASE/shell/key-bindings.zsh" ]] && source "$FZF_BASE/shell/key-bindings.zsh"
fi
if command -v rg >/dev/null 2>&1; then
  export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --glob "!.git/*"'
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
fi

# --- zoxide (smart cd) ---
if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init zsh)"
  alias zi='cd "$(zoxide query -i)"'
fi

# --- Starship (prompt) ---
if command -v starship >/dev/null 2>&1; then
  eval "$(starship init zsh)"
fi

# --- Aliases úteis ---
alias v='nvim'
alias codeo='code .'
alias please='sudo'
alias ls='eza --icons --group-directories-first'
alias ll='eza -lah --icons --group-directories-first'
alias la='eza -a --icons --group-directories-first'
alias cat='bat --style=plain --paging=never'
alias gs='git status'; alias ga='git add'; alias gc='git commit'; alias gp='git push'
alias gl='git log --oneline --graph --decorate --all'
alias d='docker'; alias dps='docker ps'; alias dimg='docker images'
alias drm='docker rm'; alias drmi='docker rmi'; alias dco='docker compose'
alias wz='open -na "WezTerm" --args --cwd "$PWD" 2>/dev/null || wezterm start --cwd "$PWD"'

# --- Helpers Python venv ---
mkvenv() { python3 -m venv .venv && source .venv/bin/activate && pip -q install --upgrade pip; }
usevenv() { [ -d .venv ] && source .venv/bin/activate || echo "⚠️  .venv não existe aqui"; }

# --- tmux auto-attach (evita dentro do VS Code) ---
if [[ -o interactive ]] && command -v tmux >/dev/null 2>&1; then
  if [[ -z "$TMUX" ]] && [[ "$TERM_PROGRAM" != "vscode" ]]; then
    tmux attach -t main 2>/dev/null || tmux new -s main
  fi
fi

# --- (Limpeza) Garantir que nada do Oh My Zsh fica ativo ---
unset ZSH ZSH_THEME plugins
