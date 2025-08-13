#!/usr/bin/env bash
# Título da janela ativa (app + nome)

app=$(yabai -m query --windows --window | jq -r '.app // empty')
title=$(yabai -m query --windows --window | jq -r '.title // empty')

# fallback simples
[ -z "$app" ] && app="—"
[ -z "$title" ] && title=""

echo "  $app  ·  $title"
