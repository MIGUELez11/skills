---
name: obsidian-prd
description: Guides the user through a structured PRD creation process via interview, then writes the PRD to an Obsidian vault. Use when user asks to "create a PRD", "add a PRD", "write requirements", "write a spec", or "plan a feature".
---

# Obsidian PRD

Guides the user through a 5-phase interview process and writes a structured PRD to an Obsidian vault.

## Setup

Establish vault context before starting:
- **Vault path**: absolute path to vault root — default `~/Documents/Obsidian/<vault-name>`
- **PRD folder**: default `PRD/`

If not provided, ask the user before proceeding.

## Workflow

### Phase 1 — Describe

Ask for a long, detailed description of:
- The problem being solved
- Any solution ideas the user already has
- Who is affected

Do not proceed until this is thorough.

### Phase 2 — Explore (skip if no repo context)

Explore the repository to verify assertions and understand current state:
- Identify relevant modules, files, and patterns
- Note what exists vs. what must be built
- Flag any mismatches with the user's description

### Phase 3 — Interview

Relentlessly ask about every aspect until nothing is ambiguous. Cover:
- **Actors**: who uses this? internal users, external users, systems?
- **Scope**: what is explicitly in vs. out?
- **Edge cases**: failure modes, empty states, concurrent access, permissions
- **Dependencies**: external services, libraries, other modules
- **Design decisions**: present options and resolve them one by one

Do not batch all questions at once. Work through them conversationally, resolving each before moving on.

### Phase 4 — Sketch Modules

Identify the major modules to build or modify:
- Mark each as **deep** (significant logic) or **shallow** (config/glue)
- For each deep module, ask: "Does this need tests? What behavior matters most?"
- Confirm the list with the user before writing the PRD

### Phase 5 — Write PRD

Write `<vault>/PRD/<Title>.md` using the template in `TEMPLATE.md`.

Frontmatter:
```yaml
---
title: <title>
created: YYYY-MM-DD HH:mm
status: draft
repo: <repo-name or empty>
---
```

Body: see `TEMPLATE.md` for full section structure.

Confirm the file path to the user when done.

## Key Rules

- **Never use Templater syntax** — write final values directly
- **Filenames = wiki-link identifiers** — keep titles stable after creation
- **User Stories must be exhaustive** — use format: "As a \<actor\>, I want \<feature\>, so that \<benefit\>"
- **Implementation Decisions**: describe approach and rationale — no file paths or code snippets (they go stale)
- **Testing Decisions**: describe external behavior to test, not implementation internals
