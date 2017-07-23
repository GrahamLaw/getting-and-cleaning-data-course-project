install.packages("dplyr")
library(dplyr)

# FEATURES - Load and filter
features <- read.table("features.txt")
filteredfeatures <- features[grep("mean\\(\\)|std()", features$V2), 1]

#Y DATA
train_y <- read.table("train/y_train.txt")
test_y <- read.table("test/y_test.txt")
names(train_y)[1] <- "ActivityID"
names(test_y)[1] <- "ActivityID"

#X DATA
train_x <- read.table("train/x_train.txt")
test_x <- read.table("test/x_test.txt")
colnames(train_x) <-  features$V2
colnames(test_x) <-  features$V2

#ACTIVITIES
activityLabels <- read.table("activity_labels.txt")
colnames(activityLabels) <-  c("ID", "Activity")


#SUBJECTS
subjecttest <- read.table("test/subject_test.txt")
subjecttrain <- read.table("train/subject_train.txt")
names(subjecttest)[1] <- "Subject"
names(subjecttrain)[1] <- "Subject"




#Clip & Filter data for required columns 
trainfiltered <- cbind( train_y, subjecttrain, train_x[, filteredfeatures] )
testfiltered <- cbind( test_y, subjecttest, test_x[, filteredfeatures] )


#Merge activities
finaltrain <- merge(activityLabels, trainfiltered,  by.x="ID", by.y="ActivityID")
finaltrain <- subset(finaltrain, select=-c(ID))


#Merge activities
finaltest <- merge(activityLabels, testfiltered,  by.x="ID", by.y="ActivityID")
finaltest <- subset(finaltest, select=-c(ID))



combinedsets <- rbind(finaltrain, finaltest)



result <- aggregate(combinedsets[, 3:68], by=list("Activity" = x$Activity, "Subject"=x$Subject), mean)
