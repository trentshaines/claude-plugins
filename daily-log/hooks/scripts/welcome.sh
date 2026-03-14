#!/bin/bash
# First-run welcome message for daily-log plugin
# Shows once, then creates a marker file to suppress future runs

MARKER="$HOME/.claude/.daily-log-welcomed"

if [[ -f "$MARKER" ]]; then
    exit 0
fi

mkdir -p "$(dirname "$MARKER")"
touch "$MARKER"

# Output context that gets injected into the session
cat << 'EOF'
[daily-log plugin] Session logging is active. Your prompts and session events are being recorded to ~/.claude/logs/daily/.

Available skills:
  /daily-log:status          — check logging status and stats
  /daily-log:daily-log-summary — generate a summary of your work
  /daily-log:setup           — configure where to publish summaries (Slack, Discord, webhook)

Run /daily-log:setup to get started, or just use Claude — everything is logged automatically.
EOF

exit 0
