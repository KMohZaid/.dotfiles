#!/usr/bin/env bash

# cc : https://github.com/sxyazi/yazi/discussions/829#discussioncomment-8844760
# modified to open selected folder in yazi
function yazi_zed() {
  local tmp="$(mktemp -t "yazi-chooser.XXXXX")"

  yazi "$@" --chooser-file="$tmp"

  local opened_file="$(cat -- "$tmp" | head -n 1)"

  rm -f -- "$tmp"

  # exit if nothing selected
  [[ -z "$opened_file" ]] && return 0

  # if directory → recurse into it
  if [[ -d "$opened_file" ]]; then
    yazi_zed "$opened_file"
    return
  fi

  # if file → open editor
  zeditor -- "$opened_file"
  exit
}

yazi_zed
