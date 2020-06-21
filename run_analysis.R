#1.Merges the training and the test sets to create one data set.

x_train <- read.table("UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt")
x_test <- read.table("UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt")

traindata <- cbind(subject_train,y_train,x_train)
testdata <- cbind(subject_test,y_test,x_test)
alldata <- rbind(traindata,testdata)

#2.Extracts only the measurements on the mean and standard deviation for each measurement.

feature <- read.table("UCI HAR Dataset/features.txt")
featurename <- grep("mean\\()|std\\()",feature[,2])
alldata_mean_std <- alldata[, c(1, 2, featurename+2)]
colnames(alldata_mean_std) <- c("subject", "activity", feature[featurename,2])

#3.Uses descriptive activity names to name the activities in the data set.

activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt")
alldata_mean_std$activity <- factor(alldata_mean_std$activity, levels = activity_labels[,1], labels = activity_labels[,2])

#4.Appropriately labels the data set with descriptive variable names.

names(alldata_mean_std) <- gsub("^t", "Time", names(alldata_mean_std))
names(alldata_mean_std) <- gsub("^f", "Frequence", names(alldata_mean_std))
names(alldata_mean_std) <- gsub("mean", "Mean", names(alldata_mean_std))
names(alldata_mean_std) <- gsub("std", "Std", names(alldata_mean_std))

#5.From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

library(dplyr)
seconddata <- group_by(alldata_mean_std, subject,activity)
seconddata <- summarise_each(seconddata,mean)

write.table(seconddata,"seconddata.txt",row.name=FALSE)

