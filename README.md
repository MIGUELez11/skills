# MIGUELez11/skills

A collection of reusable agent skills for Claude Code and other AI assistants.

## Installation

```bash
npx skills add https://github.com/MIGUELez11/skills --skill <skill-name>
```

## Available Skills

| Name | Description |
|------|-------------|
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
