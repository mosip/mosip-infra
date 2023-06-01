import os
import subprocess
import csv

# Prompt for existing Old configuration repo URL and branch
old_repo_url = input("Enter existing old configuration repo URL: ")
old_repo_branch = input("Enter existing old configuration repo branch: ")

# Create Old dir
old_dir = "old-config"
os.makedirs(old_dir, exist_ok=True)

# Clone the existing repo with Old-repo-branch inside the old directory
old_repo_path = os.path.join(old_dir, old_repo_branch)
subprocess.run(["git", "clone", "--branch", old_repo_branch, old_repo_url, old_repo_path])

# Prompt for New based configurations URL and branch
new_repo_url = input("Enter new based configurations URL: ")
new_repo_branch = input("Enter new based configuration branch: ")

# Create New dir
new_dir = "new-config"
os.makedirs(new_dir, exist_ok=True)

# Clone the New repo with New-repo-branch inside the New directory
new_repo_path = os.path.join(new_dir, new_repo_branch)
subprocess.run(["git", "clone", "--branch", new_repo_branch, new_repo_url, new_repo_path])

# Retrieve property file pairs from CSV
property_file_pairs = []
csv_file = "property_file_pairs.csv"
with open(csv_file, 'r') as file:
    reader = csv.reader(file)
    for row in reader:
        property_file_pairs.append(row)

# Compare property files and create different_properties.csv, file1_only.csv, and file2_only.csv
different_properties = []
old_only_properties = []
new_only_properties = []

for old_filename, new_filename in property_file_pairs:
    old_file = os.path.join(old_repo_path, "sandbox", old_filename)
    new_file = os.path.join(new_repo_path, new_filename)

    if not os.path.exists(old_file):
        if os.path.exists(new_file):
            with open(new_file, 'r') as new:
                new_lines = new.readlines()

            new_properties = {}
            for line in new_lines:
                line = line.strip()
                if "=" not in line:
                    continue  # Skip lines that don't contain '='
                key, value = line.split("=", 1)
                new_properties[key] = value

            for key, value in new_properties.items():
                new_only_properties.append((new_filename, key, value))
        else:
            print(f"Old property file not found and New property file not found for {old_filename}. Skipping...")
        continue

    with open(old_file, 'r') as old:
        old_lines = old.readlines()

    with open(new_file, 'r') as new:
        new_lines = new.readlines()

    old_properties = {}
    new_properties = {}

    for line in old_lines:
        line = line.strip()
        if "=" not in line:
            continue  # Skip lines that don't contain '='
        key, value = line.split("=", 1)
        old_properties[key] = value

    for line in new_lines:
        line = line.strip()
        if "=" not in line:
            continue  # Skip lines that don't contain '='
        key, value = line.split("=", 1)
        new_properties[key] = value

    different_keys = set(old_properties.keys()) & set(new_properties.keys())

    for key in different_keys:
        old_value = old_properties[key]
        new_value = new_properties[key]
        if old_value != new_value:
            different_properties.append((old_filename, new_filename, key, old_value, new_value))

    old_only_keys = set(old_properties.keys()) - set(new_properties.keys())
    for key in old_only_keys:
        old_value = old_properties[key]
        old_only_properties.append((old_filename, key, old_value))

    new_only_keys = set(new_properties.keys()) - set(old_properties.keys())
    for key in new_only_keys:
        new_value = new_properties[key]
        new_only_properties.append((new_filename, key, new_value))

# Create different_properties.csv
different_properties_csv = "different_properties.csv"
with open(different_properties_csv, 'w', newline='') as file:
    writer = csv.writer(file)
    writer.writerow(["Old Property File", "New Property File", "Key", "Old Value", "New Value"])
    for item in different_properties:
        writer.writerow(item)

print("different_properties.csv created successfully.")

# Create file1_only.csv
file1_only_csv = "file1_only.csv"
with open(file1_only_csv, 'w', newline='') as file:
    writer = csv.writer(file)
    writer.writerow(["Old Property File", "Key", "Old Value"])
    for item in old_only_properties:
        writer.writerow(item)

print("file1_only.csv created successfully.")

# Create file2_only.csv
file2_only_csv = "file2_only.csv"
with open(file2_only_csv, 'w', newline='') as file:
    writer = csv.writer(file)
    writer.writerow(["New Property File", "Key", "New Value"])
    for item in new_only_properties:
        writer.writerow(item)

print("file2_only.csv created successfully.")
print("Script completed successfully.")
