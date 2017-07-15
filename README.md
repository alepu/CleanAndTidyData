# CleanAndTidyData
Getting and Cleaning Data Course Project Assignment


"run_analysis.R" is a script that elaborates data gathered from the following link:
 http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
 and does the following operations:
 
* Merges the training and the test sets to create one data set,
* Extracts the measurements on the mean and standard deviation for each measurement,
* Uses descriptive activity names to name the activities in the data set
* Labels the data set with descriptive variable names.
* From the data set in step 4, creates a second, independent tidy data set with 
* the average of each variable for each activity and each subject.

More in details the operations performed by the scripts are

###Load in R the train and test datasets: 
train_x are the measurements values used for training (70% of users),
train_y are the labels for training_x used for testing (70% of users),
test_x are the measurements values used for testing (30% of users),
tets_y are the labels for evaluating the model during testing (30% of users),

### Load in R the activities lables ("activities"), subject numbers 
### ("subjecttrain" and "subjecttest") and features names ("features")

### Re-edits activity names 
It lowers all names and remove from them any caracter different from
letters and numbers

### Re-edits the features names 
It lowers all names and remove from them any caracter different from
letters and numbers

Note: 
in the features set there are 84 duplicates that are the energy1-8 to 
energy25-48 which are repeated 3 tymes for fbodyaccbands, 
fbodyaccjerkbands, and fbodygyrobands. I assume that they are respectively
the same for X, Y and Z axes, so I add these letters at the end of each
group. 


### Re-edits train and test column names
Re-edits the names of X_train and X_test with the feaures names

### Combines and naming the subject(train, test), and labels (Y_train, Y_tast)
Combines in one data.frame, "subjects" the two sets of subjects, "subjects_train" and
"subjects_test", and in one data.frame, "trainset", the two set of labels "Y_train"
and "Y_test"

### Renames the lables with the corresponding activity
Renames the lables in "trainset" with the corresponding names of activities from
"activities"

### Cleans the memory from temporary data no more useful

### Merges train and test datasets and add activity and subject columns
Mearge by rows the two data.frames, "train_x and "test_x", in one "traintestdata"
and then add as first colums "activity" and "subject" respectively

### Estracts the measurements on the mean and standard deviation 
Extracts in a new data.frame, "meanstddata", the measurements on the mean and
standard deviation for each measurements

### Creates a second, independent tidy data set
Creates a new indipendent data.frame, "avgmeanstddata", based on the previous one
with the the average of each variable for each activity and each subject, and ordered
frist with activity and then per subject.

### Clean all unnecessary data from memory

