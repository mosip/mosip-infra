import csv
import os
import sys

different_properties_csv = 'different_properties.csv'
value_takes_priority_csv = 'knowledge/1.1.5.5-value-takes-priority.csv'
lts_value_takes_priority_csv = 'knowledge/lts-Value-takes-priority.csv'
new_directory = 'new-config/v1.2.0.1-B1'
manual_adjudication_csv = 'manual-adjudication.csv'
file1_only_csv = 'file1_only.csv'
intentionally_removed_csv = 'knowledge/intentionally-removed-in-lts.csv'
file2_only_csv = 'file2_only.csv'
decent_default_value_csv = 'knowledge/new-property-with-decent-default-value.csv'
log_file = 'logs.txt'

matching_combinations = []
non_matching_combinations = []
matching_rows = []
updated_property_files = []
similar_new_value = []
unresolved_combinations = set()  # Use a set to avoid duplicates
case2_matching_combinations = []
case2_unresolved_combinations = set()  # Use a set to avoid duplicates
case3_matching_combinations = []
case3_unresolved_combinations = set()  # Use a set to avoid duplicates
existing_combinations = set()
case2_existing_combinations = set()
case3_existing_combinations = set()
key_values = set()

# Read different_properties.csv
with open(different_properties_csv, 'r') as file:
    reader = csv.DictReader(file)
    properties_dict = {(row['New Property File'], row['Key']): row['Old Value'] for row in reader}

# Read 1.1.5.5-value-takes-priority.csv
with open(value_takes_priority_csv, 'r') as file:
    reader = csv.DictReader(file)
    for row in reader:
        property_file_name = row['Property file name']
        key = row['key']

        # Compare the combinations and add to the corresponding list
        if (property_file_name, key) in properties_dict:
            matching_combinations.append((property_file_name, key))
        else:
            non_matching_combinations.append((property_file_name, key))

# Check if the property files exist in the new directory and update their values
for combination in matching_combinations:
    property_file_name, key = combination
    new_property_file_path = os.path.join(new_directory, property_file_name)

    if os.path.isfile(new_property_file_path):
        old_value = properties_dict[combination]

        # Update the value in the property file
        updated_lines = []
        with open(new_property_file_path, 'r') as file:
            for line in file:
                if line.strip().startswith(key + '='):
                    line = f'{key}={old_value}\n'
                updated_lines.append(line)

        with open(new_property_file_path, 'w') as file:
            file.writelines(updated_lines)

        updated_property_files.append(new_property_file_path)

        # Update properties_dict with new value
        properties_dict[(property_file_name, key)] = old_value

        # Print the updated property file
        print(f"Updated {new_property_file_path} with {key}={old_value}")

# Compare non-matching combinations with lts-Value-takes-priority.csv
with open(lts_value_takes_priority_csv, 'r') as file3:
    reader3 = csv.DictReader(file3)
    for row3 in reader3:
        property_file_name = row3['Property file name']
        key3 = row3['key']

        # Compare the combinations and add matching rows to the list
        for combination in non_matching_combinations:
            new_property_file, key = combination
            if new_property_file == property_file_name and key == key3:
                similar_new_value.append(row3)
                unresolved_combinations.discard(combination)  # Remove the resolved combination from unresolved set
                break
        else:
            unresolved_combinations.add(combination)  # Add unresolved combination to the set

# Read the "value-takes-priority" files and store the combinations in a set
with open(value_takes_priority_csv, 'r') as file2:
    reader2 = csv.DictReader(file2)
    key_values.update((row['Property file name'], row['key']) for row in reader2)

with open(lts_value_takes_priority_csv, 'r') as file3:
    reader3 = csv.DictReader(file3)
    key_values.update((row['Property file name'], row['key']) for row in reader3)

unresolved_combinations = set()

# Find combinations from "different_properties.csv" that are not in the key_values set
with open(different_properties_csv, 'r') as file1:
    reader1 = csv.DictReader(file1)
    for row1 in reader1:
        new_property_file = row1['New Property File']
        key = row1['Key']
        combination = (new_property_file, key)
        if combination not in key_values:
            unresolved_combinations.add(combination)

