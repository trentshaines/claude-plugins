# daily-log

A Claude Code plugin that automatically logs session activity, generates summaries, and publishes them wherever you want.

**Requires:** python3 (ships with macOS Xcode CLT and most Linux distros)

## What it does

Hooks into `Stop` and `UserPromptSubmit` events to capture:
- Timestamps (UTC ISO 8601)
- Event type (prompt or stop)
- Project name
- Full prompt text (for prompt events)

Logs are written as JSONL to `~/.claude/logs/daily/YYYY-MM-DD/SESSION_ID.jsonl`.

On each new session, it checks for unsummarized days and automatically generates + publishes summaries.

## Install

```bash
claude plugins marketplace add https://github.com/trentshaines/claude-plugins
claude plugin install daily-log
```

Then restart Claude Code. You'll see a welcome message on first run.

## Setup

Run `/daily-log:setup` to configure:

| Destination | How it works |
|-------------|-------------|
| **Slack** | Posts to a channel via Slack MCP server |
| **Discord** | Posts via webhook URL (no bot needed) |
| **Webhook** | Any HTTP endpoint (Teams, Zapier, n8n, etc.) |
| **Obsidian** | Saves as daily notes in your vault |
| **Notion** | Creates pages via Notion API |
| **Local only** | Saves as markdown files (default) |

## Skills

| Skill | Description |
|-------|-------------|
| `/daily-log:status` | Check logging status, today's stats, config |
| `/daily-log:daily-log-summary` | Generate summaries and publish |
| `/daily-log:daily-log` | View and query raw logs |
| `/daily-log:setup` | Configure publish destination and auto-summary |
| `/daily-log:cleanup` | Manage old log files |

## Auto-summary

Enabled by default. When you start a new Claude Code session, the plugin checks for any previous days with logs but no summary. If found, it automatically generates and publishes them before you start working.

Disable in `/daily-log:setup` or set `"autoSummary": false` in `~/.claude/daily-log.json`.

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
