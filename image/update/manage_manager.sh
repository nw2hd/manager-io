#!/bin/bash

# Configuration
REPO="Manager-io/Manager"
WORKDIR="/app"

echo "=========================================="
echo "   Manager.io Version Selector Tool"
echo "=========================================="

# 1. Fetch the last 10 releases from GitHub
echo "Fetching available versions..."
RELEASES=$(curl -s "https://api.github.com/repos/$REPO/releases?per_page=10")

# 2. Extract tag names into a list
TAGS=$(echo "$RELEASES" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')

if [ -z "$TAGS" ]; then
    echo "Error: Could not fetch versions. Check internet/API limits."
    exit 1
fi

# 3. Present the list to the user
echo "Please select the version you wish to install:"
PS3="Enter number (or 'q' to quit): "

select SELECTED_VERSION in $TAGS; do
    if [[ "$REPLY" == "q" ]]; then
        echo "Exiting..."
        exit 0
    elif [ -n "$SELECTED_VERSION" ]; then
        echo "------------------------------------------"
        echo "You selected version: $SELECTED_VERSION"
        break
    else
        echo "Invalid selection. Please try again."
    fi
done

# 4. Perform the upgrade
echo "Downloading ManagerServer for version $SELECTED_VERSION..."

# Construct the download URL based on the version tag
# Note: Newer versions use /download/tag/filename, older ones might vary
DOWNLOAD_URL="https://github.com/$REPO/releases/download/$SELECTED_VERSION/ManagerServer-linux-x64.tar.gz"

# Create a temporary directory for the download
mkdir -p /tmp/manager_update
wget -q --show-progress -O /tmp/manager_update/manager.tar.gz "$DOWNLOAD_URL"

if [ $? -eq 0 ]; then
    echo "Download successful. Applying update..."
    
    # Stop the running process if it exists
    pkill ManagerServer || true
    
    # Extract to the application directory
    tar -xzf /tmp/manager_update/manager.tar.gz -C "$WORKDIR"
    
    # Clean up
    rm -rf /tmp/manager_update
    
    echo "=========================================="
    echo " SUCCESS: Version $SELECTED_VERSION installed."
    echo " Please restart the container to apply."
    echo "=========================================="
else
    echo "Error: Failed to download version $SELECTED_VERSION."
    exit 1
fi
