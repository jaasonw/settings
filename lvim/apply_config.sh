#!/bin/bash

# Paths for the source and target files
SOURCE="config.lua"
TARGET="$HOME/.config/lvim/config.lua"

# Check if the target file exists and is newer than the source file
if [ -f "$TARGET" ] && [ "$TARGET" -nt "$SOURCE" ]; then
    # Prompt for confirmation
    read -p "The target file is newer than the source. Do you really want to overwrite it? (y/n) " CONFIRMATION
    
    if [[ "$CONFIRMATION" != "y" ]]; then
        echo "Operation cancelled."
        exit 0
    fi
fi

# Copy the file
cp "$SOURCE" "$TARGET"
echo "File copied successfully."
