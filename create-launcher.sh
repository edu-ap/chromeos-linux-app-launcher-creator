#!/bin/bash

# ChromeOS Linux App Launcher Creator
# Creates desktop entries for Linux applications on Chrome OS
# https://github.com/edu-ap/chromeos-linux-app-launcher-creator

# Define colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Default values
APP_NAME=""
APP_COMMENT=""
APP_CATEGORY="Utility"
ICON_URL=""
FORCE_UPDATE=false
SCALE="0.8"
DPI="160"

# Function to display help
show_help() {
    echo -e "${BLUE}ChromeOS Linux App Launcher Creator${NC}"
    echo ""
    echo "Usage: ./create-launcher.sh [options] --app-name=\"App Name\" --app-path=\"/path/to/app.AppImage\""
    echo ""
    echo "Options:"
    echo "  --app-name=\"App Name\"       Name of the application (required)"
    echo "  --app-path=\"/path/to/app\"   Path to the application executable (required)"
    echo "  --comment=\"Description\"     Application description"
    echo "  --category=\"Category\"       Application category (default: Utility)"
    echo "  --icon-url=\"URL\"            URL to download icon from"
    echo "  --icon-path=\"/path/to/icon\" Path to icon file"
    echo "  --scale=\"0.8\"               Scaling factor for the application"
    echo "  --dpi=\"160\"                 DPI setting for the application"
    echo "  --force-update               Force update if launcher already exists"
    echo "  --help                       Show this help message"
    echo ""
    echo "Example:"
    echo "  ./create-launcher.sh --app-name=\"Obsidian\" --app-path=\"/path/to/Obsidian.AppImage\" --category=\"Office;Notes\" --icon-url=\"https://obsidian.md/images/obsidian-logo.png\""
    exit 0
}

# Parse command line arguments
parse_args() {
    for arg in "$@"; do
        case $arg in
            --app-name=*)
                APP_NAME="${arg#*=}"
                ;;
            --app-path=*)
                APP_PATH="${arg#*=}"
                ;;
            --comment=*)
                APP_COMMENT="${arg#*=}"
                ;;
            --category=*)
                APP_CATEGORY="${arg#*=}"
                ;;
            --icon-url=*)
                ICON_URL="${arg#*=}"
                ;;
            --icon-path=*)
                ICON_PATH="${arg#*=}"
                ;;
            --scale=*)
                SCALE="${arg#*=}"
                ;;
            --dpi=*)
                DPI="${arg#*=}"
                ;;
            --force-update)
                FORCE_UPDATE=true
                ;;
            --help)
                show_help
                ;;
        esac
    done
}

