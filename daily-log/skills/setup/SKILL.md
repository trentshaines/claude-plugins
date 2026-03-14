---
name: setup
description: Set up the daily-log plugin configuration. Use when user says "setup daily-log", "configure daily-log", "set up slack for daily log", or "daily-log setup".
---

# Daily Log Plugin Setup

## Overview
Interactive setup for the daily-log plugin. Creates `~/.claude/daily-log.json` with the user's preferences.

## Setup Steps

### Step 1: Verify logging is working
- Check if `~/.claude/logs/daily/` exists and has log files
- If not, explain that logs will start appearing after the next Claude Code session since hooks run on UserPromptSubmit and Stop events

### Step 2: Slack integration (optional)
Ask the user:
> "Would you like to set up Slack integration for posting daily summaries?"

**If yes:**
1. Ask for the Slack channel name (e.g., `#daily-standup`, `#trent-log`)
2. Ask for the Slack channel ID (tell them: "You can find this by right-clicking the channel in Slack → View channel details → the ID is at the bottom")
3. Confirm the details before saving

**If no:**
- Skip Slack config, note that they can run this setup again later

### Step 3: Write config file
Save to `~/.claude/daily-log.json`:

```json
{
  "slack": {
    "enabled": true,
    "channelId": "C0AJS2NCENP",
    "channelName": "#their-channel"
  }
}
```

If they skipped Slack:
```json
{
  "slack": {
    "enabled": false
  }
}
```

### Step 4: Confirm setup
- Show the saved config
- Remind them of available skills:
  - `/daily-log:daily-log` — view and query raw logs
  - `/daily-log:daily-log-summary` — generate summaries and optionally post to Slack
  - `/daily-log:setup` — re-run this setup anytime

## Important
- Use AskUserQuestion for each preference question (provides clickable UI)
- The config file location is always `~/.claude/daily-log.json` (not inside the plugin directory — it persists across plugin updates)
- If config already exists, show current values and ask if they want to change them
