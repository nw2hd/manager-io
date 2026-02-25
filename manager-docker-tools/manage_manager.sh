#!/bin/bash

REPO="Manager-io/Manager"
WORKDIR="/app"

echo "=========================================="
echo "   Manager.io Version Manager (nw2hd)"
echo "=========================================="

# 1. Safety Check
read -p "Have you backed up your data? (y/n): " confirm_backup
if [[ $confirm_backup != "y" ]]; then
    echo "Aborting. Please backup /data/ before upgrading."
    exit 1
fi

# 2. Get Versions
echo "Checking GitHub for available versions..."
RELEASES=$(curl -s "https://api.github.com/repos/$REPO/releases?per_page=10")
TAGS=$(echo "$RELEASES" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')

# 3. User Selection
PS3="Choose a version number: "
select SELECTED_VERSION in $TAGS "Exit"; do
    if [[ "$SELECTED_VERSION" == "Exit" ]]; then exit 0; fi
    if [ -n "$SELECTED_VERSION" ]; then break; fi
done

# 4. Download and Swap
echo "Downloading $SELECTED_VERSION..."
URL="https://github.com/$REPO/releases/download/$SELECTED_VERSION/ManagerServer-linux-x64.tar.gz"

wget -q --show-progress -O /tmp/manager.tar.gz "$URL"

if [ $? -eq 0 ]; then
    echo "Applying update..."
    # Force stop the current server process
    pkill -9 ManagerServer || true
    
    # Extract new files
    tar -xzf /tmp/manager.tar.gz -C "$WORKDIR"
    rm /tmp/manager.tar.gz
    
    echo "Update complete! Version $SELECTED_VERSION is installed."
    echo "The container will now exit. Please restart it to apply changes."
    
    # Exit the container process to force a restart
    kill 1
else
    echo "Download failed!"
    exit 1
fi
