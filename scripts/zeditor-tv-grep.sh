#!/usr/bin/env bash

#!/usr/bin/env bash

zeditor_wrapper() {
  line_arg="$1"
  file="$2"

  if [[ "$line_arg" == +* && -n "$file" ]]; then
    line="${line_arg#+}"
    exec zeditor "$file:$line"
  else
    exec zeditor "$@"
  fi
}

export -f zeditor_wrapper
EDITOR=zeditor_wrapper tv text
