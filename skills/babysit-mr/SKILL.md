---
name: babysit-mr
description: Babysit a GitLab merge request until its pipeline is green and every review comment is answered, fixing what deserves fixing and replying with reasons to what doesn't. Use when the user asks to babysit, watch, or shepherd an MR, or to keep an MR green after opening it.
---

# Babysit MR

You own the MR until it is **settled**, the one completion criterion:

- the latest pipeline on the MR's current head SHA is `success`, and
- every non-system discussion is answered (fixed or rebutted with your reply), and every bot thread is resolved; GitLab blocks merging on unresolved threads (`detailed_merge_status: discussions_not_resolved`).

You never merge. A human merges once you report it settled.

## Quick start

```bash
scripts/mr-status.sh <iid>             # snapshot: head SHA, pipeline, failed jobs, open discussions
scripts/mr-status.sh <iid> <group/proj> # when the remote points at a moved/renamed project
```

## Loop

1. **Arm the watch.** Use the host's MR watcher if it has one (e.g. a `watch_pull_request` tool) and end your turn after each round; it wakes you on new comments or pipeline changes. Without one, self-pace with `/loop`, a wakeup sized to the pipeline's usual duration, never a tight poll.
2. **Snapshot** with `scripts/mr-status.sh`. Work only from it, not from the wake message's preview, which is truncated.
3. **Triage every open discussion** into exactly one bucket:
   - **Fix**: the comment is correct and in scope. Change the code, then reply with what changed and the commit SHA, and resolve the thread if it's resolvable.
   - **Rebut**: the comment is wrong, out of scope, or already handled. Reply with the concrete reason: the file and line, the ticket scope, or the MR that already did it. Bots (gitStream, linters, AI reviewers) confuse tickets and misread diffs; check every claim against the code before agreeing.
   - **Escalate**: the comment needs a human call (see below). Reply that you've flagged it, and leave it open.
4. **Fix the pipeline** if it's `failed`: read the failed job's log (`glab ci trace <job-id>`) and classify the failure:
   - caused by this MR → fix it like a comment;
   - flaky or infra (timeouts, runner loss, registry 5xx) → retry the job once (`glab ci retry <job-id>`);
   - also red on the target branch → escalate; it isn't this MR's fight.
5. **Ship the round**: one commit per round in the repo's commit convention (ticket prefix, attribution trailer), then a plain `git push`. Verify locally first (lint, typecheck, the touched tests). A push restarts the pipeline, so batch fixes into one push.
6. **Check settled.** If it isn't settled, end the turn and let the watcher wake you. If it is, report and stop the watch.

## Escalate to the human

Stop fixing and call it out when any of these hold:

- A human reviewer asked for something that changes scope, product behaviour, or the design.
- A comment touches security, permissions, data handling, or compliance.
- The same failure survived two fix attempts, or one retry for flakes.
- The pipeline needs a manual job, an approval, or credentials you don't have.
- The branch conflicts with its target and resolving it needs judgement about someone else's changes.
- You disagree with a human reviewer. Rebut bots freely, but a disagreement with a person goes in the thread *and* in your report.

The callout is one block, at the top of your message:

```
⚠️ Needs you: <MR link>
- <thread link>: <one line: what's being asked and why it's yours to decide>
```

## Replies

- Reply inside the discussion thread, never as a new top-level note.
- One or two sentences: the verdict first, then the evidence (file:line, commit SHA, ticket key, MR number).
- Append `_(Reply drafted by <agent name>.)_` so reviewers know it's AI-written.
- Resolve every bot thread you fixed or rebutted; bots never close their own, so they'd block the merge forever. Resolve human threads only when you fixed them. Rebuttals to humans and escalations stay open for the author.

## Report

Each round, report in a few lines: what you fixed (with SHAs), what you rebutted (one-line reason each), the pipeline state, and any escalation block. On settled, say so plainly and name the green pipeline ID.

API recipes, the moved-project trap and reply/resolve calls: [REFERENCE.md](REFERENCE.md).
