# README - Structure and Design

-----

# Migrator script

The migrator script automates the process of comparing and updating property files between two different versions of configuration. During the upgrade process from version 2 (v2) to version 3 (v3), we identified that v2 version environments were utilizing the '1.1.5.5' configuration branch which is referred here as "old config", while v3 version environments are using the '1.2.0.1' branch which is referred here as "latest config", so here the script compares between an existing old configuration branch (v2) and a latest configuration branch (v3). It helps us ensure that configurations are updated while preserving any customizations made in the previous version. 

The script compares property files between two different versions of configuration, identifies the differences, and generates CSV files to summarize the results, then automates the process of updating property files based on information provided in knowledge base CSV files. It allows you to manage and prioritize property values, handle different versions of property files, and generate a manual configuration file for further customization.

This scripts provide a convenient way to automate the process of comparing and updating configuration files, saving time and reducing errors. It runs two Python scripts i,e: `file_comparator.py` and `file_updater.py`.

### Overview

When working with version-controlled branches, it's common to have different versions of property files that contain configuration settings. This script helps you compare property files between two different versions of configuration and provides insights into the differences between them. It is particularly useful when migrating from an old version of a config (v2) to a new version (v3), ensuring that important configuration settings are maintained and updated correctly.

It performs the following steps:
1. Cloning branches: It clones the old and latest config branches using Git, allowing you to specify the repository URLs and branch names.

2. Retrieving property file mapping: There is a CSV file (`property_file_mapping.csv`) that contains the mapping of property files between two different versions of config branch. Each row in the CSV file contains two columns: `Old Property File` and `Latest Property File`. The script reads this file to determine which property files should be compared.
   [ Update this `property_file_mapping.csv` only incase necessary or else you can use the default file itself ]   

3. Comparing property files: The script compares the property files specified in the CSV file pair by pair. It identifies properties with different values, properties that exist only in the old config, and properties that exist only in the latest config.

4. Generating output files: After comparing the property files, the script generates three CSV files in the `output` directory:
   - `different_properties.csv`: Contains the details of properties that have different values between the old and latest config.
   - `old_file_only.csv`: Contains the details of properties that exist only in the old config.
   - `latest_file_only.csv`: Contains the details of properties that exist only in the latest config.

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

   This file contains the properties which are present in both config version which we are comparing but the values of properties are different. Each row represents a different property, with columns indicating the old property file, latest property file, key, old value, and latest value.


2. **old_file_only.csv**:

   | Old Property File | Key | Old Value |
      |-------------------|-----|-----------|
   | file1.properties  | key1| value1    |
   | file1.properties  | key2| value2    |
   | ...               | ... | ...       |

   This file contains the properties that are only found in the old config version (v2). Each row represents a unique property, with columns indicating the old property file, key, and old value.


3. **latest_file_only.csv**:

   | Latest Property File | Key | Latest Value |
      |----------------------|-----|--------------|
   | file2.properties     | key3| value3       |
   | file2.properties     | key4| value4       |
   | ...                  | ... | ...          |

   This file contains the properties that are only found in the lts config version (v3). Each row represents a unique property, with columns indicating the latest property file, key, and latest value.


4. **old_value-takes-priority.csv**:

This is a knowledge base file which contains a list of property keys that necessitate older version values. It has the following structure:

| Property File Name | Key  |
|--------------------|------|
| file1.properties   | key1 |
| file2.properties   | key2 |
| ...                | ...  |

5. **latest_value-takes-priority.csv**:

This is a knowledge base file which contains a list of property keys that necessitate latest version values. It has the following structure:

| Property File Name | Key  |
|--------------------|------|
| file1.properties   | key1 |
| file2.properties   | key2 |
| ...                | ...  |

6. **intentionally_removed_in_lts.csv**:

This is a knowledge base file which contains a list of properties that were intentionally removed in the latest version. It has the following structure:

| Property File Name | Key  |
|--------------------|------|
| file1.properties   | key1 |
| file2.properties   | key2 |
| ...                | ...  |

7. **decent_default_value.csv**:

This is a knowledge base file which contains a list of properties which were recently added in the latest config version with decent-default. It has the following structure:

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

### Manual Configuration CSV

The script creates or updates the `manual-configuration.csv` file. This file includes unresolved combinations and combinations that require further manual configuration. You can use this file to manually update the property files based on the required configuration actions mentioned in the file.

Note:

- It is highly recommended to create backups of your property files before running this script, as it modifies the files in place.
- The `manual-configuration.csv` file can be used to manually update the property files based on the required configuration actions mentioned in the file.
