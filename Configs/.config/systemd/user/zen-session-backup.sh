#!/usr/bin/env bash
set -e  # exit on any error

# Path to Zen profile
BASE="$HOME/.zen/main.profile"

# Primary sessionstore file
SRC="$BASE/sessionstore.jsonlz4"

# Fallback to recovery if primary does not exist
[ -f "$SRC" ] || SRC="$BASE/sessionstore-backups/recovery.jsonlz4"

# Exit if no session file exists
[ -f "$SRC" ] || exit 0

# Destination folder for backups
DST="$HOME/.auto-backups/zen-sessions"

# Timestamp for backup filename
TS="$(date '+%Y %b %d %H:%M:%S')"

# Create destination folder if it doesn't exist
mkdir -p "$DST"

# Copy session file preserving mode and timestamps
cp --preserve=mode,timestamps "$SRC" "$DST/sessionstore - $TS.jsonlz4"

