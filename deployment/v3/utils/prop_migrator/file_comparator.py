import os
import sys
import subprocess
import csv

old_repo_url = sys.argv[1]
old_repo_branch = sys.argv[2]
latest_repo_url = sys.argv[3]
latest_repo_branch = sys.argv[4]

# Create Old dir
old_dir = "old-config"
os.makedirs(old_dir, exist_ok=True)

# Clone the existing repo with Old-repo-branch inside the old directory
old_repo_path = os.path.join(old_dir, old_repo_branch)
subprocess.run(["git", "clone", "--branch", old_repo_branch, old_repo_url, old_repo_path])

# Create New dir
latest_dir = "latest-config"
os.makedirs(latest_dir, exist_ok=True)

# Clone the New repo with New-repo-branch inside the New directory
latest_repo_path = os.path.join(latest_dir, latest_repo_branch)
subprocess.run(["git", "clone", "--branch", latest_repo_branch, latest_repo_url, latest_repo_path])

# Retrieve property file pairs from CSV
property_file_pairs = []
csv_file = "propert_file_mapping.csv"
with open(csv_file, 'r') as file:
    reader = csv.reader(file)
    for row in reader:
        property_file_pairs.append(row)

# Compare property files and create different_properties.csv, file1_only.csv, and file2_only.csv
different_properties = []
old_only_properties = []
latest_only_properties = []

for old_filename, latest_filename in property_file_pairs:
    old_file = os.path.join(old_repo_path, old_filename)
    latest_file = os.path.join(latest_repo_path, latest_filename)

    if not os.path.exists(old_file):
        if os.path.exists(latest_file):
            with open(latest_file, 'r') as latest:
                latest_lines = latest.readlines()

            latest_properties = {}
            for line in latest_lines:
                line = line.strip()
                if line.startswith('#') or "=" not in line:
                    continue  # Skip lines that start with '#' or don't contain '='
                key, value = line.split("=", 1)
                latest_properties[key] = value

            for key, value in latest_properties.items():
                latest_only_properties.append((latest_filename, key, value))
        else:
            print(f"Old and new properties, both are not found for {old_filename}. Skipping...")
        continue

    with open(old_file, 'r') as old:
        old_lines = old.readlines()

    with open(latest_file, 'r') as latest:
        latest_lines = latest.readlines()

    old_properties = {}
    latest_properties = {}

    for line in old_lines:
        line = line.strip()
        if line.startswith('#') or "=" not in line:
            continue  # Skip lines that start with '#' or don't contain '='
        key, value = line.split("=", 1)
        old_properties[key] = value

    for line in latest_lines:
        line = line.strip()
        if line.startswith('#') or "=" not in line:
            continue  # Skip lines that start with '#' or don't contain '='
        key, value = line.split("=", 1)
        latest_properties[key] = value

    different_keys = set(old_properties.keys()) & set(latest_properties.keys())

    for key in different_keys:
        old_value = old_properties[key]
        latest_value = latest_properties[key]
        if old_value != latest_value:
            different_properties.append((old_filename, latest_filename, key, old_value, latest_value))

    old_only_keys = set(old_properties.keys()) - set(latest_properties.keys())
    for key in old_only_keys:
        old_value = old_properties[key]
        old_only_properties.append((old_filename, key, old_value))

    latest_only_keys = set(latest_properties.keys()) - set(old_properties.keys())
    for key in latest_only_keys:
        latest_value = latest_properties[key]
        latest_only_properties.append((latest_filename, key, latest_value))

# Create output directory
output_dir = "output"
os.makedirs(output_dir, exist_ok=True)

# Create different_properties.csv in output directory
different_properties_csv = os.path.join(output_dir, "different_properties.csv")
with open(different_properties_csv, 'w', newline='') as file:
    writer = csv.writer(file)
    writer.writerow(["Old Property File", "Latest Property File", "Key", "Old Value", "Latest Value"])
    for item in different_properties:
        writer.writerow(item)

print("different_properties.csv created successfully.")

# Create old_file_only.csv in output directory
old_file_only_csv = os.path.join(output_dir, "old_file_only.csv")
with open(old_file_only_csv, 'w', newline='') as file:
    writer = csv.writer(file)
    writer.writerow(["Old Property File", "Key", "Old Value"])
    for item in old_only_properties:
        writer.writerow(item)

print("old_file_only.csv created successfully.")

# Create latest_file_only.csv in output directory
latest_file_only_csv = os.path.join(output_dir, "latest_file_only.csv")
with open(latest_file_only_csv, 'w', newline='') as file:
    writer = csv.writer(file)
    writer.writerow(["Latest Property File", "Key", "Latest Value"])
    for item in latest_only_properties:
        writer.writerow(item)

print("latest_file_only.csv created successfully.")
print("Script completed successfully.")
