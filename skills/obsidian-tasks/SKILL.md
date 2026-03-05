---
name: obsidian-tasks
description: Manages tasks and PRDs in an Obsidian vault via direct file creation. Use when creating task notes, PRD documents, linking tasks to PRDs, or managing blocked-by relationships in an Obsidian Kanban workflow. Triggered by phrases like "create a task", "add a PRD", "link this to a PRD", "mark as blocked by", or "add to kanban".
---

# Obsidian Tasks

Manages tasks and PRDs in any Obsidian vault using direct file writes. Obsidian's filesystem watcher picks up changes instantly — no plugin or CLI needed.

## Setup

Establish vault context at the start of each session:
- **Vault path**: absolute path to the vault root — default `~/Documents/Obsidian/<vault-name>`
- **Tasks folder**: default `Tasks/`
- **PRD folder**: default `PRD/`
- **Kanban board**: default `Kanban board.md`

If not provided, ask the user before proceeding.

## Workflows

### Create a task

1. Determine title, type, priority, and optional jira-ticket/prd from context
2. Generate `created` timestamp: `YYYY-MM-DD HH:mm` (current date/time)
3. Write `<vault>/Tasks/<Title>.md` with frontmatter:

```yaml
---
title: <title>
type: feature | bug | chore | spike
priority: high | medium | low
blocked-by: []
jira-ticket:
prd:
created: <YYYY-MM-DD HH:mm>
---
```

4. Add body sections: `## Context`, `## Task`, `## Acceptance Criteria`, `## Notes`
5. Confirm file path to the user

### Create a PRD

Write `<vault>/PRD/<Title>.md` with:

```yaml
---
title: <title>
created: <YYYY-MM-DD HH:mm>
status: draft | review | approved
---
```

Body sections: `## Problem`, `## Goals`, `## Non-goals`, `## Solution`, `## Open Questions`

### Link a task to a PRD

Set `prd: "[[PRD Title]]"` in the task's frontmatter. Use the exact PRD filename (without `.md`) as the link target.

### Set blocked-by

Set `blocked-by` as a YAML list in the task's frontmatter:

```yaml
blocked-by:
  - "[[Blocking Task Title]]"
  - "[[Another Task]]"
```

The Kanban plugin renders these as clickable links on cards.

## Key rules

- **Never use Templater syntax** (`<% ... %>`) — write final values directly
- **Filenames = identifiers** — wiki-links resolve by filename, so keep titles stable
- **Direct writes only** — no Obsidian CLI or API required; the vault filesystem is the interface
- **Kanban lanes** are managed by the user in Obsidian — do not modify `Kanban board.md` to move cards
