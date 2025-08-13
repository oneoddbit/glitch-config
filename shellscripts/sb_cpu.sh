#!/usr/bin/env bash
# CPU busy = 100 - idle (top -l 1 no macOS)
out=$(top -l 1 | awk -F'[:,% ]+' '/CPU usage/ {idle=$NF; print 100-idle}')
printf "  %0.0f%%\n" "$out"
