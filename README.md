# Week 4 Assignment
Using the data provided in the assignment, with an unchanged file structure, the code file run_analysis.R reads in, tidys and summarises information on a sample of 30 peoples activity data.

But what data is analysed?

##The Data Used

There are 8 files read in by the code:

* X_train.txt - a large dataset containing multiple columns for each person and activity (numeric, ranging 1-30)
* y_train.txt - a list of the activities for each row, as numeric values ranging 1-6
* subject_train.txt - a list numbers, corresponding to the people involved
* X_test.txt - a large dataset containing multiple columns for each person and activity in the test
* y_test.txt - a list of the activities for each row in the test
* subject_test.txt - a list numbers, corresponding to the people involved in the test
* features.txt - a list of the measurement values (these are the column names for X_train nd X_test
* activity_labels.txt - a small file with the encoding of the activities used.

##The Analysis

The code is fully commented through, explaining the key steps and lines - how they relate to the required steps for the assignment.

The code:
* Combines the data
* Assigns appropriate column names
* Equates the activity name to the numeric character given
* Summarises the data, providing the average value for eaach person and activity
