#!/usr/bin/env bash
# Lista spaces e marca o ativo com cor ciana

SAT_ACTIVE=""   # ícone para ativo
ACTIVE_COLOR=0xFF00FFD5  # ciano
INACTIVE_COLOR=0xFF8B5CF6  # roxo

idxs=$(yabai -m query --spaces | jq -r '.[].index')
active=$(yabai -m query --spaces --space | jq -r '.index')

out=""
for i in $idxs; do
  if [ "$i" = "$active" ]; then
    out="$out %{F$ACTIVE_COLOR}[$i$SAT_ACTIVE]%{F-}  "
  else
    out="$out %{F$INACTIVE_COLOR}[$i]%{F-}  "
  fi
done

echo "$out"