# Validate required arguments
validate_args() {
    if [ -z "$APP_NAME" ]; then
        echo -e "${RED}Error: App name is required${NC}"
        show_help
    fi
    
    if [ -z "$APP_PATH" ]; then
        echo -e "${RED}Error: App path is required${NC}"
        show_help
    fi
    
    if [ ! -f "$APP_PATH" ] && [[ ! "$APP_PATH" == /mnt/chromeos/* ]]; then
        echo -e "${YELLOW}Warning: Application file not found at $APP_PATH${NC}"
        echo "Will proceed anyway as the path might be correct in Chrome OS but not visible in Linux"
    fi
    
    if [ -z "$APP_COMMENT" ]; then
        APP_COMMENT="$APP_NAME application"
    fi
}

# Find Chrome OS paths
find_downloads_path() {
    echo -e "${BLUE}Finding suitable Chrome OS paths...${NC}"
    
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
      echo -e "${YELLOW}Warning: Could not find Downloads folder automatically${NC}"
      echo "Using $HOME/Downloads as fallback"
      DOWNLOADS_PATH="$HOME/Downloads"
    fi
}

# Handle icon
handle_icon() {
    echo -e "${BLUE}Setting up application icon...${NC}"
    
    # First, see if we already have an icon path specified
    if [ -n "$ICON_PATH" ] && [ -f "$ICON_PATH" ]; then
        echo "Using specified icon: $ICON_PATH"
        return
    fi
    
    # Convert app name to lowercase for filename
    SAFE_APP_NAME=$(echo "$APP_NAME" | tr '[:upper:]' '[:lower:]' | tr ' ' '-')
    
    # Try to find an icon in the app's directory or resources
    if [[ "$APP_PATH" == *AppImage ]]; then
        echo "Trying to extract icon from AppImage..."
        
        # Try to extract icon from AppImage
        "$APP_PATH" --appimage-extract appicon.png &>/dev/null
        if [ -f "squashfs-root/appicon.png" ]; then
            # Copy to Downloads folder
            ICON_PATH="$DOWNLOADS_PATH/$SAFE_APP_NAME.png"
            cp squashfs-root/appicon.png "$ICON_PATH"
            echo "Successfully extracted icon from AppImage to $ICON_PATH"
            rm -rf squashfs-root
            return
        fi
        
        # Clean up
        rm -rf squashfs-root 2>/dev/null
    fi
    
    # If we have a URL, download the icon
    if [ -n "$ICON_URL" ]; then
        echo "Downloading icon from $ICON_URL..."
        ICON_PATH="$DOWNLOADS_PATH/$SAFE_APP_NAME.png"
        curl -L -o "$ICON_PATH" "$ICON_URL"
        
        if [ -f "$ICON_PATH" ]; then
            echo "Icon downloaded to $ICON_PATH"
            return
        else
            echo -e "${YELLOW}Warning: Failed to download icon${NC}"
        fi
    fi
    
    # If we still don't have an icon, use a system icon
    echo -e "${YELLOW}Using system icon as fallback${NC}"
    for ICON_PATH in \
        "/usr/share/icons/hicolor/48x48/apps/text-editor.png" \
        "/usr/share/icons/gnome/48x48/apps/text-editor.png" \
        "/usr/share/icons/hicolor/48x48/apps/accessories-text-editor.png"; do
        if [ -f "$ICON_PATH" ]; then
            echo "Using system icon: $ICON_PATH"
            return
        fi
    done
    
    # Last resort
    ICON_PATH="/usr/share/icons/hicolor/48x48/apps/text-editor.png"
}

# Create desktop entry
create_desktop_entry() {
    echo -e "${BLUE}Creating application launcher...${NC}"
    
    # Create applications directory if it doesn't exist
    mkdir -p "$HOME/.local/share/applications"
    
    # Generate a safe filename
    SAFE_APP_NAME=$(echo "$APP_NAME" | tr '[:upper:]' '[:lower:]' | tr ' ' '-')
    DESKTOP_FILE="$HOME/.local/share/applications/$SAFE_APP_NAME-launcher.desktop"
    
    # Check if the launcher already exists
    if [ -f "$DESKTOP_FILE" ] && [ "$FORCE_UPDATE" = false ]; then
        echo -e "${YELLOW}Launcher already exists. Use --force-update to overwrite.${NC}"
        return
    fi
    
    # Create the desktop file
    cat > "$DESKTOP_FILE" << EOF
[Desktop Entry]
Name=$APP_NAME
Comment=$APP_COMMENT
Exec=/usr/bin/sommelier -X --scale=$SCALE --dpi=$DPI "$APP_PATH"
Icon=$ICON_PATH
Type=Application
Categories=$APP_CATEGORY;
StartupNotify=true
StartupWMClass=$(echo "$APP_NAME" | tr '[:upper:]' '[:lower:]')
Terminal=false
EOF
    
    # Make it executable
    chmod +x "$DESKTOP_FILE"
    
    # Update desktop database
    update-desktop-database "$HOME/.local/share/applications" 2>/dev/null || true
    
    echo -e "${GREEN}Launcher created at $DESKTOP_FILE${NC}"
}

# Main function
main() {
    echo -e "${BLUE}=== ChromeOS Linux App Launcher Creator ===${NC}"
    
    # Parse command line arguments
    parse_args "$@"
    
    # Validate arguments
    validate_args
    
    # Find Downloads folder
    find_downloads_path
    
    # Handle icon
    handle_icon
    
    # Create desktop entry
    create_desktop_entry
    
    echo -e "${GREEN}Setup complete!${NC}"
    echo "You should now see $APP_NAME in your Chrome OS app list."
    echo "If it doesn't appear, try logging out and back in."
    echo "To launch manually, you can use the command:"
    echo "  /usr/bin/sommelier -X --scale=$SCALE --dpi=$DPI \"$APP_PATH\""
}

# Run the main function
main "$@" 