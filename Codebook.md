#Codebook For Getting and Cleaning Data Project


( I don't know how people will be able to make this .md file, if they haven't studied Reproducible Research(about Knitr))

##Introduction

- THe Site Which I used :
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 

- Data's Link :
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

You should create one R script called run_analysis.R that does the following.   
Merges the training and the test sets to create one data set.  
Extracts only the measurements on the mean and standard deviation for each measurement.   
Uses descriptive activity names to name the activities in the data set  
Appropriately labels the data set with descriptive variable names.   
From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.  

##The Information which I have Extracted from the Site

The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data.

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain.

##Variables

- x_train, y_train, x_test, y_test, subject_train and subject_test contain the data from the downloaded files.  
- x_data, y_data and subject_data merge the previous datasets to further analysis.
- features contains the correct names for the x_data dataset, which are applied to the column names stored in mean_and_std_features, a numeric vector used to extract the desired data.
- A similar approach is taken with activity names through the activities variable.
- all_data merges x_data, y_data and subject_data in a big dataset.
- Finally, averages_data contains the relevant averages which will be later stored in a .txt file. ddply() from the plyr package is used to apply colMeans() and ease the development.

###Step 1 : Merging the training and the test sets to create one data set.
```{r step1}

setwd("~/Getting&CleaningData")
unzip("getdata-projectfiles-UCI HAR Dataset.zip") #Unzipping and Changing the working directory
setwd("~/Getting&CleaningData/UCI HAR Dataset")

features <- read.table("features.txt")

xtrain <- read.table("./train/X_train.txt")
ytrain <- read.table("./train/y_train.txt")
subjecttrain <- read.table("./train/subject_train.txt")

xtest <- read.table("./test/X_test.txt")
ytest <- read.table("./test/y_test.txt")
subjecttest <- read.table("./test/subject_test.txt")


# merging xtrain and xtest
xdata <- rbind(xtrain, xtest)

# merging ytrain and ytest
ydata <- rbind(ytrain, ytest)

# merging subjecttrain and subjecttest
subjectdata <- rbind(subjecttrain, subjecttest)
```

###Step 2 :Extracting only the measurements on the mean and standard deviation for each measurement. 

```{r step2}
# getting only columns with mean() or std() in their names
mean_stdfeatures <- grep("-(mean|std)\\(\\)", features[, 2])

xdata <- xdata[, mean_stdfeatures]
names(xdata) <- features[mean_stdfeatures, 2]#Names were not correct
```

###Step 3 : Using descriptive activity names to name the activities in the data set

```{r step3}
activity <- read.table("activity_labels.txt")

# updating values with correct activity names with the help of merged ydata
ydata[, 1] <- activity[ydata[, 1], 2]

# correcting  column name and naming it "activity
names(ydata) <- "activity"
```

###Step 4 : Appropriately labeling the data set with descriptive variable names

```{r step4}
names(subjectdata) <- "subject"
totalfile <- cbind(xdata, ydata, subjectdata)
```

###Step 5 : creating a second, independent tidy data set with the average of each variable for each activity and each subject.

```{r step5}
#Using {plyr} package

library(plyr)
average <- ddply(totalfile, .(subject, activity), function(mean) colMeans(mean[, 1:66]))

#Using write.table() function
write.table(average, "average.txt", row.name=FALSE)
```
