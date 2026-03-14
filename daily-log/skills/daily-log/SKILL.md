---
name: daily-log
description: View, query, and customize Claude Code daily usage logs. Use when user asks about session history, usage logs, what they worked on, or wants to customize logging behavior.
---

# Daily Log

## Overview

This plugin automatically logs Claude Code usage to daily JSONL files. Each session gets its own file, capturing prompts and stop events.

## Log Structure

- **Log directory**: `~/.claude/logs/daily/YYYY-MM-DD/`
- **File pattern**: `SESSION_ID.jsonl` (one file per session per day)
- **Format**: JSONL (one JSON object per line)

## Log Entry Format

### Prompt events (UserPromptSubmit)
```json
{"ts": "2026-03-14T22:00:00Z", "event": "prompt", "project": "myapp", "prompt": "fix the login bug"}
```

### Stop events
```json
{"ts": "2026-03-14T22:05:00Z", "event": "stop", "project": "myapp"}
```

## Common Queries

### View today's logs
```bash
cat ~/.claude/logs/daily/$(date +%Y-%m-%d)/*.jsonl
```

### See what prompts you sent today
```bash
cat ~/.claude/logs/daily/$(date +%Y-%m-%d)/*.jsonl | jq -r 'select(.event=="prompt") | "\(.ts) [\(.project)] \(.prompt)"'
```

### Projects worked on today
```bash
cat ~/.claude/logs/daily/$(date +%Y-%m-%d)/*.jsonl | jq -r '.project' | sort -u
```

### Count prompts per project
```bash
cat ~/.claude/logs/daily/$(date +%Y-%m-%d)/*.jsonl | jq -r 'select(.event=="prompt") | .project' | sort | uniq -c | sort -rn
```

## When Helping Users

- Show them how to query logs with `jq`
- For summaries, suggest `/daily-log:daily-log-summary`
- Remind them logs are per-session JSONL — each session gets its own file
- Old date directories can be safely archived or deleted
