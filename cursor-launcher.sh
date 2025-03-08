#!/bin/bash

# Cursor IDE Launcher Setup for Chrome OS
# This script uses create-launcher.sh to set up a Cursor IDE launcher

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

echo -e "${BLUE}Setting up Cursor IDE launcher for Chrome OS...${NC}"

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

# Find Cursor AppImage in Downloads folder
echo "Searching for Cursor AppImage in $DOWNLOADS_PATH..."
CURSOR_APPIMAGE=$(find "$DOWNLOADS_PATH" -name "*cursor*.AppImage" -type f -o -name "*Cursor*.AppImage" -type f 2>/dev/null | head -n 1)

if [ -z "$CURSOR_APPIMAGE" ]; then
    echo -e "${YELLOW}Warning: Could not find any Cursor AppImage in $DOWNLOADS_PATH${NC}"
    echo "Please enter the full path to your Cursor AppImage:"
    read CURSOR_APPIMAGE
    
    if [ ! -f "$CURSOR_APPIMAGE" ]; then
      echo -e "${RED}Error: File not found. Exiting.${NC}"
      exit 1
    fi
else
    echo "Found Cursor AppImage: $CURSOR_APPIMAGE"
    chmod +x "$CURSOR_APPIMAGE"
fi

# Set up parameters for the launcher
SCRIPT_DIR="$(dirname "$0")"
APP_NAME="Cursor IDE"
APP_COMMENT="Modern IDE powered by AI"
APP_CATEGORY="Development;IDE;"
ICON_URL="https://raw.githubusercontent.com/getcursor/cursor/main/packages/cursor-app/src/app/icons/512x512.png"

# Run the launcher creator script
"$SCRIPT_DIR/create-launcher.sh" \
  --app-name="$APP_NAME" \
  --app-path="$CURSOR_APPIMAGE" \
  --comment="$APP_COMMENT" \
  --category="$APP_CATEGORY" \
  --icon-url="$ICON_URL" \
  --force-update 