# README - Structure and Design

-----
## Repository Property File Comparator

This script compares property files between an old repository and a latest repository, identifies the differences, and generates CSV files to summarize the results.

### Overview

When working with version-controlled repositories, it's common to have different versions of property files that contain configuration settings. This script helps you compare property files between two repositories (old and latest) and provides insights into the differences between them. It is particularly useful when migrating from an old version of a repository to a new version, ensuring that important configuration settings are maintained and updated correctly.

The script performs the following steps:

1. Cloning repositories: It clones the old and latest repositories using Git, allowing you to specify the repository URLs and branch names.

2. Retrieving property file mapping: You provide a CSV file (`property_file_mapping.csv`) that contains the mapping of property files between the old and latest repositories. Each row in the CSV file contains two columns: `Old Property File` and `Latest Property File`. The script reads this file to determine which property files should be compared.

3. Comparing property files: The script compares the property files specified in the CSV file pair by pair. It identifies properties with different values, properties that exist only in the old repository, and properties that exist only in the latest repository.

4. Generating output files: After comparing the property files, the script generates three CSV files in the `output` directory:
   - `different_properties.csv`: Contains the details of properties that have different values between the old and latest repositories.
   - `old_file_only.csv`: Contains the details of properties that exist only in the old repository.
   - `latest_file_only.csv`: Contains the details of properties that exist only in the latest repository.

### Code Structure

The code is structured as follows:

1. Importing necessary modules: The required modules (`os`, `sys`, `subprocess`, and `csv`) are imported.

2. Retrieving command-line arguments: The script retrieves the URLs and branches of the old and latest repositories from the command-line arguments.

3. Creating directories: The script creates two directories, "old-config" and "latest-config," to store the cloned repositories.

4. Cloning repositories: The old repository is cloned into the "old-config" directory, and the latest repository is cloned into the "latest-config" directory.

5. Retrieving property file pairs: The script reads a CSV file named "property_file_mapping.csv" to obtain pairs of property file names from the old and latest repositories.

6. Comparing property files: The script compares the property files from the old and latest repositories, identifying different properties, properties only found in the old repository, and properties only found in the latest repository.

7. Creating output directory: An "output" directory is created to store the resulting CSV files.

8. Creating CSV files: The script creates three CSV files in the "output" directory.
    - "different_properties.csv" stores the different property values between the old and latest repositories.
    - "old_file_only.csv" stores the property values found only in the old repository.
    - "latest_file_only.csv" stores the property values found only in the latest repository.

## CSV File Structure

The structure of the resulting CSV files is as follows:

1. **different_properties.csv**:

   | Old Property File | Latest Property File | Key | Old Value | Latest Value |
      |-------------------|---------------------|-----|-----------|--------------|
   | file1.properties  | file1.properties     | key1| value1    | value2       |
   | file2.properties  | file2.properties     | key2| value3    | value4       |
   | ...               | ...                 | ... | ...        | ...          |

   This file contains the properties that have different values between the old and latest repositories. Each row represents a different property, with columns indicating the old property file, latest property file, key, old value, and latest value.

2. **old_file_only.csv**:

   | Old Property File | Key | Old Value |
      |-------------------|-----|-----------|
   | file1.properties  | key1| value1    |
   | file1.properties  | key2| value2    |
   | ...               | ... | ...       |

   This file contains the properties that are only found in the old repository. Each row represents a unique property, with columns indicating the old property file, key, and old value.

3. **latest_file_only.csv**:

   | Latest Property File | Key | Latest Value |
      |----------------------|-----|--------------|
   | file2.properties     | key3| value3       |
   | file2.properties     | key4| value4       |
   | ...                  | ... | ...          |

   This file contains the properties that are only found in the latest repository. Each row represents a unique property, with columns indicating the latest property file, key, and latest value.

The CSV file structure allows for easy analysis and comparison of the different properties between the repositories, as well as identifying unique properties specific to each repository.

-----
# Property File Updater

The Property File Updater is a script that automates the process of updating property files based on information provided in knowledge base CSV files. It allows you to manage and prioritize property values, handle different versions of property files, and generate a manual configuration file for further customization.

This script updates property files in a given directory based on information provided in knowledge base CSV files. It performs the following actions:

1. Reads a CSV file (`different_properties.csv`) containing information about different property values.
2. Reads two CSV files (`old-value-takes-priority.csv` and `latest-Value-takes-priority.csv`) to prioritize property values.
3. Compares non-matching combinations with `latest-Value-takes-priority.csv` and identifies similar latest values.
4. Creates a `manual-configuration.csv` file for further manual configuration.
5. Compares combinations from `different_properties.csv` with `old-value-takes-priority.csv` and `latest-Value-takes-priority.csv` to find unresolved combinations.
6. Updates the `manual-configuration.csv` file with unresolved combinations.
7. Reads `old_file_only.csv` and `intentionally_removed_in_lts.csv` files and compares the combinations.
8. Updates the `manual-configuration.csv` file with the new combinations.

