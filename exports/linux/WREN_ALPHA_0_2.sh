#!/bin/sh
echo -ne '\033c\033]0;WREN\a'
base_path="$(dirname "$(realpath "$0")")"
"$base_path/WREN_ALPHA_0_2.x86_64" "$@"
