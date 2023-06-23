# Migrator script

The script compares property files between an old repository and a latest repository, identifies the differences, and generates CSV files to summarize the results, then automates the process of updating property files based on information provided in knowledge base CSV files. It allows you to manage and prioritize property values, handle different versions of property files, and generate a manual configuration file for further customization.

This Bash script is designed to automate the process of comparing and updating configuration files based on a new set of configurations. It utilizes two Python scripts: `file_comparator.py` and `file_updater.py`.

## Prerequisites

Before running the script, ensure that you have the following:

- Python 3 installed: The script is written in Python, so you need Python 3 installed on your system.
- Required Python packages: `csv`
- Git command-line tool installed: The script uses Git commands to clone the repositories. Make sure Git is installed and available in your command-line environment.
    * Make sure Git of version(2.25.1) is installed and available in your command-line environment. You can download Git from the official Git website: [https://git-scm.com](https://git-scm.com).
    * To check if Git is installed, open a command prompt or terminal window and run the following command:
   ```shell
   git --version
- The `file_comparator.py` and `file_updater.py` scripts available in the same directory as this Bash script.
- The `knowledge` directory which contains knowledge base csv files available in the same directory as Bash script.

## Usage

1. Clone this repository to your local machine.

2. Open a terminal and navigate to the directory where the script is located.

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

5. Run the script by executing the following command:

   ```shell
   bash script.sh

6. The script will update the property files and generate a log file (logs.txt) with the details of the update process.

7. It will also create or update the manual-configuration.csv file with unresolved combinations for further manual configuration.


Note:

- Make sure you have the necessary permissions to clone the repositories and access the property files.
- Ensure that the required Git commands are available in your environment.
- The script will compare the files between the old and latest repositories based on the provided arguments.
- The script assumes that the property files are in a key-value format with one property per line.
- The script skips lines that start with '#' and lines that do not contain '='.
- If a property file specified in the CSV mapping does not exist in either repository, it will be skipped.
- It is highly recommended to create backups of your property files before running this script, as it modifies the files in place.
- The `manual-configuration.csv` file can be used to manually update the property files based on the required configuration actions mentioned in the file.

----

## Output

The Property File Updater generates the following output:

### Updated Property Files

This section lists the property files that were updated during the process. It includes the names of the files and the keys that were modified.

### Logs

The script generates a log file (`logs.txt`) that provides detailed information about the update process. It includes information about matching combinations, unresolved combinations, similar latest values, and more. The log file helps you understand the changes made to the property files and allows you to review the update process.

### Manual Configuration CSV

The script creates or updates the `manual-configuration.csv` file. This file includes unresolved combinations and combinations that require further manual configuration. You can use this file to manually update the property files based on the required configuration actions mentioned in the file.
