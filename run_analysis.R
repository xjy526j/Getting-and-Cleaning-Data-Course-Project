library(dplyr)

# download data
fileurl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileurl, destfile = "./data/dataset.zip", method = "curl")
unzip(zipfile="./data/dataset.zip",exdir="./data")

# read data
features <- read.table('./data/UCI HAR Dataset/features.txt', col.names = c("n","functions"))
activities = read.table('./data/UCI HAR Dataset/activity_labels.txt', col.names = c("code", "activity"))
x_train <- read.table("./data/UCI HAR Dataset/train/X_train.txt", col.names = features$functions)
y_train <- read.table("./data/UCI HAR Dataset/train/y_train.txt", col.names = "code")
subject_train <- read.table("./data/UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
x_test <- read.table("./data/UCI HAR Dataset/test/X_test.txt", col.names = features$functions)
y_test <- read.table("./data/UCI HAR Dataset/test/y_test.txt",  col.names = "code")
subject_test <- read.table("./data/UCI HAR Dataset/test/subject_test.txt", col.names = "subject")


# Merges the training and the test sets to create one data set
x <- rbind(x_train, x_test)
y <- rbind(y_train, y_test)
subject <- rbind(subject_train, subject_test)
mergeddata <- cbind(subject, y, x)

# Extracts only the measurements on the mean and standard deviation for each measurement
d <- mergeddata %>% select(subject, code, contains("mean"), contains("std"))

# Uses descriptive activity names to name the activities in the data set
d$code <- activities[d$code, 2]

# Appropriately labels the data set with descriptive variable names
names(d)[2] = "activity"
names(d)<-gsub("Acc", "Accelerometer", names(d))
names(d)<-gsub("Gyro", "Gyroscope", names(d))
names(d)<-gsub("BodyBody", "Body", names(d))
names(d)<-gsub("Mag", "Magnitude", names(d))
names(d)<-gsub("^t", "Time", names(d))
names(d)<-gsub("^f", "Frequency", names(d))
names(d)<-gsub("tBody", "TimeBody", names(d))
names(d)<-gsub("-mean()", "Mean", names(d), ignore.case = TRUE)
names(d)<-gsub("-std()", "STD", names(d), ignore.case = TRUE)
names(d)<-gsub("-freq()", "Frequency", names(d), ignore.case = TRUE)
names(d)<-gsub("angle", "Angle", names(d))
names(d)<-gsub("gravity", "Gravity", names(d))

# From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject
Data <- aggregate(. ~subject + activity, d, mean)
Data <- Data[order(Data$subject,Data$activity),]
write.table(Data, file = "result.txt",row.name=FALSE)