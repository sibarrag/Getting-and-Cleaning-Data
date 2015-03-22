# Checking for required packages
if (!require("data.table")) {
  # Installing package
  install.packages("data.table")
}

# Reading data files
dataXTrain <- read.table("data/UCI HAR Dataset/train/X_train.txt")
dataXTest <- read.table("data/UCI HAR Dataset/test/X_test.txt")
dataSubjectTrain <- read.table("data/UCI HAR Dataset/train/subject_train.txt")
dataSubjectTest <- read.table("data/UCI HAR Dataset/test/subject_test.txt")
dataYTrain <- read.table("data/UCI HAR Dataset/train/y_train.txt")
dataYTest <- read.table("data/UCI HAR Dataset/test/y_test.txt")
dataFeatures <- read.table("data/UCI HAR Dataset/features.txt")
activityLabels <- read.table("data/UCI HAR Dataset/activity_labels.txt")

# Merging data
dataSubject <- rbind (dataSubjectTest,dataSubjectTrain)
dataX <- rbind (dataXTest, dataXTrain)
dataY <- rbind (dataYTest, dataYTrain)

# Naming the data columns
names(dataSubject) <- "id"
names(dataX) = dataFeatures[,2]
names(dataY) <- "activity"

# Getting mean & std measurements
dataX <- dataX[,grepl("mean\\(\\)", dataFeatures[,2]) | grepl("std\\(\\)", dataFeatures[,2])]

# Merging data
data <- cbind(dataSubject, dataY, dataX)

# Renaming colunm names
newColNames <- gsub("\\(\\)", "", names(data))
newColNames <- gsub("^t", "time", newColNames)
newColNames <- gsub("^f", "frequency", newColNames)
newColNames <- gsub("\\-std", "Std", newColNames)
newColNames <- gsub("\\-mean", "Mean", newColNames)
newColNames <- gsub("\\-", "", newColNames)

names(data) <- newColNames

# Creating activity
data$activity <- factor(data$activity, labels=tolower(activityLabels[,2]))

# Calculate averages
newData <- ddply(data, .(id, activity), numcolwise(mean))
write.table(newData, file="output.csv")


