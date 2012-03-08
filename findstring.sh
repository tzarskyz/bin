#!/usr/bin/env bash
SCRIPT_NAME="findstring.sh"
SCRIPT_VERSION="1.1.3 (2012-02-29)"

usage() {
cat <<EOF
$SCRIPT_NAME $SCRIPT_VERSION
Recursively find strings in files.

Usage: ${0##*/} [options] text ...

Options:
 -b, --binary       Include binary files in the search
 -d, --depth NUM    Maximum depth to search subdirectories
 -f, --filenames    just print out a list of the files that match, no context
 -i, --ignore-case  Case-insensitive search
 -p, --path PATH    Search for files in this path (current working directory)
 -h, --help         Show this help
EOF
}
FAIL() { [[ $1 ]] && echo "$SCRIPT_NAME: $1" >&2; exit ${2:-1}; }

opt_binary=
opt_depth=
opt_filenames=
opt_ignore_case=
opt_path="$PWD"

runFind() {
	local grepopts="--no-messages --with-filename --line-number --color=auto"
	local findopts=""

	[[ $opt_binary ]] && grepopts="${grepopts} --binary-files=text" || grepopts="${grepopts} --binary-files=without-match"
	[[ $opt_filenames ]] && grepopts="${grepopts} -l"
	[[ $opt_ignore_case ]] && grepopts="${grepopts} -i"
	[[ $opt_depth ]] && findopts="${findopts} -maxdepth ${opt_depth}"

	find "$opt_path" -print0 -type f \
		-not -path '*/.Trash/*' \
		-not -path '*/.Trashes/*' \
		-not -path '*lost+found/' \
		$findopts \
		| xargs -0 -n 100 grep $grepopts "$@"
}

while (($#)); do
	case $1 in
		-h|--help) usage; exit 0 ;;
		-b|--binary) opt_binary=1 ;;
		-d|--depth) opt_depth="$2"; shift ;;
		-f|--filenames) opt_filenames=1 ;;
		-i|--ignore-case) opt_ignore_case=1 ;;
		-p|--path) opt_path="$2"; shift ;;
		-*|--*) FAIL "unknown option ${1}" ;;
		*) break ;;
	esac
	shift
done

[[ ! -d "$opt_path" ]] && FAIL "invalid path"

[[ ! $1 ]] && { usage; exit 0; }

runFind "$@"
