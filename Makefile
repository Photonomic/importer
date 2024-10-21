# Makefile for Photo Importer CLI application

# Variables
APP_NAME = pimporter
SRC_DIR = .
BUILD_DIR = bin
PLIST_FILE = com.Photonomic.photoimporter.plist
INSTALL_DIR = ~/Library/LaunchAgents
WATCH_DIR = /Users/matt/Pictures/Leica/Exports  # <<<<<<  Change this to your desired directory >>>>>>>
ALBUM_NAME = "InstagramMe"   # <<<<< CHANGE THIS TO YOUR ALBUM NAME >>>>>>>>

# Targets
.PHONY: all build install create-service clean

# Default target
all: build

# Build the application
build:
	@echo "Building the application..."
	go build -o $(BUILD_DIR)/$(APP_NAME) $(SRC_DIR)

# Install the application
install: build
	@echo "Installing the application..."
	@mkdir -p $(INSTALL_DIR)
	cp $(BUILD_DIR)/$(APP_NAME) $(INSTALL_DIR)

# Create the launchctl service file
create-service:
	@echo "Creating launchctl service file..."
	echo '<?xml version="1.0" encoding="UTF-8"?>' > ~/Library/LaunchAgents/$(PLIST_FILE)
	echo '<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">' >> ~/Library/LaunchAgents/$(PLIST_FILE)
	echo '<plist version="1.0">' >> ~/Library/LaunchAgents/$(PLIST_FILE)
	echo '<dict>' >> ~/Library/LaunchAgents/$(PLIST_FILE)
	echo '    <key>Label</key>' >> ~/Library/LaunchAgents/$(PLIST_FILE)
	echo '    <string>com.Photonomic.photoimporter</string>' >> ~/Library/LaunchAgents/$(PLIST_FILE)
	echo '    <key>ProgramArguments</key>' >> ~/Library/LaunchAgents/$(PLIST_FILE)
	echo '    <array>' >> ~/Library/LaunchAgents/$(PLIST_FILE)
	echo '        <string>$(INSTALL_DIR)/$(APP_NAME)</string>' >> ~/Library/LaunchAgents/$(PLIST_FILE)
	echo '        <string>--watch</string>' >> ~/Library/LaunchAgents/$(PLIST_FILE)
	echo '        <string>$(WATCH_DIR)</string>' >> ~/Library/LaunchAgents/$(PLIST_FILE)
	echo '        <string>--album</string>' >> ~/Library/LaunchAgents/$(PLIST_FILE)
	echo '        <string>$(ALBUM_NAME)</string>' >> ~/Library/LaunchAgents/$(PLIST_FILE)
	echo '    </array>' >> ~/Library/LaunchAgents/$(PLIST_FILE)
	echo '    <key>RunAtLoad</key>' >> ~/Library/LaunchAgents/$(PLIST_FILE)
	echo '    <true/>' >> ~/Library/LaunchAgents/$(PLIST_FILE)
	echo '    <key>KeepAlive</key>' >> ~/Library/LaunchAgents/$(PLIST_FILE)
	echo '    <true/>' >> ~/Library/LaunchAgents/$(PLIST_FILE)
	echo '</dict>' >> ~/Library/LaunchAgents/$(PLIST_FILE)
	echo '</plist>' >> ~/Library/LaunchAgents/$(PLIST_FILE)

# Clean build artifacts
clean:
	@echo "Cleaning up..."
	rm -rf $(BUILD_DIR)/$(APP_NAME) ~/Library/LaunchAgents/$(PLIST_FILE)

