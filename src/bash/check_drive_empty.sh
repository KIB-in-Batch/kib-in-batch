#!/bin/bash

# RUNS IN GIT BASH

# Get the drive name from the command line argument
drive_name="$1"
winpath_to_unix() {
    local input="$1"
    local converted
    converted=$(echo "$input" | sed -E 's|^([A-Za-z]):|/\L\1|g' | tr '\\' '/')
    printf "%s" "$converted"
}
# Convert the drive name to a Unix path
drive_name=$(winpath_to_unix "$drive_name")
# Check if the drive is empty
echo "Testing if drive is empty..."
if [ -z "$(ls -A $drive_name)" ]; then
    echo "Drive is empty."
    exit 0
else
    # Check if the things the drive contain are only 'System Volume Information' and '$RECYCLE.BIN'
    if [ "$(ls -A $drive_name | wc -l)" -eq 2 ] && [ "$(ls -A $drive_name | grep -E 'System Volume Information|$RECYCLE.BIN')" ]; then
        echo "Drive contains only 'System Volume Information' and '$RECYCLE.BIN'."
        echo "Drive is empty."
        exit 0
    fi
    echo "drive contains:"
    ls -A $drive_name
    exit 1
fi