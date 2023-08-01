# README - Structure and Design

-----

# Migrator script

This script automates the process of comparing and updating configurations between an existing old configuration repository and a new based configuration repository. It helps ensure that the latest configurations are applied while preserving any customizations made in the old repository. 

The script compares property files between an old repository and a latest repository, identifies the differences, and generates CSV files to summarize the results, then automates the process of updating property files based on information provided in knowledge base CSV files. It allows you to manage and prioritize property values, handle different versions of property files, and generate a manual configuration file for further customization.

This scripts provide a convenient way to automate the process of comparing and updating configuration files, saving time and reducing errors. It runs two Python scripts i,e: `file_comparator.py` and `file_updater.py`.

### Overview

When working with version-controlled repositories, it's common to have different versions of property files that contain configuration settings. This script helps you compare property files between two repositories (old and latest) and provides insights into the differences between them. It is particularly useful when migrating from an old version of a repository to a new version, ensuring that important configuration settings are maintained and updated correctly.

It performs the following steps:
1. Cloning repositories: It clones the old and latest repositories using Git, allowing you to specify the repository URLs and branch names.

2. Retrieving property file mapping: There is a CSV file (`property_file_mapping.csv`) that contains the mapping of property files between the old and latest repositories. Each row in the CSV file contains two columns: `Old Property File` and `Latest Property File`. The script reads this file to determine which property files should be compared.
   [ Update this `property_file_mapping.csv` only incase necessary ]   

3. Comparing property files: The script compares the property files specified in the CSV file pair by pair. It identifies properties with different values, properties that exist only in the old repository, and properties that exist only in the latest repository.

4. Generating output files: After comparing the property files, the script generates three CSV files in the `output` directory:
   - `different_properties.csv`: Contains the details of properties that have different values between the old and latest repositories.
   - `old_file_only.csv`: Contains the details of properties that exist only in the old repository.
   - `latest_file_only.csv`: Contains the details of properties that exist only in the latest repository.

5. Then reads the CSV file (`different_properties.csv`) containing information about different property values. 

6. Then reads two CSV files (`old-value-takes-priority.csv` and `latest-Value-takes-priority.csv`) to prioritize property values, first it reads key from different-values.csv and check if the same is present in old-value-takes-priority.csv and if the key is present then it updates the value corresponding to that key to latest directory from `Old Value` column of different-values.csv file.
    
7. Compares non-matching combinations with `latest-Value-takes-priority.csv` and identifies similar latest values.
8. Creates a `manual-configuration.csv` file and for keys of `different_properties.csv` which are not present in both `old-value-takes-priority.csv` and `latest-Value-takes-priority.csv` will be moved to `manual-configuration.csv` with comment `update-if-old-value-takes-priority` for further manual configuration.
9. Then reads keys from `old_file_only.csv` and checks if the same keys are present in `intentionally-removed-in-lts.csv` file and for those keys which are not present will be moved to `manual-configuration.csv` with comment `copy-property-if-required-in-lts` by appending the existing content for further manual configuration.
10. Then reads keys from `latest_file_only.csv` and checks if the same keys are present in `new-property-with-decent-default-value.csv` file and for those keys which are not present will be moved to `manual-configuration.csv` with comment `update-if-value-needs-change` by appending the existing content for further manual configuration.

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


4. **old_value-takes-priority.csv**:

This file prioritizes the old property values over the latest ones. It has the following structure:

| Property File Name | Key  |
|--------------------|------|
| file1.properties   | key1 |
| file2.properties   | key2 |
| ...                | ...  |

5. **latest_value-takes-priority.csv**:

This file prioritizes the latest property values over the old ones. It has the following structure:

| Property File Name | Key  |
|--------------------|------|
| file1.properties   | key1 |
| file2.properties   | key2 |
| ...                | ...  |

6. **intentionally_removed_in_lts.csv**:

