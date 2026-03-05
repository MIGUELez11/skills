# PRD Template

Use this structure for every PRD written by the `obsidian-prd` skill.

---

```markdown
---
title: <Title>
created: YYYY-MM-DD HH:mm
status: draft
repo: <repo-name or empty>
---

## Problem Statement

Describe the problem being solved. Who is affected? What breaks or is missing today?
Be specific — avoid generic framing.

## Solution

High-level description of the proposed solution. What does it do? How does it fit into the
existing system? Keep this conceptual; details go in Implementation Decisions.

## User Stories

Exhaustive numbered list. Every meaningful interaction should be captured.

1. As a <actor>, I want <feature>, so that <benefit>.
2. As a <actor>, I want <feature>, so that <benefit>.
...

## Implementation Decisions

One subsection per major decision or module. Describe the approach and rationale.
Do NOT include file paths or code snippets — they go stale.

### <Module or Decision Name>

What is being built or changed, and why this approach was chosen over alternatives.

## Testing Decisions

Describe what makes a good test for this feature. Focus on observable, external behavior —
not implementation internals. Note which modules need tests and what scenarios matter most.

## Out of Scope

Explicit list of things that will NOT be addressed in this PRD. Helps prevent scope creep.

- <item>
- <item>

## Further Notes

Open questions, follow-up tasks, references, or anything that didn't fit above.
```
