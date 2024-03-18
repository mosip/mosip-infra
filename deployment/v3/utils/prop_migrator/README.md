# Migrator script

The script compares property files between old config branch and the latest config branch, identifies the differences, and generates CSV files to summarize the results, then automates the process of updating property files based on information provided in knowledge base CSV files. It allows you to manage and prioritize property values, handle different versions of property files, and generate a manual configuration file for further customization.

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
   bash migrator.sh

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

The Migrator script generates the following output:

### Updated Property Files

This section lists the property files that were updated during the process. It includes the names of the files and the keys that were modified.

### Logs

The script generates a log file (`logs.txt`) that provides detailed information about the update process. It includes information about matching combinations, unresolved combinations, similar latest values, and more. The log file helps you understand the changes made to the property files and allows you to review the update process.

### Manual Configuration CSV File - "manual-configuration.csv"

The script creates or updates the `manual-configuration.csv` file. This file includes unresolved combinations and combinations that require further manual configuration. You can use this file to manually update the property files based on the required configuration actions mentioned in the file.

The "manual-configuration.csv" file is a CSV (Comma-Separated Values) file that serves as a configuration guide for updating property files in the latest config branch. It contains information about specific combinations of properties found in different versions of config, where automatic resolution is not possible, and manual intervention is required.

#### File Format :-
The file has the following columns:

* Property file name: The name of the property file where the property is defined.
* Key: The key (or property name) that identifies the property.
* Old Value: The value of the property in the old version of config.
* Latest Value: The value of the property in the latest version of config.
* Configuration Action: A comment indicating the required manual action for the property.
  
#### Comments Used in Configuration Action:
The "Configuration Action" column includes comments that guide users on how to handle specific combinations of properties during updates. The following comments are used in the file:

#### 1. update-if-old-value-takes-priority:

Description:
This comment suggest that we have the same property in both old and the latest property files with different values, as a default behaviour utility has retained the latest property file value. If the old property file value is considered more appropriate, please manually update the same.

Action:
Users should manually update the property file value in the latest version and set the property value to the old value indicated in the "Old Value" column of the CSV file only if old property file value is considered more appropriate. This will ensure that the desired configuration from the old version is preserved in the updated config branch.

Use Case:
This comment is useful when a property in the latest version has been changed, but the older value is still relevant for compatibility, stability, or other reasons. By updating the property file manually, users can maintain expected behavior in the updated version.

#### 2. copy-property-if-required-in-lts:

Description:
This comment suggest that we have properties which are present only in old property files and not in latest property files, so the users need to go through these properties and check if these properties are needed in latest property files and if needed, please manually update the same.

Action:
Users should manually add the property along with its old value to the property file in the latest version of the config branch. This ensures that the required property is present in the LTS version, even if it was not part of the latest version's configuration.

Use Case:
Some properties might be essential for the LTS version due to backward compatibility of customized code. The comment helps users identify and copy such properties from the old version to the latest version, ensuring their availability in the latest config branch.

#### 3. update-if-value-needs-change:

Description:
This comment suggest that we have properties which are present only in latest property files and not in old property files because there might me some properties which are recently added, so the users need to go through these properties and check the default values given in the latest property files and check if these property values needs changes if so, please manually update the same. 

This comment advises users to update the properties in the latest version if the default property values needs an update. It implies that the latest property values may not be suitable or required, and users should determine whether the default value needs a change in the latest version.

Action:
Users should manually review and if necessary update the property value in the latest version's property file based on the requirements which are suitable for latest config. This ensures that the properties are reviewed and updated with appropriate values in the LTS version.

#### Use Case:
This comment is used when the properties which are present in the latest property files may not provide the desired behavior in the updated version of config. By manually updating these properties along with its desired value, users can ensure that the configuration aligns with the changes in the latest config branch.

#### Purpose:
* The "manual-configuration.csv" file is used as a tool to handle property updates that cannot be automatically resolved during the config version update process. It helps users keep track of specific combinations that require their attention and provides clear instructions on how to handle each case.

* The script will populate the "manual-configuration.csv" file with unresolved combinations and relevant comments, guiding users on how to handle each case.

* Users can review the "manual-configuration.csv" file and follow the instructions for manual updates to the property files in the latest config branch.

* After making the necessary manual changes, please commit the changes to the latest config branch.

* Remember that careful review and validation of the CSV files and the resulting manual updates are essential to ensure the correctness and consistency of the  configuration. Always keep backups of the original property files and use version control systems to track changes during the update process.

Note:

- It is highly recommended to create backups of your property files before running this script, as it modifies the files in place.
- The `manual-configuration.csv` file can be used to manually update the property files based on the required configuration actions mentioned in the file.

----

