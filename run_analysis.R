# "run_analysis.R" is a script elaborate data gathered from the following link
# http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
# and does te following operations:
# 
# Merges the training and the test sets to create one data set,
# Extracts the measurements on the mean and standard deviation for each 
# measurement,
# Uses descriptive activity names to name the activities in the data set
# Labels the data set with descriptive variable names.
# From the data set in step 4, creates a second, independent tidy data set with 
# the average of each variable for each activity and each subject.

# Load the necessary libraries
library(dplyr)
library(data.table)


############# Setting up the data and lables first ############################
#                                                                            #
# Load in R the train and test datasets: 
# train_x are the measurements values used for training (70% of users),
# train_y are the labels for training_x used for testing (70% of users),
# test_x are the measurements values used for testing (30% of users),
# tets_y are the labels for evaluating the model during testing (30% of users),

train_x <- fread("ucihardataset/train/X_train.txt")
train_y <- fread("ucihardataset/train/Y_train.txt")

test_x <- fread("ucihardataset/test/X_test.txt")
test_y <- fread("ucihardataset/test/Y_test.txt")

# Load in R the activities lables ("activities"), subject numbers 
# ("subjecttrain" and "subjecttest") and features names ("features")
activities <- fread("ucihardataset/activity_labels.txt")
subjecttrain <- fread("ucihardataset/train/subject_train.txt")
subjecttest <- fread("ucihardataset/test/subject_test.txt")
features <- fread("ucihardataset/features.txt")

# Naming the activities column
names(activities) <- c("number", "activity")

# Re-edit activity names (lowering and eliminating underscors)
activities[,2] <- tolower(activities$activity)
activities$activity <- sub("_","",activities$activity)

# Naming the features column
setnames(features, old = c("V1","V2"), new = c("order", "feature"))

# Re-edit features names (lowering, eliminating underscors, dashes, parentesis)
features[,2] <- tolower(features$feature)
features$feature <- gsub("[^A-z0-9]","",features$feature)

# In the features set there are 84 duplicates that are the energy1-8 to 
# energy25-48 which are repeated 3 tymes for fbodyaccbands, 
# fbodyaccjerkbands, and fbodygyrobands. I assume that they are respectively
# the same for X, Y and Z axes, so I add these letters at the end of each
# group. In order to find the indexes for this repetition I used:
which(duplicated(features$feature) == TRUE)

# each duplicate set has 14 elements so:
features$feature[303:316] <- paste0(features$feature[303:316],"x")
features$feature[317:330] <- paste0(features$feature[317:330],"y")
features$feature[331:344] <- paste0(features$feature[331:344],"z")

features$feature[382:395] <- paste0(features$feature[382:395],"x")
features$feature[396:409] <- paste0(features$feature[396:409],"y")
features$feature[410:423] <- paste0(features$feature[410:423],"z")

features$feature[461:474] <- paste0(features$feature[461:474],"x")
features$feature[475:488] <- paste0(features$feature[475:488],"y")
features$feature[489:502] <- paste0(features$feature[489:502],"z")


# Naming the train and test column
train_colnames <- names(train_x)
test_colnames <- names(test_x)

# Re-edit train and test column names (lowering and eliminating underscors)
setnames(train_x, old = train_colnames, new = features$feature)
setnames(test_x, old = test_colnames, new = features$feature)

# Combine and naming the subject(test,train), train_y and tast_y column
subjects <- rbind(subjecttrain,subjecttest)
traintest <- rbind(train_y,test_y)
names(subjects) <- "subjects"
names(traintest) <- "labels"

# Formatting everithin as data.frame
train_x <- as.data.frame(train_x)
test_x <- as.data.frame(test_x)
traintest <- as.data.frame(traintest)
subjects <- as.data.frame(subjects)
activities <- as.data.frame(activities)

# Rename the lables with the corresponding activity
traintest$labels <- activities[traintest[1:length(traintest$labels),1],2]

# Remove from the global environment (therefore in RAM) all data no more useful
rm(list = c("train_colnames", "test_colnames", "subjecttest", "subjecttrain",
            "test_y","train_y"))

# Merging of the train and test datasets
traintestdata <- rbind(train_x, test_x)

# Adding two columns: activity and subject
traintestdata <- cbind(activity = traintest$labels, 
                       subject = subjects$subjects, traintestdata)

# Estracting the measurements on the mean and standard deviation 
# for each measurement 
variables <- grep("(mean|std)", names(traintestdata)) # find interested columns
meanstddata <- select(traintestdata, activity, subject, variables)

# From the meanstddata data set creates a second, independent tidy data 
# set with the average of each variable for each activity and each subject.

avgmeanstddata <- aggregate(meanstddata[,3:87], 
                            list(meanstddata$activity, meanstddata$subject), mean)
setnames(avgmeanstddata, old = names(avgmeanstddata), 
         new = c("activity","subject",paste0("avg",names(avgmeanstddata[,3:87]))))

# Remove all data from memory
rm(list = ls(pattern = "[^(avgmeanstddata)]"))
