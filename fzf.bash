#!/usr/bin/env bash

VERSION="1.0.0"

set -e

_PASSWORD_STORE_DIR="${PASSWORD_STORE_DIR:-$HOME/.password-store}";

cmd_fzf_get_files() {
	find "$_PASSWORD_STORE_DIR" -name "*.gpg" -type f | sed -e "s:^$_PASSWORD_STORE_DIR\/::gi" -e 's:\.gpg$::gi' | sort
}

FZF() {
	fzf --reverse --no-multi --no-mouse --no-sort --algo=v1 --scheme=path --height=12 --no-unicode --no-separator --no-info --ansi --tabstop=2 --select-1 --exit-0 "$@"
}

cmd_fzf() {
	if [[ -n "$*" ]]; then
		cmd_fzf_get_files | FZF --query "$*"
	else
		cmd_fzf_get_files | FZF
	fi
}

cmd_fzf_version() {
	echo "$VERSION"
	exit 0
}

cmd_fzf_help() {
	echo "$PROGRAM fzf"
	echo "$PROGRAM fzf [-v|--version] [-h|--help]"
	echo "$PROGRAM fzf [-c|--clip] [query]"
	echo "$PROGRAM fzf otp [-c|--clip] [query]"
	exit 0
}

cmd_fzf_clip() {
	result="$(cmd_fzf "$@")"

	if [[ -n $result ]]; then
		pass show --clip "$result"
	else
		exit 1
	fi
}

cmd_fzf_otp_clip() {
	result="$(cmd_fzf "$@")"

	if [[ -n $result ]]; then
		pass otp --clip "$result"
	else
		exit 1
	fi
}

cmd_fzf_otp_show() {
	result="$(cmd_fzf "$@")"

	if [[ -n $result ]]; then
		pass otp "$result"
	else
		exit 1
	fi
}

cmd_fzf_otp_code() {
	case "$1" in
	-c | --clip)
		shift
		cmd_fzf_otp_clip "$@"
		;;
	*) cmd_fzf_otp_show "$@" ;;
	esac
}

cmd_fzf_show() {
	result="$(cmd_fzf "$@")"

	if [[ -n $result ]]; then
		pass show "$result"
	else
		exit 1
	fi
}

cmd_fzf_code() {
	case "$1" in
	-c | --clip)
		shift
		cmd_fzf_clip "$@"
		;;
	otp)
		shift
		cmd_fzf_otp_code "$@"
		;;
	*) cmd_fzf_show "$@" ;;
	esac
}

case "$1" in
version | --version | -v)
	shift
	cmd_fzf_version "$@"
	;;
help | --help | -h)
	shift
	cmd_fzf_help "$@"
	;;
*) cmd_fzf_code "$@" ;;
esac

exit 0
