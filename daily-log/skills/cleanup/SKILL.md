---
name: cleanup
description: Clean up old daily-log files. Use when user asks to clean up logs, delete old logs, rotate logs, or free up log space.
---

# Daily Log Cleanup

## Overview
Helps users manage log disk usage by archiving or deleting old log files.

## How to Clean Up

### Step 1: Show current state
- Count total days of logs in `~/.claude/logs/daily/`
- Show total disk usage
- Count summaries in `~/.claude/logs/summaries/`

### Step 2: Ask the user what to keep
Use AskUserQuestion with options:
- **Keep last 7 days** — delete everything older than 7 days
- **Keep last 30 days** — delete everything older than 30 days
- **Keep last 90 days** — delete everything older than 90 days
- **Delete all** — remove all logs and summaries
- **Custom** — ask for a specific number of days

### Step 3: Confirm and execute
- Show exactly what will be deleted (list the date directories)
- Ask for confirmation before deleting
- Delete the selected date directories from `~/.claude/logs/daily/`
- Optionally delete corresponding summaries from `~/.claude/logs/summaries/`

### Step 4: Report results
- Show how much space was freed
- Show remaining log count

## Important
- Always confirm before deleting
- Summaries are separate from raw logs — ask if they want to delete summaries too
- Never delete today's logs
