# Property Comparator

The Property Comparator is a Python script that allows you to compare two properties files and generate CSV files to analyze the differences between them. It provides insights into properties with different values, properties present in the first file only, and properties present in the second file only.

# How it Works
* The script takes two property files as input.

* It reads and parses the contents of the property files, extracting key-value pairs.

* The script compares the properties from both files and identifies properties with different values, as well as properties that are unique to each file.

* It generates three CSV files:

    - different_properties.csv: Contains properties with different values between the two files.
    - properties_file1_only.csv: Contains properties present in the first file only.
    - properties_file2_only.csv: Contains properties present in the second file only.

* Each CSV file includes the corresponding properties along with their respective keys and values.

## Prerequisites

- Python 3.x

## Usage

1. Clone the repository or download the script file.

2. Open a terminal or command prompt and navigate to the directory containing the script.

3. Run the script using the following command:
```
./prop_comparator.py <file1> <file2>
```
Replace `<file1>` and `<file2>` with the paths to the property files you want to compare.
