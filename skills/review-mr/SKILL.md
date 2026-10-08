---
name: review-mr
description: Review a GitLab MR and leave the findings as draft comments the user publishes. Runs code-review against the MR's target, summarises the changes, flags where to look, and splits findings into must-fix and nits, written in Simplified Technical English. Use when the user asks to review an MR, or to draft review comments on an MR.
---

# Review MR

You produce a **draft review**: every comment sits in GitLab as a draft note, and the user reads, edits and publishes it. The user publishes; you stop at draft.

## Steps

1. **Pin the MR.** `glab mr view <iid> -F json` gives `target_branch`, `diff_refs` and `project_id`. Fetch `refs/merge-requests/<iid>/head`. Read files at the head SHA with `git show <head>:<path>`, so the user's checkout stays untouched. The fixed point is the target branch. For a stacked MR (the description names a parent MR, or `git log <target>..<head>` shows the parent's commits), the fixed point is the parent MR's head.
2. **Review.** Run the `code-review` skill with that fixed point, diffing `<fixed-point>...<head>` in place of `HEAD`. Done when both axes have reported.
3. **Triage** every finding into one bucket:
   - **Must fix**: this MR can fix it, and merging without the fix breaks behaviour, breaks a documented standard, leaves new behaviour untested, or ships a spec deviation.
   - **Nit**: a real improvement that can wait, such as a smell, naming, or consistency.
   - **Not posted**: this MR can't fix it (it belongs to the ticket, another MR or a follow-up), or a check of the code shows it's wrong.
4. **Report to the user**, in this order:
   - **Summary**: 3–5 bullets on what the MR changes.
   - **Look at**: the 2–3 places where human judgement matters most (risky logic, design calls). Give `file:line` and one line on why.
   - **Must fix**, **Nits** and **Not posted**: one line each, with `file:line`.
5. **Write each comment** to the rules in [Comment style](#comment-style).
6. **Post the drafts**, one per must-fix and nit, from a clone of the MR's project:

   ```bash
   scripts/draft-note.sh <iid> <new_path> <start> <end> <<'EOF'
   Import `cn` from `@/lib/utils`. The frontend-next CLAUDE.md requires this path.
   EOF
   ```

   `<start>..<end>` spans the whole code block the comment is about (the statement, function, JSX element or import), in new-file line numbers. Add `--dry-run` to print the payload without posting it. Done when every must-fix and nit has a draft with a position, and you have listed the draft ids to the user.

## Comment style

Write in **ASD-STE100 Simplified Technical English**: your readers include junior developers who aren't native English speakers.

- One topic per comment, in one to three sentences.
- Sentences of 20 words or fewer, with one instruction each.
- Use active voice and the imperative for the fix: "Import `cn` from `@/lib/utils`."
- Use the simple present, past and future tenses.
- Use common words, and one word for each meaning. Use single-word verbs ("start", "remove"), not phrasal verbs or idioms.
- Write identifiers in backticks.
- Start each nit with `nit: `. Write must-fix comments as plain text, with no prefix.
- Write as the user. The comment is only the finding and the fix: put no sign-off, AI note, heading or emoji around it.

Bad:

> In callback mode the component no longer drops `cursor`/`page`, so it's left to the caller, but the docblock still promises it, which means MR 4 could easily reintroduce the desync.

Good:

> In callback mode, this component does not reset `cursor` and `page`. The docblock says it does. Reset them here, or tell the caller to reset them in the `onSizeChange` doc.

> nit: The disabled Prev arrow is a `Link`. In callback mode, the other arrows are buttons. Use a button here too.

## Gotchas

`scripts/draft-note.sh` handles these. Know them if you post by hand:

- `glab api -f 'position[...]=…'` doesn't nest the keys, and GitLab then stores a general comment with no position and no error. Send JSON with `--input -`.
- A renamed file needs `old_path`. An unchanged line needs both `old_line` and `new_line`.
- A merged MR loses its source branch, but `refs/merge-requests/<iid>/head` stays.
