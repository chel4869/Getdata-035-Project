library(reshape2)
# find the measurements on the mean and standard deviation
# and also extract the needed feature names
features <- read.table("features.txt")
featuresNeeded <- grep(".*mean.*|.*std.*", features[,2])
featureNames <- features[featuresNeeded, 2]
featureNames <- gsub('-mean', 'Mean', featureNames)
featureNames <- gsub('-std', 'Std', featureNames)
featureNames <- gsub('[-()]', '', featureNames)

# load the data
train <- read.table("./train/X_train.txt")[featuresNeeded]
subject_train <- read.table("./train/subject_train.txt")
y_train <- read.table("./train/y_train.txt")
traindata <- cbind(subject_train, y_train, train)

test <- read.table("./test/X_test.txt")[featuresNeeded]
subject_test <- read.table("./test/subject_test.txt")
y_test <- read.table("./test/y_test.txt")
testdata <- cbind(subject_test, y_test, test)

# combine train and test dataset and rename the variables
data <- rbind(traindata, testdata)
colnames(data) <- c("Subject", "Activities", featureNames)

# data set with the average of each variable for each activity and each subject
# first change the Subject and Adtivities variables into factors
activitylabels <- read.table("activity_labels.txt")
data$Subject <- as.factor(data$Subject)
data$Activities <- factor(data$Activities, labels = activitylabels[,2], levels = activitylabels[,1])

data.melted <- melt(data, id = c("Subject", "Activities"))
data.mean <- dcast(data.melted, Subject + Activities ~ variable, mean)

# save the tidy data
write.table(data.mean, "data.txt", row.names = FALSE, quote = FALSE)
