---
name: daily-log-summary
description: Generate daily activity summaries from Claude Code logs and optionally publish to Slack, Discord, Obsidian, Notion, or webhook. Use when the user asks for a daily summary, work log, what they did today/yesterday, activity report, or when auto-summary triggers on session start.
---

# Daily Summary Generator

## Overview
Generates concise bullet-point summaries of daily Claude Code activity from JSONL hook logs, with optional publishing to configured destinations.

## Data Locations
- **Raw logs**: `~/.claude/logs/daily/YYYY-MM-DD/SESSION_ID.jsonl`
- **Summaries**: `~/.claude/logs/summaries/YYYY-MM-DD.md`
- **Plugin config**: `~/.claude/daily-log.json`

## Log Format
Each JSONL file contains entries like:
```json
{"ts": "2026-03-06T...", "event": "prompt", "project": "chezmoi", "prompt": "fix the login bug"}
{"ts": "2026-03-06T...", "event": "stop", "project": "chezmoi"}
```

## How to Generate Summaries

### Step 1: Determine which days need summaries
- Specific day requested → use that day
- "catch up" or "all" or auto-summary trigger → find ALL date directories in `~/.claude/logs/daily/` that don't have a corresponding file in `~/.claude/logs/summaries/` (exclude today)
- "today" → today's date
- "yesterday" → yesterday's date

### Step 2: Read the raw logs
- For each unsummarized day, read all `*.jsonl` files in `~/.claude/logs/daily/YYYY-MM-DD/`
- Extract only `"event": "prompt"` entries
- Group by project

### Step 3: Generate the summary
- Group prompts by project
- Deduplicate and consolidate similar prompts into single bullet points
- Write concise, action-oriented bullets (e.g., "Added tmux keybinding for last-window")
- Merge trivial follow-ups into the parent task (e.g., "fix typo" after "add feature" = one bullet)
- Ignore conversational prompts that aren't real work (e.g., "yes", "ok", "thanks")

### Step 4: Show the summary and save
- Display each day's summary
- Save the summary file immediately (no need to ask for confirmation)
- If a summary file already exists for that day, show it and ask if the user wants to overwrite before saving

Write to `~/.claude/logs/summaries/YYYY-MM-DD.md` in this format:

```markdown
# YYYY-MM-DD

## project-name
- Bullet point describing what was done
- Another bullet point

## another-project
- What was done here
```

### Step 5: Publish
- Read `~/.claude/daily-log.json` to check publish config
- If not configured, tell the user: "Publishing isn't set up. Run `/daily-log:setup` to configure a destination."
- If auto-summary triggered this (session start), publish automatically without asking for confirmation
- If manually triggered, ask before publishing

**Based on publish type:**

**Slack** (`"type": "slack"`):
- Use Slack MCP tools to post to the configured channel ID
- Format as a clean message with the summary markdown

**Discord** (`"type": "discord"`):
- POST to the webhook URL:
```bash
curl -s -H "Content-Type: application/json" -d '{"content": "SUMMARY_TEXT"}' WEBHOOK_URL
```

**Webhook** (`"type": "webhook"`):
- POST JSON payload:
```json
{
  "text": "SUMMARY_MARKDOWN",
  "date": "YYYY-MM-DD",
  "projects": ["project1", "project2"]
}
```
- Include any custom headers from config

**Obsidian** (`"type": "obsidian"`):
- Expand `~` in `vaultPath` to the full home directory path
- Target file: `{vaultPath}/{folder}/YYYY-MM-DD.md`
- If `appendToExisting` is true and the file exists, append a `## Claude Code Activity` section
- If `appendToExisting` is false or file doesn't exist, write as a new file
- Create the folder if it doesn't exist

**Notion** (`"type": "notion"`):
- Use the Notion API to create a new page under the configured parent
- POST to `https://api.notion.com/v1/pages` with:
  - Parent page/database ID from config
  - Title: `YYYY-MM-DD Claude Code Summary`
  - Content: summary as paragraph blocks
- Use `Authorization: Bearer {apiKey}` and `Notion-Version: 2022-06-28` headers

**Local** (`"type": "local"`) or no config:
- Summary is already saved to `~/.claude/logs/summaries/`, just confirm the path

## Auto-Summary Behavior
When triggered by SessionStart (auto-summary hook):
- Process ALL unsummarized days, not just yesterday
- Keep output brief — show a compact summary of what was generated
- Publish automatically if configured (don't ask for confirmation)
- Then let the user continue with their actual work

## Important Notes
- Keep bullets concise — one line each, action-oriented
- Group related prompts into a single bullet (don't list every prompt separately)
- If a session has only 1-2 trivial prompts, summarize in one bullet
- Skip empty days (no logs = no summary)
- Always save locally first, then publish to configured destination
