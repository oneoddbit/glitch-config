# ~/.zprofile — Saturn Pursuit (macOS-friendly, seguro)

### Locale ###
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

### Homebrew (Apple Silicon / Intel) ###
if [ -x /opt/homebrew/bin/brew ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [ -x /usr/local/bin/brew ]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

### PATHs úteis ###
export PATH="$HOME/.local/bin:$HOME/bin:$PATH"
# VS Code CLI
if [ -x "/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code" ]; then
  export PATH="/Applications/Visual Studio Code.app/Contents/Resources/app/bin:$PATH"
fi
# .NET tools
[ -d "$HOME/.dotnet/tools" ] && export PATH="$HOME/.dotnet/tools:$PATH"

### Python user base (para pip --user) ###
PY_USER_BASE="$(python3 -c 'import site; print(site.USER_BASE)' 2>/dev/null || true)"
[ -n "$PY_USER_BASE" ] && export PATH="$PY_USER_BASE/bin:$PATH"

### Default editors ###
export EDITOR="nvim"
export VISUAL="nvim"

### (Opcional) Auto-attach tmux em shells de login ###
# Guarda contra: já dentro do tmux, VS Code terminal, sessões não interativas, SSH remoto.
if [ -n "$PS1" ] && command -v tmux >/dev/null 2>&1; then
  case "$-" in
    *i*) : ;;                    # interactive
    *)   TMUX_SKIP=1 ;;
  esac
  if [ -z "${TMUX:-}" ] && [ -z "${VSCODE_PID:-}" ] && [ -z "${SSH_CONNECTION:-}" ] && [ -z "${TMUX_SKIP:-}" ]; then
    tmux attach -t main 2>/dev/null || tmux new -s main
  fi
fi
