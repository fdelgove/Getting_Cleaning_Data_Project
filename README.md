Getting and Cleaning Data Project 
=================================

This document is a description of the script **run_analysis.R**  
The objectives of the script are :
*  Merges the training and the test sets to create one data set.
*  Extracts only the measurements on the mean and standard deviation for each measurement.
*  Uses descriptive activity names to name the activities in the data set
*  Appropriately labels the data set with descriptive activity names.
*  Creates a second, independent tidy data set with the average of each variable for each activity andeach subject.


1. Directory and files names
----------------------------
The first part of the script defines the paths and the files names required.  
The script **run_analysis.R** should be in the same directory than the **UCI HAR Dataset** directory, and this directory should be defined as working directory.  


```r
features_file <- file.path("UCI HAR Dataset", "features.txt")
trainset_X_file <- file.path("UCI HAR Dataset", "train", "X_train.txt")
trainset_y_file <- file.path("UCI HAR Dataset", "train", "y_train.txt")
trainset_subject_file <- file.path("UCI HAR Dataset", "train", "subject_train.txt")
testset_X_file <- file.path("UCI HAR Dataset", "test", "X_test.txt")
testset_y_file <- file.path("UCI HAR Dataset", "test", "y_test.txt")
testset_subject_file <- file.path("UCI HAR Dataset", "test", "subject_test.txt")
```



2. Features selection
---------------------
The file **features.txt** is read. All the features names containing std() and mean() are selected using a grep expression.  
The position and the names of theses features are stored to be used later.


```r
features <- read.csv(file = features_file, header = FALSE, stringsAsFactors = FALSE, 
    sep = "")
names(features) <- c("col_number", "feature_name")
mean_features_colnumber <- grep("mean\\(\\)", features[, "feature_name"])
std_features_colnumber <- grep("std\\(\\)", features[, "feature_name"])
features_col <- sort(c(mean_features_colnumber, std_features_colnumber))
features_names <- features[features_col, "feature_name"]
```



3. Training set
---------------

The 3 training set files are read.  
Only the selected features columns are kept from the measurements and the data are merged with Subject ID and activity.  
Columns are named with the features names from the previous part. 


```r
X_train <- read.csv(file = trainset_X_file, header = FALSE, sep = "")
X_train <- X_train[, features_col]
activity <- read.csv(file = trainset_y_file, header = FALSE, sep = "")
subject_id <- read.csv(file = trainset_subject_file, header = FALSE, sep = "")
training_set <- cbind(subject_id, activity, X_train)
colnames(training_set) <- c("subject_id", "activity", features_names)
```



4. Test set
-----------

The same process is applied to the test set. 

```r
X_test <- read.csv(file = testset_X_file, header = FALSE, sep = "")
X_test <- X_test[, features_col]
activity <- read.csv(file = testset_y_file, header = FALSE, sep = "")
subject_id <- read.csv(file = testset_subject_file, header = FALSE, sep = "")
test_set <- cbind(subject_id, activity, X_test)
colnames(test_set) <- c("subject_id", "activity", features_names)
```



5. Merge, labels and means 
--------------------------
A new data frame **data** is created combining training and test set.

```r
data <- rbind(training_set, test_set)
```

Activity informations are replaced by factors with the full label.

```r
data$activity <- as.factor(data$activity)
levels(data$activity) <- c("walking", "walking upstairs", "walking downstairs", 
    "sitting", "standing", "laying")
```

The **aggregate** functions is applied to have the mean of the measurements for each couple subject / activity.

```r
data2 <- aggregate(data[, 3:dim(data)[2]], data[, 1:2], FUN = mean)
```

The resulting data frame **data2** is saved in a text file **tiny_data.txt**.

```r
write.table(data2, file = "tidy_data.txt")
```

