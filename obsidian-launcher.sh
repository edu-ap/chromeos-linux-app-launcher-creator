#!/bin/bash

# Obsidian Launcher Setup for Chrome OS
# This script uses create-launcher.sh to set up an Obsidian launcher

# Check if create-launcher.sh exists
if [ ! -f "$(dirname "$0")/create-launcher.sh" ]; then
    echo "Error: create-launcher.sh not found in the same directory."
    echo "Please make sure create-launcher.sh is in the same directory as this script."
    exit 1
fi

# Define colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}Setting up Obsidian launcher for Chrome OS...${NC}"

# Find the Downloads folder location (common paths in Chrome OS Linux)
POSSIBLE_PATHS=(
  "$HOME/Downloads"
  "/mnt/chromeos/MyFiles/Downloads"
  "/mnt/chromeos/removable/Downloads"
  "/home/chronos/user/Downloads"
  "/media/removable/Downloads"
  "/mnt/chromeos"
)

DOWNLOADS_PATH=""
for path in "${POSSIBLE_PATHS[@]}"; do
  if [ -d "$path" ]; then
    echo "Found Downloads folder at: $path"
    DOWNLOADS_PATH="$path"
    break
  fi
done

if [ -z "$DOWNLOADS_PATH" ]; then
  echo -e "${RED}Error: Could not find Downloads folder${NC}"
  echo "Please enter the full path to your Downloads folder:"
  read DOWNLOADS_PATH
  
  if [ ! -d "$DOWNLOADS_PATH" ]; then
    echo -e "${RED}Error: Invalid path. Exiting.${NC}"
    exit 1
  fi
fi

# Find Obsidian AppImage in Downloads folder
echo "Searching for Obsidian AppImage in $DOWNLOADS_PATH..."
OBSIDIAN_APPIMAGE=$(find "$DOWNLOADS_PATH" -name "*obsidian*.AppImage" -type f -o -name "*Obsidian*.AppImage" -type f 2>/dev/null | head -n 1)

if [ -z "$OBSIDIAN_APPIMAGE" ]; then
    echo -e "${YELLOW}Warning: Could not find any Obsidian AppImage in $DOWNLOADS_PATH${NC}"
    echo "Please enter the full path to your Obsidian AppImage:"
    read OBSIDIAN_APPIMAGE
    
    if [ ! -f "$OBSIDIAN_APPIMAGE" ]; then
      echo -e "${RED}Error: File not found. Exiting.${NC}"
      exit 1
    fi
else
    echo "Found Obsidian AppImage: $OBSIDIAN_APPIMAGE"
    chmod +x "$OBSIDIAN_APPIMAGE"
fi

# Set up parameters for the launcher
SCRIPT_DIR="$(dirname "$0")"
APP_NAME="Obsidian"
APP_COMMENT="Knowledge base that works on local Markdown files"
APP_CATEGORY="Office;Notes;"
ICON_URL="https://obsidian.md/images/obsidian-logo.png"

# Run the launcher creator script
"$SCRIPT_DIR/create-launcher.sh" \
  --app-name="$APP_NAME" \
  --app-path="$OBSIDIAN_APPIMAGE" \
  --comment="$APP_COMMENT" \
  --category="$APP_CATEGORY" \
  --icon-url="$ICON_URL" \
  --force-update 