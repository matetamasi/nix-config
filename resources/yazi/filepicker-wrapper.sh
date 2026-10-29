#!/usr/bin/env bash
set -euo pipefail

# Ensure standard user profile and system binaries are in PATH
export PATH="$PATH:/etc/profiles/per-user/$USER/bin:/run/current-system/sw/bin"

multiple="$1"
directory="$2"
save="$3"
path="${4:-}"
out="$5"

if [ -z "$path" ]; then
  path="$HOME"
fi

> "$out"

if [ "$save" = "1" ]; then
  if [ -d "$path" ]; then
    base_dir="$path"
    suggested_name="untitled"
  else
    base_dir="$(dirname "$path")"
    suggested_name="$(basename "$path")"
  fi

  if [ ! -d "$base_dir" ]; then
    base_dir="$HOME"
  fi

  choice_file="$(mktemp)"
  cwd_file="$(mktemp)"

  ghostty \
    --class=com.mitchellh.ghostty.filechooser \
    --title="Save File ($suggested_name) - [Enter] overwrite, [q] save here, [Q] cancel" \
    -e yazi \
    --chooser-file="$choice_file" \
    --cwd-file="$cwd_file" \
    "$base_dir" || true

  if [ -s "$choice_file" ]; then
    chosen_path="$(cat "$choice_file")"
    if [ -d "$chosen_path" ]; then
      echo "$chosen_path/$suggested_name" > "$out"
    else
      echo "$chosen_path" > "$out"
    fi
  elif [ -s "$cwd_file" ]; then
    chosen_dir="$(cat "$cwd_file")"
    echo "$chosen_dir/$suggested_name" > "$out"
  fi

  rm -f "$choice_file" "$cwd_file"

elif [ "$directory" = "1" ]; then
  if [ ! -d "$path" ]; then
    path="$(dirname "$path")"
  fi
  if [ ! -d "$path" ]; then
    path="$HOME"
  fi

  choice_file="$(mktemp)"
  cwd_file="$(mktemp)"

  ghostty \
    --class=com.mitchellh.ghostty.filechooser \
    --title="Select Directory - [q] choose current directory, [Q] cancel" \
    -e yazi \
    --chooser-file="$choice_file" \
    --cwd-file="$cwd_file" \
    "$path" || true

  if [ -s "$choice_file" ]; then
    cat "$choice_file" > "$out"
  elif [ -s "$cwd_file" ]; then
    cat "$cwd_file" > "$out"
  fi

  rm -f "$choice_file" "$cwd_file"

else
  if [ -f "$path" ] || [ -d "$path" ]; then
    open_target="$path"
  else
    parent_dir="$(dirname "$path")"
    if [ -d "$parent_dir" ]; then
      open_target="$parent_dir"
    else
      open_target="$HOME"
    fi
  fi

  ghostty \
    --class=com.mitchellh.ghostty.filechooser \
    --title="Choose File(s) - [Enter] select, [q] cancel" \
    -e yazi \
    --chooser-file="$out" \
    "$open_target" || true
fi
