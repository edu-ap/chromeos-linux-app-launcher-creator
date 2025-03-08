# ChromeOS Linux App Launcher Creator

A collection of scripts to create application launchers for Linux applications on Chrome OS. This tool helps you integrate Linux applications into the Chrome OS app launcher, making them easier to access.

## Features

- Automatically creates desktop entries for Linux applications
- Handles icon extraction and downloading
- Properly configures applications to work with Chrome OS
- Includes specialized scripts for popular applications
- Resolves path issues between Chrome OS and Linux VM

## Installation

1. Clone this repository:
   ```bash
   git clone https://github.com/edu-ap/chromeos-linux-app-launcher-creator.git
   cd chromeos-linux-app-launcher-creator
   ```

2. Make the scripts executable:
   ```bash
   chmod +x *.sh
   ```

## Usage

### Quick Start with Pre-configured Apps

For popular applications, use the specialized scripts:

```bash
# For Cursor IDE
./cursor-launcher.sh

# For Obsidian
./obsidian-launcher.sh
```

### Creating Custom Launchers

For any other application, use the generic launcher creator:

```bash
./create-launcher.sh --app-name="Application Name" --app-path="/path/to/application"
```

### Advanced Options

The launcher creator supports several options:

```
Usage: ./create-launcher.sh [options] --app-name="App Name" --app-path="/path/to/app.AppImage"

Options:
  --app-name="App Name"       Name of the application (required)
  --app-path="/path/to/app"   Path to the application executable (required)
  --comment="Description"     Application description
  --category="Category"       Application category (default: Utility)
  --icon-url="URL"            URL to download icon from
  --icon-path="/path/to/icon" Path to icon file
  --scale="0.8"               Scaling factor for the application
  --dpi="160"                 DPI setting for the application
  --force-update              Force update if launcher already exists
  --help                      Show this help message
```

## How It Works

Chrome OS runs Linux applications in a container (Crostini). This tool:

1. Creates `.desktop` files that Chrome OS recognizes
2. Configures the application to use `sommelier` for proper display
3. Places icons in locations accessible to both Chrome OS and Linux
4. Handles path translation between Chrome OS and Linux

## Common Issues and Solutions

### Icon Not Displaying

If the application icon doesn't appear in Chrome OS:
- The icon must be in a location accessible to Chrome OS (typically the Downloads folder)
- Try using the `--icon-url` option to download a fresh icon
- Log out and back in to refresh the Chrome OS icon cache

### Application Not Found

If Chrome OS can't find the application:
- Make sure the path is correct and the file is executable
- For AppImages, use the `--appimage-extract` option to verify contents
- Check that the path is accessible from both Chrome OS and Linux

### Path Translation

ChromeOS and Linux see files in different locations:
- ChromeOS: `/home/user/Downloads/app.AppImage` or `/home/user/MyFiles/Downloads/app.AppImage`
- Linux VM: `/mnt/chromeos/MyFiles/Downloads/app.AppImage`

This tool automatically handles this translation.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- The Chrome OS team for creating Crostini
- The Linux community for AppImage and desktop entry standards 