---
name: daily-log-summary
description: Generate daily activity summaries from Claude Code logs and optionally send to Slack. Use when the user asks for a daily summary, work log, what they did today/yesterday, or activity report.
---

# Daily Summary Generator

## Overview
Generates concise bullet-point summaries of daily Claude Code activity from JSONL hook logs, with optional Slack publishing.

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
- "catch up" or "all" → find all date directories in `~/.claude/logs/daily/` that don't have a corresponding file in `~/.claude/logs/summaries/`
- "today" → today's date
- "yesterday" → yesterday's date

### Step 2: Read the raw logs
- Read all `*.jsonl` files in `~/.claude/logs/daily/YYYY-MM-DD/`
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

### Step 5: Offer to send to Slack
- Check if Slack is configured by reading `~/.claude/daily-log.json`
- If configured, ask: "Send summary to #channel-name?"
- Only send after user confirms
- Use Slack MCP tools to post to the configured channel ID
- If NOT configured, tell the user: "Slack isn't set up yet. Run `/daily-log:setup` to configure it."

## Plugin Config File

`~/.claude/daily-log.json`:
```json
{
  "slack": {
    "enabled": true,
    "channelId": "YOUR_CHANNEL_ID",
    "channelName": "#your-channel"
  }
}
```

If this file doesn't exist, everything works without Slack — summaries are still generated and saved locally.

## Important Notes
- Keep bullets concise — one line each, action-oriented
- Group related prompts into a single bullet (don't list every prompt separately)
- If a session has only 1-2 trivial prompts, summarize in one bullet
- Skip empty days (no logs = no summary)
- Slack is optional — the skill works fully without it