## CSV File Structures

The script expects the following CSV files to be present in the specified locations:

### different_properties.csv

This file contains information about different property values found in different versions of property files. It has the following structure:

| Latest Property File | Key  | Old Value | Latest Value |
|----------------------|------|-----------|--------------|
| file1.properties     | key1 | value1    | value2       |
| file2.properties     | key2 | value3    | value4       |
| ...                  | ...  | ...       | ...          |

### old_value-takes-priority.csv

This file prioritizes the old property values over the latest ones. It has the following structure:

| Property File Name | Key  |
|--------------------|------|
| file1.properties   | key1 |
| file2.properties   | key2 |
| ...                | ...  |

### latest_value-takes-priority.csv

This file prioritizes the latest property values over the old ones. It has the following structure:

| Property File Name | Key  |
|--------------------|------|
| file1.properties   | key1 |
| file2.properties   | key2 |
| ...                | ...  |

### old_file_only.csv

This file contains property combinations that are present only in the old property files. It has the following structure:

| Old Property File | Key  | Old Value |
|-------------------|------|-----------|
| file1.properties  | key1 | value1    |
| file2.properties  | key2 | value2    |
| ...               | ...  | ...       |

### latest_file_only.csv

This file contains property combinations that are present only in the latest property files. It has the following structure:

| Latest Property File | Key  | Latest Value |
|----------------------|------|--------------|
| file1.properties     | key1 | value1       |
| file2.properties     | key2 | value2       |
| ...                  | ...  | ...          |

### intentionally_removed_in_lts.csv

This file contains property combinations that were intentionally removed in the latest version. It has the following structure:

| Property File Name | Key  |
|--------------------|------|
| file1.properties   | key1 |
| file2.properties   | key2 |
| ...                | ...  |

### decent_default_value.csv

This file contains information about decent default property values for the latest property files. It has the following structure:

| Property File Name | Key  | Latest Value |
|--------------------|------|--------------|
| file1.properties   | key1 | value1       |
| file2.properties   | key2 | value2       |
| ...                | ...  | ...          |

### manual-configuration.csv

This file is created or updated by the script and includes unresolved combinations and combinations that require further manual configuration. It has the following structure:

| Property File Name | Key  | Old Value | Latest Value | Configuration Action |
|--------------------|------|-----------|--------------|---------------------|
| file1.properties   | key1 | value1    | value2       | update-if-required  |
| file2.properties   | key2 | value3    | value4       | copy-property       |
| ...                | ...  | ...       | ...          | ...                 |

## Output

The Property File Updater generates the following output:

### Updated Property Files

This section lists the property files that were updated during the process. It includes the names of the files and the keys that were modified.

### Logs

The script generates a log file (`logs.txt`) that provides detailed information about the update process. It includes information about matching combinations, unresolved combinations, similar latest values, and more. The log file helps you understand the changes made to the property files and allows you to review the update process.

### Manual Configuration CSV

The script creates or updates the `manual-configuration.csv` file. This file includes unresolved combinations and combinations that require further manual configuration. You can use this file to manually update the property files based on the required configuration actions mentioned in the file.

Note:

- It is highly recommended to create backups of your property files before running this script, as it modifies the files in place.
- The `manual-configuration.csv` file can be used to manually update the property files based on the required configuration actions mentioned in the file.

----
# Migrator script

This Bash script is designed to automate the process of comparing and updating configuration files based on a new set of configurations. It utilizes two Python scripts: `file_comparator.py` and `file_updater.py`.

It performs the following steps:
* Prompt for the URL and branch of the existing old configuration repository.

* Prompt for the URL and branch of the new based configuration repository.

* Execute the file_comparator.py Python script with the provided values as arguments. This script compares the property files between the two repositories and generates output files.

* Check the exit code of the file_comparator.py script. If it is non-zero, display an error message and terminate the script.

* If the file_comparator.py script exits with a zero exit code, execute the file_updater.py Python script, passing the new based configuration branch as an argument. This script performs the necessary updates based on the comparison results.

* Check the exit code of the file_updater.py script. If it is non-zero, display an error message and terminate the script.

* If both Python scripts complete successfully, display a success message.

These scripts provide a convenient way to automate the process of comparing and updating configuration files, saving time and reducing errors.