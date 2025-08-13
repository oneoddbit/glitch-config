#!/usr/bin/env bash
# tmux_git.sh — imprime segmentos git coloridos para o status-right
# uso: tmux_git.sh [dir]; se não passar, usa cwd
DIR="${1:-$PWD}"
cd "$DIR" 2>/dev/null || exit 0

# Só se for repo git
git rev-parse --is-inside-work-tree &>/dev/null || exit 0

# Paleta Saturn (hex)
BG0="#000014"
OK="#22C55E"       # clean
WARN="#FFDD00"     # changed
ERR="#FF6E6E"      # conflicts
AHEAD="#5EEAD4"    # ahead
BEHIND="#F59E0B"   # behind
SEG3="#00FFD5"     # separador

# Estado detalhado
# Porcelain v2 para contar alterações + branch -b para ahead/behind
mapfile -t LINES < <(git status --porcelain=2 -b 2>/dev/null)

staged=0; modified=0; untracked=0; conflicted=0; renamed=0; deleted=0
ahead=0; behind=0

for l in "${LINES[@]}"; do
  # ahead/behind
  if [[ $l =~ ^#\ branch\.ab\ +ahead\ ([0-9]+)\ +behind\ ([0-9]+) ]]; then
    ahead=${BASH_REMATCH[1]}; behind=${BASH_REMATCH[2]}
  elif [[ $l =~ ^#\ branch\.ab\ +ahead\ ([0-9]+) ]]; then
    ahead=${BASH_REMATCH[1]}
  elif [[ $l =~ ^#\ branch\.ab\ +behind\ ([0-9]+) ]]; then
    behind=${BASH_REMATCH[1]}
  fi
  # mudanças
  c="${l:0:1}"
  case "$c" in
    1|2)
      x="${l:2:1}"; y="${l:3:1}"
      [[ $x != "." ]] && ((staged++))
      [[ $y != "." ]] && ((modified++))
      [[ $c == "2" ]] && ((renamed++))
      ;;
    ?)
      ((untracked++))
      ;;
    u)
      ((conflicted++))
      ;;
  esac
done

# Construção dos segmentos (tmux format)
seg() { # bg fg text
  local BG="$1" FG="$2" TXT="$3"
  printf "#[bg=%s,fg=%s] %s #[default]" "$BG" "$FG" "$TXT"
}

out=""

# bloco estado (clean / changed / conflicts)
if (( conflicted > 0 )); then
  out+=$(seg "$ERR" "$BG0" "⚠ $conflicted")
elif (( staged>0 || modified>0 || untracked>0 || renamed>0 || deleted>0 )); then
  s=""
  (( staged>0    ))   && s+=" +$staged"
  (( modified>0  ))   && s+=" ✎$modified"
  (( untracked>0 ))   && s+=" …$untracked"
  (( renamed>0  ))    && s+=" »$renamed"
  (( deleted>0  ))    && s+=" ✘$deleted"
  out+=$(seg "$WARN" "#000000" "${s# }")
else
  out+=$(seg "$OK" "$BG0" "✓ clean")
fi

# blocos ahead/behind (cores próprias)
if (( ahead>0 ));  then out+="$(seg "$AHEAD" "$BG0" "⇡$ahead")"; fi
if (( behind>0 )); then out+="$(seg "$BEHIND" "$BG0" "⇣$behind")"; fi

printf "%s" "$out"
