#!/usr/bin/env bash

# Check release
if [ ! -f /etc/arch-release ]; then
  exit 0
fi

pkg_installed() {
  local pkg=$1
  if pacman -Qi "${pkg}" &>/dev/null; then
    return 0
  else
    return 1
  fi
}

get_aur_helper
export -f pkg_installed

# Trigger system upgrade
if [ "$1" == "up" ]; then
  trap 'pkill -RTMIN+20 waybar' EXIT
  command="
    $0 upgrade
    sudo pacman -Syu
    printf '\n'
    read -n 1 -p 'Press any key to continue...'
    "
  kitty --title "󰞒  System Update" sh -c "${command}"
fi

# Calculate total available updates
official_updates=$(
  (while pgrep -x checkupdates >/dev/null; do sleep 1; done)
  checkupdates | wc -l
)

[ "${1}" == upgrade ] && printf "Official:   %-10s\n\n" "$official_updates" && exit

tooltip="Official:   $official_updates"

# Module and tooltip
if [ $official_updates -eq 0 ]; then
  echo "{\"text\":\"󰸟\", \"tooltip\":\"Packages are up to date\"}"
else
  echo "{\"text\":\"󰞒\", \"tooltip\":\"${tooltip}\"}"
fi

