#Getting and Cleaning Data Course Project

## About course project
 This R script has been created as part of my course project submission to the getdata-008 coursera course.
 The script operates on the FUCI HAR dataset available (26 Oct 2014) at: 
 
 https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

 The script assumes the dataset is extracted and available in the current working directory and performs
 the following steps of operation:
1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement. 
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names. 
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
	
## Requirements
1. Plyr package
The package can be installed using ``install.packages("plyr")``

## Usage
* 'run_analysis.R' must be placed in the working directory along with the dataset directory 'UCI HAR Dataset'. If the dataset is missing the script will offer an option to download it.
* ``source('run_analysis.R')`` will automatically run the analysis script and produce ``tidy.txt`` as an output file.





