#!/bin/bash

# Run the file_comparator Python script
python3 file_comparator.py

# Check the exit code of the first script
exit_code=$?
if [ $exit_code -ne 0 ]; then
    echo "Error: First script failed with exit code $exit_code"
    exit $exit_code
fi

# Run the file_updater Python script
python3 file_updater.py

# Check the exit code of the second script
exit_code=$?
if [ $exit_code -ne 0 ]; then
    echo "Error: Second script failed with exit code $exit_code"
    exit $exit_code
fi

echo "Both Python scripts have been successfully executed."
