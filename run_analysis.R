## Getting and Cleaning Data Course Project
## Coursera course: getdata-008
## 
## This R script has been created as part of my course project submission to the getdata-008 coursera course.
## The script operates on the FUCI HAR dataset available (26 Oct 2014) at: 
##    https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 
##
## The script assumes the dataset is extracted and available in the current working directory and performs
## the following steps of operation:
##    1. Merges the training and the test sets to create one data set.
##    2. Extracts only the measurements on the mean and standard deviation for each measurement. 
##    3. Uses descriptive activity names to name the activities in the data set
##    4. Appropriately labels the data set with descriptive variable names. 
##    5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

library(plyr)

## Initialise column headers
activityID <- "activityID"
activity <- "activity"
subjectID <- "subjectID"

## Closure which runs the analysis steps.

runAnalysis <- function(outputFile="tidy.txt") {
  message(paste("Load dataset from ", getwd(), "/UCI HAR Dataset", sep=""))
  
  # Load activity labels
  activityLabels <<- readFile("./UCI HAR Dataset/activity_labels.txt", col.names=c(activityID,activity))
  
  # Load features
  features <<- readFile("./UCI HAR Dataset/features.txt")[,2]
  
  # Load the train and test datasets
  test <<- loadDataset("test")
  train <<- loadDataset("train")
  
  ## 1. Combine the dataset rows into a single dataset
  dataset <<- rbind(train,test)
  
  ## 2. Extract columns with mean & std in the name
  meanStdColumns <<- grep("mean|std",names(dataset),ignore.case=FALSE)
  meanStdDataset <<- cbind(dataset[,c(subjectID, activityID)], dataset[,meanStdColumns])
  
  ## 3. Use descriptive activity names to name the activities in the data set
  meanStdDataset<-merge(activityLabels,meanStdDataset,by.x=activityID,by.y=activityID,all=TRUE)

  ## 4. Improve feature headers
  colnames(meanStdDataset) <- gsub('-',"",colnames(meanStdDataset)) 
  colnames(meanStdDataset) <- gsub('\\(',"",colnames(meanStdDataset)) 
  colnames(meanStdDataset) <- gsub('\\)',"",colnames(meanStdDataset)) 
  colnames(meanStdDataset) <- gsub('mean',"Mean",colnames(meanStdDataset)) 
  colnames(meanStdDataset) <- gsub('std',"StandardDeviation",colnames(meanStdDataset))
  
  ## 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
  message("Splitting by subject & activity, computing average of mean and std columns")
  
  # Split by subjectID, activityID and for each subset of a data frame, apply mean column wise
  tidyDataset <<- ddply(meanStdDataset, c(subjectID,activity), numcolwise(mean))
  
  # Save results to file
  message(paste("Saving results to ", outputFile, sep=""))
  write.table(tidyDataset,outputFile)
  
  message("Output saved. ")
}

## Accepts as argument "test" or "train" and loads the corresponding dataset in a single data.frame

loadDataset <- function(dataset) {
  ## Initialise the file paths relative to their expected locations within the working directory
  xFile <- paste("./UCI HAR Dataset/",dataset,"/X_",dataset,".txt", sep = "")
  yFile <- paste("./UCI HAR Dataset/",dataset,"/Y_",dataset,".txt", sep = "")
  subjectFile <- paste("./UCI HAR Dataset/",dataset,"/subject_",dataset,".txt", sep = "")
  
  ## Load files into data frames and update column headers
  x <- readFile(xFile)
  colnames(x) <- features
  
  y <- readFile(yFile)
  colnames(y) <- activityID
  
  subject <- readFile(subjectFile)
  colnames(subject) <- subjectID
  
  ## Combine and return the data from the three files as single data frame
  cbind(subject,y,x)
}

## Checks if the specified file exists and notifies the user if it is missing from the working directory.

readFile <- function(file, ...) {
  ## Check if file exists first
  if(!file.exists(file)) {
    msg <- paste("File",file,"does not exist in working directory:", getwd())
    message(msg)
    message("You may use download.getdata008() to download and extract the dataset in the current working directory.")
    stop(msg)
  }
   
  ## Load space delimeted file and report number of rows
  data <- read.table(file,...)
  message(paste("Loaded", nrow(data), " rows from", file, sep=" "))
  
  data
}

download.getdata008 <- function() {
  fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  destZipFile <- "FUCI HAR dataset.zip"
  
  message(paste("Downloading dataset from", fileUrl, sep = " "))
  system.time(download.file(fileUrl, destfile = destZipFile))
  
  message("Extracting dataset...")
  system.time(unzip(destZipFile))
  
  message("Done.")
  list.files(path = "./UCI HAR Dataset")
}

## Automatically run the analysis on loading the script and clear internal function declarations
runAnalysis()
rm(readFile)
rm(loadDataset)