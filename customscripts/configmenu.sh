#!/usr/bin/env bash
# ~/.local/bin/config-editor-launcher.sh

# 1) Define “label|absolute_path” entries
mapfile -t options <<'EOF'
bashrc|/home/ivar/.bashrc
zshrc|/home/ivar/.zshrc
gitconfig|/home/ivar/.gitconfig
kitty|/home/ivar/.config/kitty/kitty.conf
alacritty|/home/ivar/.config/alacritty/alacritty.yml
fish|/home/ivar/.config/fish/config.fish
nvim|/home/ivar/.config/nvim/init.vim
tmux|/home/ivar/.tmux.conf
starship|/home/ivar/.config/starship.toml
hypr|/home/ivar/.config/hypr/hyprland.conf
hyprpaper|/home/ivar/.config/hypr/hyprpaper.conf
waybar|/home/ivar/.config/waybar
picom|/home/ivar/.config/picom
rofi|/home/ivar/.config/rofi/config.rasi
wofi|/home/ivar/.config/wofi
dunst|/home/ivar/.config/dunst/dunstrc
EOF

# 2) Present only the left of “|” to Wofi
labels=()
for e in "${options[@]}"; do
  labels+=("${e%%|*}")
done

choice=$(printf '%s\n' "${labels[@]}" \
  | wofi \
      --conf  /home/ivar/.config/wofi/config-editor \
      --style /home/ivar/.config/wofi/style-editor.css \
      --show  dmenu)

# 3) Bail if empty
[[ -z "$choice" ]] && exit 0

# 4) Find the matching path
target=''
for e in "${options[@]}"; do
  if [[ "${e%%|*}" == "$choice" ]]; then
    target="${e#*|}"
    break
  fi
done

if [[ -z "$target" ]]; then
  notify-send "Config Launcher" "❌ Unknown selection: $choice"
  exit 1
fi

# 5) Open it in VS Code (files or dirs both work)
exec code "$target"
