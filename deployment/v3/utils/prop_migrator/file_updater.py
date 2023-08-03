import csv
import os
import sys

different_properties_csv = 'output/different_properties.csv'
old_value_takes_priority_csv = 'knowledge/old-value-takes-priority.csv'
latest_value_takes_priority_csv = 'knowledge/latest-Value-takes-priority.csv'
latest_repo_branch = sys.argv[1]
latest_directory = f'latest-config/{latest_repo_branch}'
manual_configuration_csv = 'manual-configuration.csv'
old_file_only_csv = 'output/old_file_only.csv'
intentionally_removed_csv = 'knowledge/intentionally-removed-in-lts.csv'
latest_file_only_csv = 'output/latest_file_only.csv'
decent_default_value_csv = 'knowledge/new-property-with-decent-default-value.csv'
log_file = 'logs.txt'
property_categories_csv = 'knowledge/property-categories.csv'

matching_combinations = []
non_matching_combinations = []
matching_rows = []
updated_property_files = []
similar_latest_value = []
unresolved_combinations = set()  # Use a set to avoid duplicates
case2_matching_combinations = []
case2_unresolved_combinations = set()  # Use a set to avoid duplicates
case3_matching_combinations = []
case3_unresolved_combinations = set()  # Use a set to avoid duplicates
existing_combinations = set()
case2_existing_combinations = set()
case3_existing_combinations = set()
key_values = set()
property_category_dict = {}

# Read property-categories.csv
with open(property_categories_csv, 'r') as property_category_file:
    reader_cat = csv.DictReader(property_category_file)
    for row_cat in reader_cat:
        property_file_category = row_cat['Property file name']
        key_category = row_cat['Key']
        property_category = row_cat['Property Category']
        combination_category = (property_file_category, key_category)
        property_category_dict[combination_category] = property_category

# Read different_properties.csv
with open(different_properties_csv, 'r') as file:
    reader = csv.DictReader(file)
    properties_dict = {(row['Latest Property File'], row['Key']): row['Old Value'] for row in reader}

# Read old-value-takes-priority.csv
with open(old_value_takes_priority_csv, 'r') as file:
    reader = csv.DictReader(file)
    for row in reader:
        property_file_name = row['Property file name']
        key = row['key']

        # Compare the combinations and add to the corresponding list
        if (property_file_name, key) in properties_dict:
            matching_combinations.append((property_file_name, key))
        else:
            non_matching_combinations.append((property_file_name, key))

# Check if the property files exist in the latest directory and update their values
for combination in matching_combinations:
    property_file_name, key = combination
    latest_property_file_path = os.path.join(latest_directory, property_file_name)

    if os.path.isfile(latest_property_file_path):
        old_value = properties_dict[combination]

        # Update the value in the property file
        updated_lines = []
        with open(latest_property_file_path, 'r') as file:
            for line in file:
                if line.strip().startswith(key + '='):
                    line = f'{key}={old_value}\n'
                updated_lines.append(line)

        with open(latest_property_file_path, 'w') as file:
            file.writelines(updated_lines)

        updated_property_files.append(latest_property_file_path)

        # Update properties_dict with latest value
        properties_dict[(property_file_name, key)] = old_value

        # Print the updated property file
        print(f"Updated {latest_property_file_path} with {key}={old_value}")

# Compare non-matching combinations with latest-Value-takes-priority.csv
with open(latest_value_takes_priority_csv, 'r') as file3:
    reader3 = csv.DictReader(file3)
    for row3 in reader3:
        property_file_name = row3['Property file name']
        key3 = row3['key']

        # Compare the combinations and add matching rows to the list
        for combination in non_matching_combinations:
            latest_property_file, key = combination
            if latest_property_file == property_file_name and key == key3:
                similar_latest_value.append(row3)
                unresolved_combinations.discard(combination)  # Remove the resolved combination from unresolved set
                break
        else:
            unresolved_combinations.add(combination)  # Add unresolved combination to the set

