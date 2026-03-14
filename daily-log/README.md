# daily-log

A Claude Code plugin that automatically logs session activity and generates summaries.

## What it does

Hooks into `Stop` and `UserPromptSubmit` events to capture:
- Timestamps (UTC ISO 8601)
- Event type (prompt or stop)
- Project name
- Full prompt text (for prompt events)

Logs are written as JSONL to `~/.claude/logs/daily/YYYY-MM-DD/SESSION_ID.jsonl`.

## Install

### Test locally
```bash
claude --plugin-dir /path/to/daily-log
```

### From marketplace
```bash
claude plugins add-marketplace https://github.com/yourname/claude-plugins
claude plugin install daily-log
```

## Setup

Run `/daily-log:setup` to configure Slack integration (optional).

## Skills

| Skill | Description |
|-------|-------------|
| `/daily-log:daily-log` | View and query raw logs |
| `/daily-log:daily-log-summary` | Generate summaries, optionally post to Slack |
| `/daily-log:setup` | Configure Slack channel and preferences |

## Query logs

```bash
# Today's prompts
cat ~/.claude/logs/daily/$(date +%Y-%m-%d)/*.jsonl | jq -r 'select(.event=="prompt") | .prompt'

# Projects worked on
cat ~/.claude/logs/daily/$(date +%Y-%m-%d)/*.jsonl | jq -r '.project' | sort -u
```