This file contains property combinations that were intentionally removed in the latest version. It has the following structure:

| Property File Name | Key  |
|--------------------|------|
| file1.properties   | key1 |
| file2.properties   | key2 |
| ...                | ...  |

7. **decent_default_value.csv**:

This file contains information about decent default property values for the latest property files. It has the following structure:

| Property File Name | Key  | Latest Value |
|--------------------|------|--------------|
| file1.properties   | key1 | value1       |
| file2.properties   | key2 | value2       |
| ...                | ...  | ...          |

8. **manual-configuration.csv**:

This file is created or updated by the script and includes unresolved combinations and combinations that require further manual configuration. It has the following structure:

| Property File Name | Key  | Old Value | Latest Value | Configuration Action |
|--------------------|------|-----------|--------------|---------------------|
| file1.properties   | key1 | value1    | value2       | update-if-required  |
| file2.properties   | key2 | value3    | value4       | copy-property       |
| ...                | ...  | ...       | ...          | ...                 |

Note: The CSV file structure allows for easy analysis and comparison of the different properties between the repositories, as well as identifying unique properties specific to each repository.

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
The "Configuration Action" column includes comments that guide developers on how to handle specific combinations of properties during updates. The following comments are used in the file:

#### 1. update-if-old-value-takes-priority:

Description:
This comment suggests that in the specific combination of properties, the value from the old version of config should take priority over the value in the latest version. In other words, the old value is considered more important or appropriate for the current context.

Action:
Developers should manually update the property file in the latest version and set the property value to the old value indicated in the "Old Value" column of the CSV file. This will ensure that the desired configuration from the old version is preserved in the updated config branch.

Use Case:
This comment is useful when a property in the latest version has been changed, but the older value is still relevant for compatibility, stability, or other reasons. By updating the property file manually, developers can maintain expected behavior in the updated version.

#### 2. copy-property-if-required-in-lts:

Description:
This comment indicates that a specific property is required in the latest(LTS) version of the config branch, but it is missing from the latest version.

Action:
Developers should manually add the property along with its old value to the property file in the latest version of the config branch. This ensures that the required property is present in the LTS version, even if it was not part of the latest version's configuration.

Use Case:
Some properties might be essential for the LTS version due to backward compatibility or other critical reasons. The comment helps developers identify and copy such properties from the old version to the latest version, ensuring their availability in the latest config branch.

#### 4. update-if-value-needs-change:

Description:
This comment advises developers to update the property's value in the latest version if a change is necessary. It implies that the latest value may not be suitable, and developers should determine the appropriate value for the property.

Action:
Developers should manually review and update the property value in the latest version's property file based on the requirements and update the new value which is suitable for latest config. This ensures that the required property is present in the LTS version.

#### Use Case:
This comment is used when the property value in the latest version is no longer optimal or may not provide the desired behavior in the updated version of config. By manually updating the value, developers can ensure that the configuration aligns with the changes in the latest config branch.

#### Purpose:
* The "manual-configuration.csv" file is used as a tool to handle property updates that cannot be automatically resolved during the config version update process. It helps developers keep track of specific combinations that require their attention and provides clear instructions on how to handle each case.

* The script will populate the "manual-configuration.csv" file with unresolved combinations and relevant comments, guiding developers on how to handle each case.

* Developers can review the "manual-configuration.csv" file and follow the instructions for manual updates to the property files in the latest config branch.

* After making the necessary manual changes, ensure to update the property files in the latest version of the config based on the guidance provided in the "manual-configuration.csv" file.

* Remember that careful review and validation of the CSV files and the resulting manual updates are essential to ensure the correctness and consistency of the  configuration. Always keep backups of the original property files and use version control systems to track changes during the update process.

Note:

- It is highly recommended to create backups of your property files before running this script, as it modifies the files in place.
- The `manual-configuration.csv` file can be used to manually update the property files based on the required configuration actions mentioned in the file.

----