# Read the "old_value-takes-priority" files and store the combinations in a set
with open(old_value_takes_priority_csv, 'r') as file2:
    reader2 = csv.DictReader(file2)
    key_values.update((row['Property file name'], row['key']) for row in reader2)

with open(latest_value_takes_priority_csv, 'r') as file3:
    reader3 = csv.DictReader(file3)
    key_values.update((row['Property file name'], row['key']) for row in reader3)

unresolved_combinations = set()

# Find combinations from "different_properties.csv" that are not in the key_values set
with open(different_properties_csv, 'r') as file1:
    reader1 = csv.DictReader(file1)
    for row1 in reader1:
        latest_property_file = row1['Latest Property File']
        key = row1['Key']
        combination = (latest_property_file, key)
        if combination not in key_values:
            unresolved_combinations.add(combination)

# Create manual-configuration.csv with comment "update-if-old-value-takes-priority"
with open(manual_configuration_csv, 'w', newline='') as file:
    writer = csv.writer(file)
    writer.writerow(['Property file name', 'Key', 'Old Value', 'Latest Value', 'Configuration Action'])

    # Iterate through the different_properties.csv and update values if combination matches
    with open(different_properties_csv, 'r') as file1:
        reader1 = csv.DictReader(file1)
        for row1 in reader1:
            property_file = row1['Latest Property File']
            key = row1['Key']
            old_value = row1['Old Value']
            latest_value = row1['Latest Value']
            combination = (property_file, key)
            if combination in unresolved_combinations:
                # Check if the combination exists in the property_category_dict
                if combination in property_category_dict:
                    property_category = property_category_dict[combination]
                else:
                    property_category = "N/A"  # Set a default value if the combination is not found
                writer.writerow([property_file, key, old_value, latest_value, property_category, 'update-if-old-value-takes-priority'])

print("Manual configuration CSV file has been created.")

# Read old_file_only.csv and intentionally_removed_in_lts.csv and compare.
with open(old_file_only_csv, 'r') as file1:
    reader1 = csv.DictReader(file1)
    for row1 in reader1:
        property_file_name1 = row1['Old Property File']
        key1 = row1['Key']
        combination_found = False

        with open(intentionally_removed_csv, 'r') as file2:
            reader2 = csv.DictReader(file2)
            for row2 in reader2:
                property_file_name2 = row2['Property file name']
                key2 = row2['key']

                # Compare the combinations and mark as found if there is a match
                if property_file_name1 == property_file_name2 and key1 == key2:
                    case2_matching_combinations.append((property_file_name1, key1))
                    combination_found = True
                    break

        if not combination_found:
            case2_unresolved_combinations.add((property_file_name1, key1))

# Read the existing manual-configuration.csv file and store the existing combinations
if os.path.isfile(manual_configuration_csv):
    with open(manual_configuration_csv, 'r') as file:
        reader = csv.reader(file)
        existing_content = list(reader)  # Read existing content and store it in memory

        # Store existing combinations in a set
        header = existing_content[0]  # Get the header row
        for row in existing_content[1:]:  # Skip the header row
            latest_property_file = row[header.index('Property file name')]
            key = row[header.index('Key')]
            old_value = row[header.index('Old Value')]
            existing_combinations.add((latest_property_file, key, old_value))

# Add new unresolved combinations to the case2 combinations
case2_existing_combinations.update(case2_unresolved_combinations)

# Append the updated combinations to the manual-configuration.csv file
with open(manual_configuration_csv, 'a', newline='') as file:
    writer = csv.writer(file)

    # Write the new content
    for combination in case2_existing_combinations:
        latest_property_file, key = combination

        # Find the corresponding old value in file1_only_csv and update it in manual-configuration.csv
        with open(old_file_only_csv, 'r') as file1:
            reader1 = csv.DictReader(file1)
            for row1 in reader1:
                property_file_name1 = row1['Old Property File']
                key1 = row1['Key']
                old_value1 = row1['Old Value']
                if property_file_name1 == latest_property_file and key1 == key:
                    # Check if the combination exists in the property_category_dict
                    if combination in property_category_dict:
                        property_category = property_category_dict[combination]
                    else:
                        property_category = "N/A"  # Set a default value if the combination is not found
                    writer.writerow([latest_property_file, key, old_value1, '', property_category, 'copy-property-if-required-in-lts'])
                    break
