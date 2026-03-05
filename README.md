# MIGUELez11/skills

A collection of reusable agent skills for Claude Code and other AI assistants.

## Installation

```bash
npx skills add https://github.com/MIGUELez11/skills --skill <skill-name>
```

## Available Skills

| Name | Description |
|------|-------------|
| [atlassian-cli](skills/atlassian-cli/SKILL.md) | Interact with Jira and Confluence from the terminal using the Atlassian CLI (acli) |
| [git-jira-branch](skills/git-jira-branch/SKILL.md) | Switch to the git branch for a Jira ticket, or create one via `jiraSwitchToBranch` |
| [jira-cli](skills/jira-cli/SKILL.md) | Interact with Jira from the terminal using ankitpokhrel/jira-cli (`jira` command) |
| [jira-ticket-writer](skills/jira-ticket-writer/SKILL.md) | Write well-structured Jira tickets with consistent templates |
| [obsidian-tasks](skills/obsidian-tasks/SKILL.md) | Manage tasks and PRDs in an Obsidian vault via direct file creation |
| [write-a-skill](skills/write-a-skill/SKILL.md) | Add a new skill to this repo |

## Structure

Each skill lives in its own directory:

```
skills/
└── <skill-name>/
    ├── SKILL.md       # Agent instructions
    └── scripts/       # Optional automation helpers
```

## License

MIT
