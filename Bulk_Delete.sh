#!/bin/bash
# This Bash script is used to delete a a given list of directories in linux 

# Takes file with list of paths/directory names as input to delete 
if [ $# -eq 0 ]; then
    echo "Usage: $0 <file_with_directory_names>"
    exit 1
fi

file_path=$1

# Check if the file exists
if [ ! -f "$file_path" ]; then
    echo "Error: File not found - $file_path"
    exit 1
fi

while IFS= read -r dir_name; do
    if [ -d "$dir_name" ]; then
        echo "Deleting directory: $dir_name"
        rm -rf "$dir_name"
    else
        echo "Directory not found: $dir_name"
    fi
done < "$file_path"

echo "Deletion complete."
