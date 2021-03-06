# unicode2hex CHARACTER
# Convert a character to its unicode hexadecimal value.
#
# Basic Example:
# $ unicode2hex ã
# \xC3\xA3
#
# Used in conjunction with printf:
# $ lightning=$(unicode2hex ⚡)
# $ printf "$lightning $lightning $lightning\n"
# ⚡ ⚡ ⚡
unicode2hex() {
	echo -n "$1" |
		hexdump |
		head -n1 |
		tr a-z A-z |
		awk '{for (i=2; i<=NF; i++) printf "\\x%s", $i}'
}

# TESTS
# for v in A @ % ∂ à Ũ ŵ ￫ ☠; do echo $v $(unicode2hex "$v"); done
