#!/usr/bin/env bash
# Snapshot of an MR for babysitting: head SHA, latest pipeline, failed jobs, open discussions.
# Usage: mr-status.sh <iid> [group/project]   (project defaults to the current repo's canonical path)
set -euo pipefail

iid="${1:?usage: mr-status.sh <iid> [group/project]}"
if [[ -n "${2:-}" ]]; then
  project="$2"
else
  remote_path="$(git remote get-url origin | sed -E 's#^(git@[^:]+:|https?://[^/]+/)##; s#\.git$##')"
  # GETs follow project moves, so this resolves the canonical path writes must use.
  project="$(glab api "projects/${remote_path//\//%2F}" | jq -r .path_with_namespace)"
fi
p="${project//\//%2F}"

mr="$(glab api "projects/$p/merge_requests/$iid")"
echo "MR !$iid ($project): $(jq -r '"\(.state) sha=\(.sha[0:9]) conflicts=\(.has_conflicts) merge_status=\(.detailed_merge_status)"' <<<"$mr")"
echo "    $(jq -r .web_url <<<"$mr")"

pipeline="$(glab api "projects/$p/merge_requests/$iid/pipelines" | jq '.[0] // empty')"
if [[ -z "$pipeline" ]]; then
  echo "Pipeline: none"
else
  pid="$(jq -r .id <<<"$pipeline")"
  echo "Pipeline: $pid $(jq -r '.status' <<<"$pipeline") sha=$(jq -r '.sha[0:9]' <<<"$pipeline")"
  glab api "projects/$p/pipelines/$pid/jobs?scope[]=failed&per_page=100" \
    | jq -r '.[] | "  FAILED job \(.id) [\(.stage)] \(.name)"'
fi

me="$(glab api user | jq -r .username)"
echo "Discussions needing triage (unresolved, or last note not by $me):"
glab api "projects/$p/merge_requests/$iid/discussions?per_page=100" | jq -r --arg me "$me" '
  .[] | select(.notes[0].system | not)
  | select((.notes[0].resolvable and (.notes | any(.resolved | not))) or (.notes[-1].author.username != $me))
  | "- \(.id) by \(.notes[0].author.username) at \(.notes[0].position.new_path // "general"):\(.notes[0].position.new_line // "-") resolvable=\(.notes[0].resolvable)\n  last: \(.notes[-1].author.username): \(.notes[-1].body | gsub("\\s+"; " ") | .[0:300])"'
