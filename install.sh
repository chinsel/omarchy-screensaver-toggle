#!/usr/bin/env bash
# Install / link Omarchy Screensaver Toggle Plugin

set -euo pipefail

TARGET_DIR="$HOME/.config/omarchy/plugins/screensaver.toggle"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Installing screensaver.toggle plugin into $TARGET_DIR..."
mkdir -p "$TARGET_DIR"

cp -f "$SCRIPT_DIR/manifest.json" "$TARGET_DIR/"
cp -f "$SCRIPT_DIR/BarWidget.qml" "$TARGET_DIR/"

echo "Validating plugin..."
if command -v omarchy >/dev/null 2>&1; then
  omarchy plugin validate "$TARGET_DIR"
  echo "Rescanning Omarchy shell plugins..."
  omarchy-shell shell rescanPlugins 2>/dev/null || true
  echo "Enabling plugin on bar..."
  omarchy plugin enable screensaver.toggle --section right 2>/dev/null || true
  omarchy bar move screensaver.toggle --before omarchy.power 2>/dev/null || true
fi

echo "Successfully installed Omarchy Screensaver Toggle!"
