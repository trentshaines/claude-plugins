# daily-log

A Claude Code plugin that automatically logs session activity, generates summaries, and publishes them to Slack, Discord, or any webhook.

**Requires:** python3 (ships with macOS Xcode CLT and most Linux distros)

## What it does

Hooks into `Stop` and `UserPromptSubmit` events to capture:
- Timestamps (UTC ISO 8601)
- Event type (prompt or stop)
- Project name
- Full prompt text (for prompt events)

Logs are written as JSONL to `~/.claude/logs/daily/YYYY-MM-DD/SESSION_ID.jsonl`.

## Install

```bash
claude plugins marketplace add https://github.com/trentshaines/claude-plugins
claude plugin install daily-log
```

Then restart Claude Code. You'll see a welcome message on first run.

## Setup

Run `/daily-log:setup` to configure where summaries are published:
- **Slack** — post to a channel (requires Slack MCP server)
- **Discord** — post via webhook URL
- **Webhook** — any HTTP endpoint (Teams, Zapier, n8n, etc.)
- **Local only** — save as markdown files (default, no config needed)

## Skills

| Skill | Description |
|-------|-------------|
| `/daily-log:status` | Check logging status, today's stats, config |
| `/daily-log:daily-log-summary` | Generate summaries and publish |
| `/daily-log:daily-log` | View and query raw logs |
| `/daily-log:setup` | Configure publish destination |
| `/daily-log:cleanup` | Manage old log files |

## Query logs manually

```bash
# Today's prompts
cat ~/.claude/logs/daily/$(date +%Y-%m-%d)/*.jsonl | jq -r 'select(.event=="prompt") | .prompt'

# Projects worked on
cat ~/.claude/logs/daily/$(date +%Y-%m-%d)/*.jsonl | jq -r '.project' | sort -u
```

## Update

```bash
claude plugins marketplace update trentshaines-plugins
claude plugin update daily-log
```
