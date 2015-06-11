#Step 1 : Merging the training and the test sets to create one data set.
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

#Step 2 :Extracting only the measurements on the mean and standard deviation for each measurement. 

# getting only columns with mean() or std() in their names
mean_stdfeatures <- grep("-(mean|std)\\(\\)", features[, 2])

xdata <- xdata[, mean_stdfeatures]
names(xdata) <- features[mean_stdfeatures, 2]#Names were not correct

#Step 3 : Using descriptive activity names to name the activities in the data set

activity <- read.table("activity_labels.txt")

# updating values with correct activity names with the help of merged ydata
ydata[, 1] <- activity[ydata[, 1], 2]

# correcting  column name and naming it "activity
names(ydata) <- "activity"

#STep 4 : Appropriately labeling the data set with descriptive variable names

names(subjectdata) <- "subject"
totalfile <- cbind(xdata, ydata, subjectdata)

#Step 5 : creating a second, independent tidy data set with the average of each variable for each activity and each subject.

#Using {plyr} package

library(plyr)
average <- ddply(totalfile, .(subject, activity), function(mean) colMeans(mean[, 1:66]))

#Using write.table() function
write.table(average, "average.txt", row.name=FALSE)

