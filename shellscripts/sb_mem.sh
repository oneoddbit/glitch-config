#!/usr/bin/env bash
# RAM usada % com vm_stat (páginas x pagesize)
pagesize=$(sysctl -n hw.pagesize)
eval $(vm_stat | awk 'BEGIN{FS=":"} NR>1 {gsub(/^[ \t]+|[.]/,"",$2); gsub(" ","_",$1); print $1"="$2}')
# Campos típicos: Pages_free, Pages_active, Pages_inactive, Pages_speculative, Pages_wired_down, Pages_compressed
total=$((Pages_free+Pages_active+Pages_inactive+Pages_speculative+Pages_wired_down+Pages_compressed))
used=$((Pages_active+Pages_inactive+Pages_speculative+Pages_wired_down+Pages_compressed))
pct=$(awk -v u="$used" -v t="$total" 'BEGIN{print (u/t)*100}')
printf "  %0.0f%%\n" "$pct"
