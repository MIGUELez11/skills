# Jira Ticket Templates

## Bug

```
**Summary**: Fix <what breaks> in <where/context>

**Type**: Bug

**Priority**: [Critical | High | Medium | Low]

**Context**
Who is affected, how often, what is the business impact.

**Steps to Reproduce**
1. ...
2. ...
3. ...

**Expected Behaviour**
What should happen.

**Actual Behaviour**
What actually happens. Include error messages, screenshots, or logs if available.

**Environment**
- Platform / OS:
- Browser / App version:
- Account type or feature flag (if relevant):

**Root Cause** (if known)
Leave blank if unknown — do not guess.

**Acceptance Criteria**
- [ ] The bug no longer reproduces following the steps above
- [ ] Regression test added (or justified why not)
- [ ] No new console errors introduced

**Definition of Done**
- [ ] Code reviewed and approved
- [ ] Tests passing in CI
- [ ] Verified in staging
- [ ] Product / QA sign-off (if required)
```

---

## Story / Feature

```
**Summary**: Add/Improve <capability> for <user or context>

**Type**: Story

**Priority**: [Critical | High | Medium | Low]

**User Story**
As a <persona>, I want <goal>, so that <benefit>.

**Context**
Why is this needed now? What problem does it solve? What is the business value?

**Scope**
What is explicitly in scope. What is explicitly out of scope (if ambiguous).

**Acceptance Criteria**
- [ ] ...
- [ ] ...
(Each item should be independently testable. Use Given/When/Then for behaviour-driven criteria.)

**Design / Technical Notes** (optional)
Links to designs, ADRs, or technical constraints.

**Definition of Done**
- [ ] Feature works end-to-end in staging
- [ ] Unit and integration tests added
- [ ] Code reviewed and approved
- [ ] Docs or tooltips updated (if user-facing)
- [ ] Product sign-off received
```

---

## Task / Chore

```
**Summary**: <Verb> <object> — e.g. "Migrate user table to Postgres 16"

**Type**: Task

**Priority**: [Critical | High | Medium | Low]

**Context**
Why is this work needed? What breaks or degrades without it?

**Description**
What needs to be done. Break into sub-tasks if helpful.

**Definition of Done**
- [ ] ...
- [ ] ...
```

---

## Spike / Research

```
**Summary**: Spike: Investigate <topic>

**Type**: Spike (or Task, depending on project configuration)

**Time-box**: [e.g. 2 days]

**Context**
What decision or problem does this research unblock?

**Goal**
What question(s) must be answered by the end of this spike?

**Out of scope**
What should NOT be built or decided during this spike.

**Deliverables**
- [ ] Summary document or Confluence page with findings
- [ ] Recommendation with pros/cons
- [ ] Follow-up tickets created if applicable

**Definition of Done**
- [ ] All goal questions answered
- [ ] Findings shared with the team
- [ ] Next steps agreed
```

---

## Tips for all ticket types

- **Attach evidence**: screenshots, logs, Loom recordings, or Figma links reduce back-and-forth.
- **Link related tickets**: blocks, is blocked by, duplicates, or relates to.
- **Tag the epic**: always link to the parent epic so the ticket appears in roadmap views.
- **Avoid vague verbs**: "handle", "fix stuff", "improve" — be specific about the change.
- **One concern per ticket**: if a bug has two separate causes, split into two tickets.
