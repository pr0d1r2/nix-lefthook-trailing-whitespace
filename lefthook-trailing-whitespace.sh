# shellcheck shell=bash
# Lefthook-compatible trailing whitespace checker.
# Usage: lefthook-trailing-whitespace file1 [file2 ...]
# NOTE: sourced by writeShellApplication — no shebang or set needed.

if [ $# -eq 0 ]; then
    exit 0
fi

files=()
for f in "$@"; do
    [ -f "$f" ] || continue
    files+=("$f")
done

if [ ${#files[@]} -eq 0 ]; then
    exit 0
fi

found=0
for f in "${files[@]}"; do
    if grep -Pn '\s+$' "$f"; then
        echo "  ^-- trailing whitespace in $f"
        found=1
    fi
done

exit "$found"
