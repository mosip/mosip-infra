# Repository Property File Comparator

This script compares property files between an old repository and a latest repository, identifies the differences, and generates CSV files to summarize the results.

## Overview

When working with version-controlled repositories, it's common to have different versions of property files that contain configuration settings. This script helps you compare property files between two repositories (old and latest) and provides insights into the differences between them. It is particularly useful when migrating from an old version of a repository to a new version, ensuring that important configuration settings are maintained and updated correctly.

The script performs the following steps:

1. Cloning repositories: It clones the old and latest repositories using Git, allowing you to specify the repository URLs and branch names.

2. Retrieving property file mapping: You provide a CSV file (`property_file_mapping.csv`) that contains the mapping of property files between the old and latest repositories. Each row in the CSV file contains two columns: `Old Property File` and `Latest Property File`. The script reads this file to determine which property files should be compared.

3. Comparing property files: The script compares the property files specified in the CSV file pair by pair. It identifies properties with different values, properties that exist only in the old repository, and properties that exist only in the latest repository.

4. Generating output files: After comparing the property files, the script generates three CSV files in the `output` directory:
    - `different_properties.csv`: Contains the details of properties that have different values between the old and latest repositories.
    - `old_file_only.csv`: Contains the details of properties that exist only in the old repository.
    - `latest_file_only.csv`: Contains the details of properties that exist only in the latest repository.

## Prerequisites

Before running the script, ensure that you have the following prerequisites:

- Python 3 installed: The script is written in Python, so you need Python 3 installed on your system.
- Git command-line tool installed: The script uses Git commands to clone the repositories. Make sure Git is installed and available in your command-line environment.

## Usage

To use the script, follow these steps:

1. Clone or download the code from this repository.

2. Open a terminal or command prompt and navigate to the directory where the code is located.

3. Install the required Python dependencies by running the following command:

   ```shell
   pip install -r requirements.txt

4. Prepare the CSV file containing the mapping of property files:

    - Create a CSV file named `property_file_mapping.csv`.
    - Each row in the CSV file should contain two columns: `Old Property File` and `Latest Property File`.
    - Provide the relative paths of the property files in the old and latest repositories.

   Example:

   ```csv
   Old Property File, Latest Property File
   old-config/file1.properties, latest-config/file1.properties
   old-config/file2.properties, latest-config/file2.properties

## Notes

- Make sure you have the necessary permissions to clone the repositories and access the property files.
- Ensure that the required Git commands are available in your environment.
- The script assumes that the property files are in a key-value format with one property per line.
- The script skips lines that start with '#' and lines that do not contain '='.
- If a property file specified in the CSV mapping does not exist in either repository, it will be skipped.

-----
# Property File Updater

The Property File Updater is a script that automates the process of updating property files based on information provided in CSV files. It allows you to manage and prioritize property values, handle different versions of property files, and generate a manual configuration file for further customization.

This script updates property files in a given directory based on information provided in CSV files. It performs the following actions:

1. Reads a CSV file (`different_properties.csv`) containing information about different property values.
2. Reads two CSV files (`old-value-takes-priority.csv` and `latest-Value-takes-priority.csv`) to prioritize property values.
3. Compares non-matching combinations with `latest-Value-takes-priority.csv` and identifies similar latest values.
4. Creates a `manual-configuration.csv` file for further manual configuration.
5. Compares combinations from `different_properties.csv` with `old-value-takes-priority.csv` and `latest-Value-takes-priority.csv` to find unresolved combinations.
6. Updates the `manual-configuration.csv` file with unresolved combinations.
7. Reads `old_file_only.csv` and `intentionally_removed_in_lts.csv` files and compares the combinations.
8. Updates the `manual-configuration.csv` file with the new combinations.


## Prerequisites


- Python 3.x
- Required Python packages: `csv`

## Usage

1. Ensure that you have the required CSV files and the latest property files in the correct directories.
2. Open a terminal and navigate to the directory containing the script.
3. Run the script with the latest repository branch as a command-line argument:

   ```bash
   python property_file_updater.py <latest_repo_branch>

4. The script will update the property files and generate a log file (logs.txt) with the details of the update process.
5. It will also create or update the manual-configuration.csv file with unresolved combinations for further manual configuration.

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

## Notes

- It is highly recommended to create backups of your property files before running this script, as it modifies the files in place.
- The `manual-configuration.csv` file can be used to manually update the property files based on the required configuration actions mentioned in the file.

----
# Migrator script


This Bash script is designed to automate the process of comparing and updating configuration files based on a new set of configurations. It utilizes two Python scripts: `file_comparator.py` and `file_updater.py`.

## Prerequisites

Before running the script, ensure that you have the following:

- Python 3 installed
- The `file_comparator.py` and `file_updater.py` scripts available in the same directory as this Bash script.

## Usage

1. Clone this repository to your local machine.

2. Open a terminal and navigate to the directory where the script is located.

3. Run the script by executing the following command:

```shell
bash script.sh
