#!/bin/bash

# Detect if running in a GitHub Codespace
if [ "$CODESPACES" = "true" ]; then
  bash codespace.sh
fi
