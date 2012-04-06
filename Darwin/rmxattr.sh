#!/usr/bin/env bash
SCRIPT_NAME="rmxattr.sh"
SCRIPT_VERSION="0.0.1 2012-03-31"

usage() {
cat <<EOF
$SCRIPT_NAME $SCRIPT_VERSION
Remove all extended attributes from a file

Usage: ${0##*/} [options] path ...

Options:
 -r, --recursive  Recursively search directories
 -h, --help       Show this help
EOF
}
FAIL() { [[ $1 ]] && echo "$SCRIPT_NAME: $1" >&2; exit ${2:-1}; }

while (($#)); do
	case $1 in
        -h|--help) usage; exit 0 ;;
		-r|--recursive) opt_recursive=1 ;;
		-*|--*) FAIL "unknown option $1" ;;
        *) break ;;
	esac
	shift
done

remove_xattr() {
	xattr "$1" | {
		while read a; do
			echo "$1: $a"
			xattr -d "$a" "$1"
		done
	}
	return
}

[[ ! $1 ]] && { usage; exit 0; }

for f in "${@:-$PWD}"; do
	if [[ $opt_recursive ]]; then
		find "$f" -print | { while read x; do remove_xattr "$x"; done; }
	else
		remove_xattr "$f"
	fi
done