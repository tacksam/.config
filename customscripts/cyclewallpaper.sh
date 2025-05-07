#!/usr/bin/env bash
set -euo pipefail

# Directory of your wallpapers
WALLDIR="$HOME/Pictures/Wallpapers"
# File to remember last index
IDXFILE="$HOME/.cache/wp_index"

# Gather images
mapfile -t files < <(find "$WALLDIR" -maxdepth 1 -type f \
  \( -iname '*.png' -o -iname '*.jpg' -o -iname '*.jpeg' \) \
  | sort)

(( ${#files[@]} )) || { echo "No wallpapers in $WALLDIR" >&2; exit 1; }

# Read last or start at -1
last=-1
[[ -r "$IDXFILE" ]] && last=$(<"$IDXFILE")

# Next index
next=$(( (last + 1) % ${#files[@]} ))
wp="${files[$next]}"

# Apply to each monitor
for mon in $(hyprctl monitors | awk '/Monitor/ {print $2}'); do
  hyprctl hyprpaper preload "$wp"
  hyprctl hyprpaper wallpaper "${mon},${wp}"
done
hyprctl hyprpaper unload all

# Save index
printf '%d' "$next" >| "$IDXFILE"