# Create manual-adjudication.csv with comment "update-if-old-value-takes-priority"
with open(manual_adjudication_csv, 'w', newline='') as file:
    writer = csv.writer(file)
    writer.writerow(['Property file name', 'Key', 'Old Value', 'New Value', 'Action'])

    # Iterate through the different_properties.csv and update values if combination matches
    with open(different_properties_csv, 'r') as file1:
        reader1 = csv.DictReader(file1)
        for row1 in reader1:
            property_file = row1['New Property File']
            key = row1['Key']
            old_value = row1['Old Value']
            new_value = row1['New Value']
            combination = (property_file, key)
            if combination in unresolved_combinations:
                writer.writerow([property_file, key, old_value, new_value, 'update-if-old-value-takes-priority'])

print("Manual adjudication CSV file has been created.")

# Read file1_only.csv and intentionally-removed-in-lts.csv and compare.
with open(file1_only_csv, 'r') as file1:
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

# Read the existing manual-adjudication.csv file and store the existing combinations
if os.path.isfile(manual_adjudication_csv):
    with open(manual_adjudication_csv, 'r') as file:
        reader = csv.reader(file)
        existing_content = list(reader)  # Read existing content and store it in memory

        # Store existing combinations in a set
        for row in existing_content[1:]:  # Skip the header row
            lts_property_file = row[0]
            key = row[1]
            old_value = row[2]
            existing_combinations.add((lts_property_file, key, old_value))

# Add new unresolved combinations to the case2 combinations
case2_existing_combinations.update(case2_unresolved_combinations)

# Append the updated combinations to the manual-adjudication.csv file
with open(manual_adjudication_csv, 'a', newline='') as file:
    writer = csv.writer(file)
    writer.writerow(['Property file name', 'Key', 'Old Value', 'Action'])

    # Write the new content
    for combination in case2_existing_combinations:
        new_property_file, key = combination

        # Find the corresponding old value in file1_only_csv and update it in manual-adjudication.csv
        with open(file1_only_csv, 'r') as file1:
            reader1 = csv.DictReader(file1)
            for row1 in reader1:
                property_file_name1 = row1['Old Property File']
                key1 = row1['Key']
                old_value1 = row1['Old Value']
                if property_file_name1 == new_property_file and key1 == key:
                    writer.writerow([new_property_file, key, old_value1, 'copy-property-if-required-in-lts'])
                    break
print("Manual adjudication CSV file has been updated.")

# Read file2_only.csv and find matching combinations
with open(file2_only_csv, 'r') as file2:
    reader2 = csv.DictReader(file2)
    for row2 in reader2:
        property_file_name2 = row2['New Property File']
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

# Read the existing manual-adjudication.csv file and store the existing combinations
if os.path.isfile(manual_adjudication_csv):
    with open(manual_adjudication_csv, 'r') as file:
        reader = csv.reader(file)
        existing_content = list(reader)  # Read existing content and store it in memory

        # Store existing combinations in a set
        for row in existing_content[1:]:  # Skip the header row
            lts_property_file = row[0]
            key = row[1]
            new_value = row[2]
            existing_combinations.add((lts_property_file, key, new_value))

# Add new unresolved combinations to the case3 combinations
case3_existing_combinations.update(case3_unresolved_combinations)

# Append the updated combinations to the manual-adjudication.csv file
with open(manual_adjudication_csv, 'a', newline='') as file:
    writer = csv.writer(file)
    writer.writerow(['Property file name', 'Key', 'New Value', 'Action'])

    # Write the new content
    for combination in case3_existing_combinations:
        new_property_file, key = combination

        # Find the corresponding new value in file2_only_csv and update it in manual-adjudication.csv
        with open(file2_only_csv, 'r') as file2:
            reader2 = csv.DictReader(file2)
            for row2 in reader2:
                property_file_name2 = row2['New Property File']
                key2 = row2['Key']
                new_value2 = row2['New Value']
                if property_file_name2 == new_property_file and key2 == key:
                    writer.writerow([new_property_file, key, new_value2, 'update-if-value-needs-change'])
                    break
print("Manual adjudication CSV file has been updated.")

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

    print("Similar New values:")
    for row in similar_new_value:
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
