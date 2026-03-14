#!/bin/bash
# Auto-summary check on SessionStart
# Finds all days with logs but no summary, and injects context telling Claude to generate them
# Respects autoSummary setting in ~/.claude/daily-log.json (defaults to enabled)

CONFIG="$HOME/.claude/daily-log.json"
LOG_BASE="$HOME/.claude/logs/daily"
SUMMARY_DIR="$HOME/.claude/logs/summaries"
TODAY=$(date +%Y-%m-%d)

# Check if auto-summary is enabled (default: true)
if [[ -f "$CONFIG" ]]; then
    ENABLED=$(python3 -c "import json; c=json.load(open('$CONFIG')); print(c.get('autoSummary', True))" 2>/dev/null)
    if [[ "$ENABLED" == "False" ]]; then
        exit 0
    fi
fi

# No logs directory yet = nothing to summarize
if [[ ! -d "$LOG_BASE" ]]; then
    exit 0
fi

# Find all date directories with logs but no corresponding summary
# Exclude today (still in progress)
UNSUMMARIZED=""
for date_dir in "$LOG_BASE"/*/; do
    DATE=$(basename "$date_dir")
    # Skip today
    [[ "$DATE" == "$TODAY" ]] && continue
    # Skip if not a valid date directory
    [[ ! "$DATE" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]] && continue
    # Skip if summary already exists
    [[ -f "$SUMMARY_DIR/$DATE.md" ]] && continue
    # Skip if directory is empty
    [[ -z "$(ls "$date_dir"*.jsonl 2>/dev/null)" ]] && continue
    UNSUMMARIZED="$UNSUMMARIZED $DATE"
done

# Nothing to summarize
if [[ -z "$UNSUMMARIZED" ]]; then
    exit 0
fi

# Trim leading space and count
UNSUMMARIZED="${UNSUMMARIZED# }"
COUNT=$(echo "$UNSUMMARIZED" | wc -w | tr -d ' ')

# Inject context into the session
cat << EOF
[daily-log] Found $COUNT unsummarized day(s): $UNSUMMARIZED

You MUST now invoke the /daily-log:daily-log-summary skill to generate summaries for these days. Pass "catch up" as the mode — it will find all unsummarized days automatically. Do this before addressing the user's first prompt. Keep it brief — show the summaries, save them, and offer to publish.
EOF

exit 0
