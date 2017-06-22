#!/bin/bash

# Constants
declare -ri TRUE=1
declare -ri FALSE=0
# Assume 4KiB pages.
declare -r  PAGE_SIZE=4096
declare -r  DATE_FMT="%a, %-d %b %Y %R:%S GMT"

# Argument check
if [[ 2 -gt $# ]]; then
  echo "Requires at least two arguments!" >&2
  exit 1
fi

# Readable arguments
declare -r src_url="$1"
declare -r dest_file="$2"

# Dest file already exists
if [[ -a "$dest_file" ]]; then
  declare -ri dest_file_exists=$TRUE
fi

# Optional modified hook
if [[ 2 -lt $# ]]; then
  declare -ri have_modified_hook=$TRUE
  declare -ra modified_hook=("${@:3}")
else
  declare -ri have_modified_hook=$FALSE
fi

# File check
if [[ $TRUE -eq $dest_file_exists ]] &&
   [[ ! -f "$dest_file" || ! -r "$dest_file" || ! -w "$dest_file" ]]; then
  echo "Destination file does not exist, is not a normal file," \
       "is not readable, or is not writable!" >&2
  exit 1
fi

# Command check
if [[ $TRUE -eq $have_modified_hook ]] && ! command -v "${modified_hook[0]}"; then
  echo "Modified hook is not a command!" >&2
  exit 1
fi

# Temprorary file name to write to
declare -r tmp_file="$(mktemp -p "$(dirname "$dest_file")")"

if [[ $TRUE -eq $dest_file_exists ]]; then
  # Get last modified
  declare -ri mod_epoch=$(stat -c %Y "$dest_file")
  declare -r  mod_readable="$(TZ=GMT date +"$DATE_FMT" --date=@$mod_epoch)"

  # Fetch only if modified.
  curl -sfLH "If-Modified-Since: $mod_readable" "$src_url" > "$tmp_file"
else
  curl -sfL "$src_url" > "$tmp_file"
fi

# Check for error.
declare -ri curl_exit=$?
if [[ 0 -ne $curl_exit ]]; then
  echo "cURL failed with exit code: $curl_exit!" >&2
  exit $curl_exit
fi

# Check if non-empty
if [[ -s "$tmp_file" ]]; then
  mv "$tmp_file" "$dest_file" || exit $?

  if [[ $TRUE -eq $dest_file_exists ]]; then
    echo "$dest_file was modified."
  else
    echo "$dest_file was created."
  fi

  if [[ $TRUE -eq $have_modified_hook ]]; then
    "${modified_hook[@]}" || exit $?
  fi
else
  rm -f "$tmp_file" || exit $?
fi

exit 0

# vim: set ts=2 sw=2 et syn=sh:
