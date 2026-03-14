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

### Step 2: Auto-summary preference
Ask the user using AskUserQuestion:
> "Automatically generate summaries for previous days when you start a new session?"

Options:
- **Yes** (recommended) — on SessionStart, catch up on any unsummarized days
- **No** — only generate summaries when you manually run `/daily-log:daily-log-summary`

### Step 3: Choose publish destination
Ask the user using AskUserQuestion:
> "Where would you like to publish daily summaries?"

Options:
- **Slack** — post to a Slack channel (requires Slack MCP server)
- **Discord** — post via Discord webhook URL (no bot needed)
- **Webhook** — post to any HTTP endpoint (works with Teams, Zapier, n8n, etc.)
- **Obsidian** — save as a daily note in your Obsidian vault
- **Notion** — post to a Notion page (requires Notion API key)
- **Local only** — just save summaries as markdown files (no publishing)

### Step 4: Configure the chosen destination

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
3. Explain the payload format:
```json
{
  "text": "## 2026-03-14\n\n### myapp\n- Fixed login bug",
  "date": "2026-03-14",
  "projects": ["myapp", "api-server"]
}
```

**If Obsidian:**
1. Ask for the vault path (e.g., `~/Documents/Zettelkasten`)
2. Ask for the folder within the vault for daily summaries (e.g., `daily-logs` or `Claude`)
3. Notes will be saved as `YYYY-MM-DD.md` in that folder
4. Ask if they want to append to existing daily notes or create separate files

**If Notion:**
1. Ask for the Notion API key (tell them: "Settings → Connections → Develop or manage integrations → create one")
2. Ask for the parent page ID or database ID where summaries should go
3. Note: requires the Notion page to be shared with the integration

**If Local only:**
- No additional config needed, summaries save to `~/.claude/logs/summaries/`

### Step 5: Write config file
Save to `~/.claude/daily-log.json`:

**Slack example:**
```json
{
  "autoSummary": true,
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
  "autoSummary": true,
  "publish": {
    "type": "discord",
    "webhookUrl": "https://discord.com/api/webhooks/..."
  }
}
```

**Webhook example:**
```json
{
  "autoSummary": true,
  "publish": {
    "type": "webhook",
    "url": "https://hooks.example.com/daily-summary",
    "headers": {
      "Authorization": "Bearer token123"
    }
  }
}
```

**Obsidian example:**
```json
{
  "autoSummary": true,
  "publish": {
    "type": "obsidian",
    "vaultPath": "~/Documents/Zettelkasten",
    "folder": "daily-logs",
    "appendToExisting": true
  }
}
```

**Notion example:**
```json
{
  "autoSummary": true,
  "publish": {
    "type": "notion",
    "apiKey": "ntn_...",
    "parentPageId": "abc123..."
  }
}
```

**Local only:**
```json
{
  "autoSummary": true,
  "publish": {
    "type": "local"
  }
}
```

### Step 6: Confirm setup
- Show the saved config (mask API keys/webhook URLs showing only first/last 4 chars)
- Remind them of available skills:
  - `/daily-log:status` — check logging status and stats
  - `/daily-log:daily-log-summary` — generate summaries and publish
  - `/daily-log:cleanup` — manage old log files
  - `/daily-log:setup` — re-run this setup anytime

## Important
- Use AskUserQuestion for each preference question (provides clickable UI)
- The config file location is always `~/.claude/daily-log.json` (not inside the plugin directory — it persists across plugin updates)
- If config already exists, show current values and ask if they want to change them
- API keys, webhook URLs, and tokens are sensitive — mask them when displaying
