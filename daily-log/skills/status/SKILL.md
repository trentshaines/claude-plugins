---
name: status
description: Check daily-log plugin status, stats, and configuration. Use when user asks about logging status, how many logs, is logging working, or daily-log status.
---

# Daily Log Status

## Overview
Shows the current state of the daily-log plugin — whether logging is active, today's stats, and publish destination config.

## How to Check Status

### Step 1: Verify logging is active
- Check if `~/.claude/logs/daily/` exists
- Check if today's directory exists: `~/.claude/logs/daily/YYYY-MM-DD/`
- Count JSONL files in today's directory (each = one session)

### Step 2: Show today's stats
- Count total log entries across all session files today
- Count prompt events vs stop events
- List projects worked on today
- Show first and last timestamps for time range

Run these commands:
```bash
# Session count
ls ~/.claude/logs/daily/$(date +%Y-%m-%d)/*.jsonl 2>/dev/null | wc -l

# Entry counts
cat ~/.claude/logs/daily/$(date +%Y-%m-%d)/*.jsonl 2>/dev/null | python3 -c "
import sys, json
prompts = stops = 0
projects = set()
for line in sys.stdin:
    d = json.loads(line)
    if d['event'] == 'prompt': prompts += 1
    elif d['event'] == 'stop': stops += 1
    projects.add(d.get('project',''))
print(f'Prompts: {prompts}')
print(f'Stops: {stops}')
print(f'Projects: {", ".join(sorted(projects))}')
"
```

### Step 3: Show config status
- Read `~/.claude/daily-log.json` if it exists
- Show publish destination (Slack/Discord/webhook/none)
- Show channel/webhook URL (masked)
- If no config exists, note that publishing is not configured and suggest `/daily-log:setup`

### Step 4: Show log history
- Count how many days of logs exist total
- Show total disk usage of `~/.claude/logs/`
- If over 30 days of logs, suggest running `/daily-log:cleanup`

### Output Format
```
Daily Log Status
================
Logging: active
Today: 12 prompts, 4 stops across 3 sessions
Projects: myapp, dotfiles, api-server
Time range: 09:15 - 14:32 UTC

Publishing: Slack (#daily-standup)
Config: ~/.claude/daily-log.json

History: 23 days of logs (1.2 MB)
```
