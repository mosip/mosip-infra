#!/bin/bash

# Prompt for existing Old configuration repo URL and branch
read -p "Enter existing old configuration repo URL: " old_repo_url
read -p "Enter existing old configuration repo branch: " old_repo_branch

# Prompt for New based configurations URL and branch
read -p "Enter new based configurations URL: " latest_repo_url
read -p "Enter new based configuration branch: " latest_repo_branch

# Run the file_comparator Python script with the prompt values as arguments
python3 file_comparator.py "$old_repo_url" "$old_repo_branch" "$latest_repo_url" "$latest_repo_branch"

# Check the exit code of the first script
exit_code=$?
if [ $exit_code -ne 0 ]; then
    echo "Error: First script failed with exit code $exit_code"
    exit $exit_code
fi

# Run the file_updater Python script
python3 file_updater.py "$latest_repo_branch"

# Check the exit code of the second script
exit_code=$?
if [ $exit_code -ne 0 ]; then
    echo "Error: Second script failed with exit code $exit_code"
    exit $exit_code
fi

echo "Both Python scripts have been successfully executed."
