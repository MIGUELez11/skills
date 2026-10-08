#!/usr/bin/env bash
# Add one draft note to a GitLab MR, anchored to new-file lines <start>..<end>.
# Usage: draft-note.sh [--dry-run] <iid> <new_path> <start> [end] < note.md
# Run from a clone of the MR's project. The note body is read from stdin.
set -euo pipefail

dry=0
[ "${1:-}" = --dry-run ] && { dry=1; shift; }
iid=$1 path=$2 start=$3 end=${4:-$3}
note=$(cat)
[ -n "$note" ] || { echo "empty note on stdin" >&2; exit 1; }

mr=$(glab mr view "$iid" -F json)
pid=$(jq -r .project_id <<<"$mr")
base=$(jq -r .diff_refs.base_sha <<<"$mr")
start_sha=$(jq -r .diff_refs.start_sha <<<"$mr")
head=$(jq -r .diff_refs.head_sha <<<"$mr")
git cat-file -e "$head^{commit}" 2>/dev/null || git fetch -q origin "refs/merge-requests/$iid/head"
git cat-file -e "$base^{commit}" 2>/dev/null || git fetch -q origin "$(jq -r .target_branch <<<"$mr")"

# GitLab needs old_path for renamed files, or the note loses its position.
old_path=$(git diff -M --name-status "$base" "$head" |
  awk -F'\t' -v p="$path" '$NF == p { print ($1 ~ /^R/ ? $2 : $NF) }')
[ -n "$old_path" ] || { echo "$path is not in the MR diff" >&2; exit 1; }

# Prints "new <old_counter>" for an added line, "old <old_line>" for an unchanged one.
map_line() {
  git diff -U0 -M "$base" "$head" -- "$old_path" "$path" | awk -v n="$1" '
    /^@@/ {
      o = substr($2, 2); w = substr($3, 2)
      a = o; b = 1; if (index(o, ",")) { split(o, t, ","); a = t[1]; b = t[2] }
      c = w; d = 1; if (index(w, ",")) { split(w, t, ","); c = t[1]; d = t[2] }
      a += 0; b += 0; c += 0; d += 0
      first = (d == 0 ? c + 1 : c)
      if (n < first) exit
      if (n < c + d) { found = 1; print "new", (b == 0 ? a + 1 : a + b); exit }
      off += d - b
    }
    END { if (!found) print "old", n - off }'
}

file_hash=$(printf %s "$path" | shasum | cut -d' ' -f1)
point() { # <new_line> -> line_range point JSON
  read -r type old < <(map_line "$1")
  jq -n --arg code "${file_hash}_${old}_$1" --arg type "$type" --argjson old "$old" --argjson new "$1" \
    'if $type == "new" then {line_code: $code, type: "new", old_line: null, new_line: $new}
     else {line_code: $code, type: null, old_line: $old, new_line: $new} end'
}

end_point=$(point "$end")
body=$(jq -n --arg note "$note" --arg base "$base" --arg start "$start_sha" --arg head "$head" \
  --arg op "$old_path" --arg np "$path" --argjson s "$(point "$start")" --argjson e "$end_point" \
  '{note: $note, position: ({position_type: "text", base_sha: $base, start_sha: $start, head_sha: $head,
     old_path: $op, new_path: $np, new_line: $e.new_line, old_line: $e.old_line}
     + (if $s.new_line == $e.new_line then {} else {line_range: {start: $s, end: $e}} end))}')

if [ "$dry" = 1 ]; then echo "$body"; exit 0; fi

res=$(glab api -X POST "projects/$pid/merge_requests/$iid/draft_notes" \
  -H 'Content-Type: application/json' --input - <<<"$body")
id=$(jq -r .id <<<"$res")
# GitLab accepts a bad position silently and stores a general comment instead.
if [ "$(jq -r '.position.new_path // empty' <<<"$res")" != "$path" ]; then
  glab api -X DELETE "projects/$pid/merge_requests/$iid/draft_notes/$id" >/dev/null
  echo "position rejected, draft $id deleted: $res" >&2
  exit 1
fi
echo "draft $id: $path:$start-$end"
