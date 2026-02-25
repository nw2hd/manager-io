#!/bin/bash

echo "--- Manager.io Internal Management Tool ---"
echo "1) Update ManagerServer to Latest"
echo "2) Backup Data to /data/backups"
echo "3) Exit"
read -p "Choose an option: " opt

case $opt in
    1)
        echo "Fetching latest version..."
        wget https://github.com/Manager-io/Manager/releases/latest/download/ManagerServer-linux-x64.tar.gz
        # Kill the running server so we can replace files
        pkill ManagerServer
        tar -xzf ManagerServer-linux-x64.tar.gz
        rm ManagerServer-linux-x64.tar.gz
        echo "Update applied. Please restart the container."
        ;;
    2)
        mkdir -p /data/backups
        tar -czf /data/backups/backup_$(date +%F).tar.gz /data
        echo "Backup created in /data/backups"
        ;;
    *)
        exit 0
        ;;
esac
