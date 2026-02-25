#!/bin/bash

REPO="Manager-io/Manager"
WORKDIR="/app"
DATA_DIR="/data"

echo "=========================================="
echo "   Manager.io Version Manager (nw2hd)"
echo "=========================================="

# 1. SAFETY CHECK: Backup Prompt
read -p "Have you backed up your data folder? (y/n): " confirm_backup
if [[ $confirm_backup != "y" ]]; then
    echo "Action cancelled. Please backup /data/ before upgrading."
    exit 1
fi

# 2. Fetch versions from GitHub
echo "Fetching available versions from GitHub..."
RELEASES=$(curl -s "https://api.github.com/repos/$REPO/releases?per_page=10")
TAGS=$(echo "$RELEASES" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')

# 3. Version Selection
echo "Select the version you want to deploy:"
PS3="Selection (or 'q' to quit): "

select SELECTED_VERSION in $TAGS; do
    if [[ "$REPLY" == "q" ]]; then
        exit 0
    elif [ -n "$SELECTED_VERSION" ]; then
        break
    else
        echo "Invalid choice."
    fi
done

# 4. Deployment
echo "------------------------------------------"
echo "Downloading Version: $SELECTED_VERSION"
DOWNLOAD_URL="https://github.com/$REPO/releases/download/$SELECTED_VERSION/ManagerServer-linux-x64.tar.gz"

mkdir -p /tmp/manager_upd
wget -q --show-progress -O /tmp/manager_upd/pkg.tar.gz "$DOWNLOAD_URL"

if [ $? -eq 0 ]; then
    echo "Installing..."
    # Kill process to release file locks
    pkill ManagerServer || true
    
    tar -xzf /tmp/manager_upd/pkg.tar.gz -C "$WORKDIR"
    rm -rf /tmp/manager_upd
    
    echo "------------------------------------------"
    echo "Update Applied: $SELECTED_VERSION"
    echo "Please restart your container via aaPanel or Portainer."
    echo "------------------------------------------"
else
    echo "Download failed. Keeping current version."
    exit 1
fi
