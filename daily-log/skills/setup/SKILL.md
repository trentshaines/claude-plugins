---
name: setup
description: Set up the daily-log plugin configuration. Use when user says "setup daily-log", "configure daily-log", "set up slack for daily log", "daily-log setup", or wants to configure where summaries are published.
---

# Daily Log Plugin Setup

## Overview
Interactive setup for the daily-log plugin. Creates `~/.claude/daily-log.json` with the user's preferences for where to publish daily summaries.

## Setup Steps

### Step 1: Verify logging is working
- Check if `~/.claude/logs/daily/` exists and has log files
- If not, explain that logs will start appearing after the next Claude Code session since hooks run on UserPromptSubmit and Stop events

### Step 2: Choose publish destination
Ask the user using AskUserQuestion:
> "Where would you like to publish daily summaries?"

Options:
- **Slack** — post to a Slack channel (requires Slack MCP server)
- **Discord** — post via Discord webhook URL (no bot needed)
- **Webhook** — post to any HTTP endpoint (works with Teams, Zapier, n8n, etc.)
- **Local only** — just save summaries as markdown files (no publishing)

### Step 3: Configure the chosen destination

**If Slack:**
1. Ask for the Slack channel name (e.g., `#daily-standup`)
2. Ask for the Slack channel ID (tell them: "Right-click the channel in Slack → View channel details → ID is at the bottom")
3. Note: requires a Slack MCP server to be configured in Claude Code

**If Discord:**
1. Ask for the Discord webhook URL (tell them: "Server Settings → Integrations → Webhooks → New Webhook → Copy URL")
2. Test the webhook by sending a test message via curl

**If Webhook:**
1. Ask for the webhook URL
2. Ask if it needs custom headers (e.g., Authorization)
3. Explain the payload format that will be sent:
```json
{
  "text": "## 2026-03-14\n\n### myapp\n- Fixed login bug\n- Added validation",
  "date": "2026-03-14",
  "projects": ["myapp", "api-server"]
}
```

**If Local only:**
- No additional config needed, summaries save to `~/.claude/logs/summaries/`

### Step 4: Write config file
Save to `~/.claude/daily-log.json`:

**Slack example:**
```json
{
  "publish": {
    "type": "slack",
    "channelId": "C0AJS2NCENP",
    "channelName": "#daily-standup"
  }
}
```

**Discord example:**
```json
{
  "publish": {
    "type": "discord",
    "webhookUrl": "https://discord.com/api/webhooks/..."
  }
}
```

**Webhook example:**
```json
{
  "publish": {
    "type": "webhook",
    "url": "https://hooks.example.com/daily-summary",
    "headers": {
      "Authorization": "Bearer token123"
    }
  }
}
```

**Local only:**
```json
{
  "publish": {
    "type": "local"
  }
}
```

### Step 5: Confirm setup
- Show the saved config (mask webhook URLs/tokens showing only first/last 4 chars)
- Remind them of available skills:
  - `/daily-log:status` — check logging status and stats
  - `/daily-log:daily-log-summary` — generate summaries and publish
  - `/daily-log:cleanup` — manage old log files
  - `/daily-log:setup` — re-run this setup anytime

## Important
- Use AskUserQuestion for each preference question (provides clickable UI)
- The config file location is always `~/.claude/daily-log.json` (not inside the plugin directory — it persists across plugin updates)
- If config already exists, show current values and ask if they want to change them
- Webhook URLs and tokens are sensitive — mask them when displaying
