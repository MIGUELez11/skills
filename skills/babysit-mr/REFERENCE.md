# babysit-mr reference

All calls go through `glab api` so they work even when `glab mr ...` subcommands don't. `P` is the URL-encoded project path (`group%2Fsub%2Fproject`) and `IID` is the MR number.

## Moved-project trap

If `origin` still points at a project's old path, GitLab allows GET but rejects writes with `405 Non GET methods are not allowed for moved projects`. `glab mr create`/`note` fail this way even with `-R`. Read the canonical path from any GET (`glab api projects/<old-path> | jq -r .path_with_namespace`) and use it for every write. Leave the user's remote alone; mention the fix in your report.

## Calls

| Need | Call |
|---|---|
| Head SHA, state, conflicts | `glab api projects/$P/merge_requests/$IID \| jq '{sha, state, has_conflicts, detailed_merge_status}'` |
| Latest MR pipeline | `glab api projects/$P/merge_requests/$IID/pipelines \| jq '.[0] \| {id, sha, status}'` |
| Failed jobs | `glab api "projects/$P/pipelines/$PIPELINE/jobs?scope[]=failed" \| jq '.[] \| {id, name, stage}'` |
| Job log | `glab ci trace $JOB -R <group/proj>` or `glab api projects/$P/jobs/$JOB/trace` |
| Retry a job | `glab api -X POST projects/$P/jobs/$JOB/retry` |
| Discussions | `glab api "projects/$P/merge_requests/$IID/discussions?per_page=100"` |
| Reply in a thread | `glab api -X POST projects/$P/merge_requests/$IID/discussions/$DISC/notes -f body="..."` |
| Resolve a thread | `glab api -X PUT "projects/$P/merge_requests/$IID/discussions/$DISC?resolved=true"` |

## Reading discussions

- Skip `notes[0].system == true` (system events).
- A bot's top-level summary note can show `resolvable: false` and turn resolvable once someone replies, so re-read the discussion after replying and resolve it then.
- A thread with a newer reviewer note after your reply is open again; triage that new note.
- `position.new_path` / `position.new_line` locate inline comments; a null position means a general MR comment.

## Pipeline status values

`success` is the only settled state. `running`/`pending`/`created` mean wait. `failed` means triage. `canceled`/`skipped` on the head SHA mean nothing ran; check whether a newer pipeline exists before escalating. `manual` means a human-gated job: escalate unless the repo's docs say agents may trigger it.
