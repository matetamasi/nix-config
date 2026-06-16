#!/usr/bin/env bash
set -euo pipefail

mkdir -p "$HOME/Pictures/Screenshots"
filepath="$HOME/Pictures/Screenshots/$(date +%Y%m%d%H%M%S).png"
satty_args=("--filename" "$filepath" "--output-filename" "$filepath" "--actions-on-enter" "save-to-file" "--corner-roundness" "0" "--copy-command" "wl-copy"  "--fullscreen" "--floating-hack" "--early-exit")

wp=""
p=""

cleanup() {
    if [ -n "$wp" ]; then
        kill "$wp" 2>/dev/null || true
        wp=""
    fi
    if [ -n "$p" ]; then
        rm -f "$p" 2>/dev/null || true
        p=""
    fi
}
trap cleanup EXIT INT TERM

case "${1:-fullscreen}" in
  region)
    g=$(slurp -d || true)
    [ -z "$g" ] && exit 1
    grim -g "$g" "$filepath"
    ;;
  window)
    g=$(mmsg get focusing-client | jq -r '"\(.x),\(.y) \(.width)x\(.height)"' || true)
    [ -z "$g" ] && exit 1
    grim -g "$g" "$filepath"
    ;;
  freeze)
    p=$(mktemp -u).fifo; mkfifo "$p"
    wayfreeze --after-freeze-timeout 100 --after-freeze-cmd "echo > $p" & wp=$!
    read -r < "$p"
    grim "$filepath"
    ;;
  freeze-region)
    p=$(mktemp -u).fifo; mkfifo "$p"
    wayfreeze --after-freeze-timeout 100 --after-freeze-cmd "echo > $p" & wp=$!
    read -r < "$p"
    g=$(slurp -d || true)
    [ -z "$g" ] && exit 1
    grim -g "$g" "$filepath"
    ;;
  *) 
    grim "$filepath"
    ;;
esac

cleanup

satty "${satty_args[@]}"