print("Manual configuration CSV file has been updated.")

# Read latest_file_only.csv and find matching combinations
with open(latest_file_only_csv, 'r') as file2:
    reader2 = csv.DictReader(file2)
    for row2 in reader2:
        property_file_name2 = row2['Latest Property File']
        key2 = row2['Key']
        combination_found = False

        with open(decent_default_value_csv, 'r') as file1:
            reader1 = csv.DictReader(file1)
            for row1 in reader1:
                property_file_name1 = row1['Property file name']
                key1 = row1['Key']

                # Compare the combinations and mark as found if there is a match
                if property_file_name1 == property_file_name2 and key1 == key2:
                    case3_matching_combinations.append((property_file_name2, key2))
                    combination_found = True
                    break

        if not combination_found:
            case3_unresolved_combinations.add((property_file_name2, key2))

# Read the existing manual-configuration.csv file and store the existing combinations
if os.path.isfile(manual_configuration_csv):
    with open(manual_configuration_csv, 'r') as file:
        reader = csv.reader(file)
        existing_content = list(reader)  # Read existing content and store it in memory

    # Store existing combinations in a set
    header = existing_content[0]  # Get the header row
    for row in existing_content[1:]:  # Skip the header row
        latest_property_file = row[header.index('Property file name')]
        key = row[header.index('Key')]
        latest_value = row[header.index('Latest Value')]
        existing_combinations.add((latest_property_file, key, latest_value))

# Add new unresolved combinations to the case3 combinations
case3_existing_combinations.update(case3_unresolved_combinations)

# Append the updated combinations to the manual-configuration.csv file
with open(manual_configuration_csv, 'a', newline='') as file:
    writer = csv.writer(file)

    # Write the new content
    for combination in case3_existing_combinations:
        latest_property_file, key = combination

        # Find the corresponding new value in latest_file_only.csv and update it in manual-configuration.csv
        with open(latest_file_only_csv, 'r') as file2:
            reader2 = csv.DictReader(file2)
            for row2 in reader2:
                property_file_name2 = row2['Latest Property File']
                key2 = row2['Key']
                latest_value2 = row2['Latest Value']
                if property_file_name2 == latest_property_file and key2 == key:
                    # Check if the combination exists in the property_category_dict
                    if combination in property_category_dict:
                        property_category = property_category_dict[combination]
                    else:
                        property_category = "N/A"  # Set a default value if the combination is not found
                    writer.writerow([latest_property_file, key, '', latest_value2, property_category, 'update-if-value-needs-change'])
                    break
print("Manual configuration CSV file has been updated.")

# Open a file for writing the log
with open(log_file, 'w') as file:
    # Redirect the standard output to the file
    original_stdout = sys.stdout
    sys.stdout = file

    # Print the updated property file
    # print(f"Updated {lts_property_file_path} with {key}={pre_lts_value}")

    print("Matching combinations:")
    for combination in matching_combinations:
        print(combination)

    print("Similar Latest values:")
    for row in similar_latest_value:
        print(row)

    print("Unresolved combinations:")
    for combination in unresolved_combinations:
        print(combination)

    # Print the case2 matching combinations
    print("Case2 Matching combinations:")
    for combination in case2_matching_combinations:
        print(combination)

    print("Case2 Unresolved combinations:")
    for combination in case2_unresolved_combinations:
        print(combination)

    # Print the case3 matching combinations
    print("Case3 Matching combinations:")
    for combination in case3_matching_combinations:
        print(combination)

    print("Case3 Unresolved combinations:")
    for combination in case3_unresolved_combinations:
        print(combination)

# Restore the standard output
sys.stdout = original_stdout

# Print a message indicating that the log has been written
print(f"The log has been written to {log_file}.")