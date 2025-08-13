#!/usr/bin/env bash
# Cria itens por space com cores independentes e clique
ACTIVE=0xFF00FFD5   # ciano (ativo)
INACTIVE=0xFF8B5CF6 # roxo  (inativo)

# Remover espaços existentes
for id in $(sketchybar --query bar | jq -r '.items[] | select(.name | startswith("space.")) | .name'); do
  sketchybar --remove "$id"
done

# Criar por spaces atuais
INDEXES=$(yabai -m query --spaces | jq -r '.[].index')
for i in $INDEXES; do
  sketchybar --add item "space.$i" left \
    --set "space.$i" \
      icon="○" \
      icon.color=$INACTIVE \
      label="$i" \
      label.color=$INACTIVE \
      padding_left=4 padding_right=4 \
      click_script="yabai -m space --focus $i" \
      script="~/conf-files/shellscripts/sb_spaces_update.sh $i"
done

# Atualização inicial + subscrições
~/conf-files/shellscripts/sb_spaces_update.sh all

# Subscrições para atualizar cores quando muda o space/app/janela
sketchybar --subscribe "space.1" space_change front_app_switched window_title_changed
# Nota: o subscribe em 1 propaga o evento aos scripts setados em cada item
