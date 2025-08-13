#!/usr/bin/env bash
# Temperatura: tenta iStats (gem), senão mostra "—"
if command -v istats >/dev/null 2>&1; then
  # exemplo output: "CPU temp: 54.81°C"
  t=$(istats cpu --value-only 2>/dev/null | head -n1)
  [ -n "$t" ] && printf "  %s°C\n" "$t" || echo "  —"
else
  echo "  —"
fi
