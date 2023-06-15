# Repository Property File Comparator

This script compares property files between an old repository and a latest repository, identifies the differences, and generates CSV files to summarize the results.

## Prerequisites

Before running the script, ensure that you have the following prerequisites:

- Python 3 installed: The script is written in Python, so you need Python 3 installed on your system.
- Git command-line tool installed: The script uses Git commands to clone the repositories. Make sure Git is installed and available in your command-line environment.
  * Make sure Git is installed and available in your command-line environment. You can download Git from the official Git website: [https://git-scm.com](https://git-scm.com).
  * To check if Git is installed, open a command prompt or terminal window and run the following command:
   ```shell
   git --version

## Usage

To use the script, follow these steps:

1. Clone or download the code from this repository.

2. Open a terminal or command prompt and navigate to the directory where the code is located.

3. Install the required Python dependencies by running the following command:

   ```shell
   pip install -r requirements.txt

4. Cross-check the CSV file containing the mapping of property files:

    - CSV file named `property_file_mapping.csv`.
    - Each row in the CSV file should contain two columns: `Old Property File` and `Latest Property File`.
    - Provide the relative paths of the property files in the old and latest repositories. ( if not present )

   Example:

   ```csv
   Old Property File, Latest Property File
   old-config/file1.properties, latest-config/file1.properties
   old-config/file2.properties, latest-config/file2.properties

5. To run the `file_comparator.py` script, execute the following command, replacing the placeholder values with the actual values or variables you want to pass as arguments:
   ```bash
   python3 file_comparator.py "$old_repo_url" "$old_repo_branch" "$latest_repo_url" "$latest_repo_branch"

   * $old_repo_url: The URL of the old repository.
   * $old_repo_branch: The branch name or commit hash of the old repository.
   * $latest_repo_url: The URL of the latest repository.
   * $latest_repo_branch: The branch name or commit hash of the latest repository.

Note:

- Make sure you have the necessary permissions to clone the repositories and access the property files.
- Ensure that the required Git commands are available in your environment.
- The script will compare the files between the old and latest repositories based on the provided arguments.
- The script assumes that the property files are in a key-value format with one property per line.
- The script skips lines that start with '#' and lines that do not contain '='.
- If a property file specified in the CSV mapping does not exist in either repository, it will be skipped.

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
