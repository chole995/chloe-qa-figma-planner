#!/bin/bash

# UI Batch Validation Script
# Usage: ./batch_validate.sh <config.json>

set -e

CONFIG_FILE="${1:-}"

if [ -z "$CONFIG_FILE" ]; then
  echo "Usage: $0 <config.json>"
  echo ""
  echo "Example:"
  echo "  $0 ./config/my-project.json"
  exit 1
fi

if [ ! -f "$CONFIG_FILE" ]; then
  echo "Error: Config file not found: $CONFIG_FILE"
  exit 1
fi

echo "═══════════════════════════════════════════════════════"
echo "  UI Batch Validation"
echo "═══════════════════════════════════════════════════════"
echo ""
echo "Config: $CONFIG_FILE"
echo ""

# Parse config
NAME=$(jq -r '.name' "$CONFIG_FILE")
URL=$(jq -r '.url' "$CONFIG_FILE")
PORT=$(jq -r '.chrome_debug_port // 9222' "$CONFIG_FILE")
OUTPUT_DIR=$(jq -r '.output_dir // "./reports"' "$CONFIG_FILE")
SCREENSHOT_DIR=$(jq -r '.screenshot_dir // "./reports/screenshots"' "$CONFIG_FILE")
ELEMENT_COUNT=$(jq '.elements | length' "$CONFIG_FILE")

echo "Name: $NAME"
echo "URL: $URL"
echo "Chrome Debug Port: $PORT"
echo "Output Dir: $OUTPUT_DIR"
echo "Elements to validate: $ELEMENT_COUNT"
echo ""

# Check Chrome debug port
echo "Checking Chrome debug port..."
if curl -s "http://localhost:$PORT/json" > /dev/null 2>&1; then
  echo "✓ Chrome debug port $PORT is accessible"
else
  echo "✗ Chrome debug port $PORT is not accessible"
  echo ""
  echo "Please start Chrome with remote debugging:"
  echo "  /Applications/Google\\ Chrome.app/Contents/MacOS/Google\\ Chrome --remote-debugging-port=$PORT"
  exit 1
fi

# Create output directories
mkdir -p "$OUTPUT_DIR"
mkdir -p "$SCREENSHOT_DIR"

echo ""
echo "───────────────────────────────────────────────────────"
echo "Ready for validation. Use Claude Code to execute:"
echo ""
echo "  验收配置文件: $CONFIG_FILE"
echo ""
echo "Claude will:"
echo "  1. Connect to Chrome at localhost:$PORT"
echo "  2. Navigate to $URL"
echo "  3. Validate $ELEMENT_COUNT elements"
echo "  4. Generate report in $OUTPUT_DIR"
echo "───────────────────────────────────────────────────────"
