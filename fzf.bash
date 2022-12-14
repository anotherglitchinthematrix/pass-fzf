#!/usr/bin/env bash
#
# pass-fzf — browse your pass(1) store with fzf
# ----------------------------------------------------------------
# Version: 1.1.0 (2025-05-01)
#
# Requirements:
#   • pass (https://www.passwordstore.org)
#   • pass-otp (https://github.com/tadfisher/pass-otp)
#   • fzf  (https://github.com/junegunn/fzf)
#
# Tips:
#   * Type multiple space-separated fragments to narrow results
#     in left-to-right order, e.g. "scale an", upports fzf queries.
#   * Add -c / --clip to copy instead of showing on stdout.
#   * Use the "otp" sub-command for TOTP codes stored by pass-otp.

set -euo pipefail            # Exit on error, undefined var, or pipe fail
shopt -s lastpipe            # So the last command in a while-read sees vars

PROGRAM_NAME=${0##*/}        # Strip path, keep only file name
SCRIPT_VERSION="1.1.0"

# Where the password store lives (falls back to ~/.password-store)
PASSWORD_STORE_DIR=${PASSWORD_STORE_DIR:-"$HOME/.password-store"}

###############################################################################
# Helper functions
###############################################################################

# Print all .gpg files in the store, relative to store root, stripped of suffix
list_password_entries() {
  # Use NUL‐delimited output so "weird names" don't break the loop
  find -L "$PASSWORD_STORE_DIR" -type f -name '*.gpg' -print0 |
  while IFS= read -r -d '' full_path; do
    # Strip "/path/to/store/" prefix
    local relative_path=${full_path#"$PASSWORD_STORE_DIR"/}
    # Strip ".gpg" extension and print
    printf '%s\n' "${relative_path%.gpg}"
  done |
  sort
}

# Wrapper around fzf with options tuned for a password list
run_fzf() {
  local fzf_opts=(
    --reverse                 # show matches at the top
    --no-multi                # single-selection only
    --no-mouse
    --algo=v2                 # high-quality scoring
    --scheme=path             # score "folder/file" nicely
    --tiebreak=length,index   # shorter hits win ties
    --height=12
    --ansi
    --tabstop=2
    --no-unicode
    --no-separator
    --no-info
    --select-1
    --exit-0
  )

  fzf "${fzf_opts[@]}" "$@"
}

# Show usage instructions
show_help() {
  cat <<EOF
Usage:
  $PROGRAM_NAME [options] [query]
  $PROGRAM_NAME otp [options] [query]

Options:
  -c, --clip        Copy result to clipboard instead of printing
  -h, --help        Show this help and exit
  -v, --version     Show version and exit

Examples:
  $PROGRAM_NAME                # browse everything
  $PROGRAM_NAME github prod    # narrow to "github" then "prod"
  $PROGRAM_NAME -c scale an    # copy password of entry matching both words
  $PROGRAM_NAME otp -c work    # copy OTP code for matching entry
EOF
}

# Print version
show_version() {
  echo "$SCRIPT_VERSION"
}

###############################################################################
# Core logic
###############################################################################

# Pick an entry with (optional) initial query
pick_entry() {
  local initial_query=$1
  if [[ -n $initial_query ]]; then
    list_password_entries | run_fzf --query="$initial_query"
  else
    list_password_entries | run_fzf
  fi
}

# Execute pass in the requested mode (show / otp) and copy or print
handle_pass_action() {
  local pass_subcommand=$1   # "show" or "otp"
  local copy_to_clipboard=$2 # "yes" or "no"
  shift 2                    # Remove the two arguments above
  local query="$*"           # Remaining words form the query

  local selected_entry
  if ! selected_entry=$(pick_entry "$query"); then
    # User cancelled or no match
    exit 1
  fi

  if [[ $copy_to_clipboard == "yes" ]]; then
    pass "$pass_subcommand" --clip "$selected_entry"
  else
    pass "$pass_subcommand"        "$selected_entry"
  fi
}

# Default settings
copy_flag="no"
pass_mode="show"

# No positional args yet; collect query words later
query_words=()

while [[ $# -gt 0 ]]; do
  case $1 in
    # Global flags
    -h|--help)
      show_help
      exit 0
      ;;
    -v|--version)
      show_version
      exit 0
      ;;
    -c|--clip)
      copy_flag="yes"
      shift
      ;;
    # Sub-command "otp"
    otp)
      pass_mode="otp"
      shift
      ;;
    # Everything else is part of the search query
    *)
      query_words+=("$1")
      shift
      ;;
  esac
done

# Run the requested action
handle_pass_action "$pass_mode" "$copy_flag" "${query_words[*]}"

exit 0
