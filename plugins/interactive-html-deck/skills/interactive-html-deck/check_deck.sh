#!/usr/bin/env bash
# Screenshot the last step of every slide of a deck, plus a DOM dump of each counter.
# usage: bash check_deck.sh <deck.html> <out dir>   (needs Chrome or Chromium)
# Read every PNG: look for the h2 over the .uc line, text past the narration strip, labels on top of
# each other, edges through boxes. Headless capture can show the step before the one asked for
# (virtual time); the DOM dump line "N/M · step k/K" is the truth for the counter.
set -eu
deck=$(cd "$(dirname "$1")" && pwd)/$(basename "$1"); out=$2; mkdir -p "$out"
chrome=${CHROME:-"/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"}  # set CHROME on Linux, e.g. CHROME=google-chrome
steps=$(grep -o 'data-steps="[0-9]*"' "$deck" | grep -o '[0-9]*')
i=0
for k in $steps; do
  i=$((i + 1))
  "$chrome" --headless=new --disable-gpu --hide-scrollbars --window-size=1320,780 --virtual-time-budget=6000 \
    --screenshot="$out/s$i.png" "file://$deck#s$i-$k" >/dev/null 2>&1
  where=$("$chrome" --headless=new --disable-gpu --virtual-time-budget=3000 --dump-dom "file://$deck#s$i-$k" 2>/dev/null \
    | grep -o '<span id="where">[^<]*' | sed 's/<span id="where">//')
  echo "s$i: $where -> $out/s$i.png"
done
