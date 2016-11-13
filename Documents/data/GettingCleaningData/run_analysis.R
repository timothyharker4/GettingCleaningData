
### Load Necessary Data files in to R

X_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
Y_test <- read.table("./UCI HAR Dataset/test/Y_test.txt")
X_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
Y_train <- read.table("./UCI HAR Dataset/train/Y_train.txt")
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")
features <- read.table("./UCI HAR Dataset/features.txt")

### Combine testing and training subject data and name variable
Subjects <- rbind(subject_test,subject_train)
colnames(Subjects) <- "Subject"

### Combine testing and training X data and name variables 
X <- rbind(X_test, X_train)
colnames(X) <- features$V2

### Combine testing and training Y Data
Y <- rbind(Y_test, Y_train)

### Replace numbered data with appropriate Activity names
i = 1
for (i in 1:6) {
      Y <- as.data.frame(sub(i, activity_labels[i,2], Y[[1]]))
}

### Name Y data variable
colnames(Y) <- "Activity"


### Combine Subject, X, and Y data and filter out columns not related to means
### or standard deviations
Merged_Data <- cbind(Subjects, Y, X[grepl("mean..$|mean...[XxYyZz]$|std...[XxYyZz]$", names(X))])

### Clean up variable names
colnames(Merged_Data) <- gsub("-", "", names(Merged_Data))
colnames(Merged_Data) <- gsub("[()]", "", names(Merged_Data))
colnames(Merged_Data) <- gsub("std", "Std", names(Merged_Data))
colnames(Merged_Data) <- gsub("mean", "Mean", names(Merged_Data))

### Reshape merged data into tall, skinny table
library(reshape2)
indexmelt <- melt(Merged_Data, id=c("Subject","Activity"))

### Format table by Subject + Activity while recording the mean of all variables
index <- dcast(indexmelt, Subject + Activity ~ variable, mean)

### Write tidy data set to file
write.table(index, file = "./UCI HAR Dataset/tidy.txt", row.names = FALSE)