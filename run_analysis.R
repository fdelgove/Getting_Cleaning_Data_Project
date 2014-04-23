# FILES NAMES & PATH
features_file<-file.path("UCI HAR Dataset","features.txt")
trainset_X_file<-file.path("UCI HAR Dataset","train","X_train.txt")
trainset_y_file<-file.path("UCI HAR Dataset","train","y_train.txt")
trainset_subject_file<-file.path("UCI HAR Dataset","train","subject_train.txt")
testset_X_file<-file.path("UCI HAR Dataset","test","X_test.txt")
testset_y_file<-file.path("UCI HAR Dataset","test","y_test.txt")
testset_subject_file<-file.path("UCI HAR Dataset","test","subject_test.txt")


# FEATURES SELECTION
# read the features list to extract -mean & -std variable numbers
features<-read.csv(file=features_file,header=FALSE,stringsAsFactors=FALSE,sep="")
names(features)<-c("col_number","feature_name")
mean_features_colnumber<-grep("mean\\(\\)",features[,"feature_name"])
std_features_colnumber<-grep("std\\(\\)",features[,"feature_name"])
features_col<-sort(c(mean_features_colnumber,std_features_colnumber))
features_names<-features[features_col,"feature_name"]


# TRAINING SET 
# read the training set X features
X_train<-read.csv(file=trainset_X_file,header=FALSE,sep="")
X_train<-X_train[,features_col]

# read the training set Y features
activity<-read.csv(file=trainset_y_file,header=FALSE,sep="")

# read the training set subject_id
subject_id<-read.csv(file=trainset_subject_file,header=FALSE,sep="")

# combine all in the training_set
training_set<-cbind(subject_id,activity,X_train)
colnames(training_set)<-c("subject_id","activity",features_names)


# TEST SET
# read the test set X features
X_test<-read.csv(file=testset_X_file,header=FALSE,sep="")
X_test<-X_test[,features_col]

# read the test set Y features
activity<-read.csv(file=testset_y_file,header=FALSE,sep="")

# read the test set subject_id
subject_id<-read.csv(file=testset_subject_file,header=FALSE,sep="")

# combine all in the test_set
test_set<-cbind(subject_id,activity,X_test)
colnames(test_set)<-c("subject_id","activity",features_names)


# TRAINING & TEST SET TOGETHER - MEAN DATA 
# combine training set and test set
data<-rbind(training_set,test_set)

# replace activity numbers by activity 
data$activity<-as.factor(data$activity)
levels(data$activity)<-c("walking","walking upstairs","walking downstairs","sitting","standing","laying")

# create the second data set with the mean of each features for each subject / activity
data2<-aggregate(data[,3:dim(data)[2]],data[,1:2],FUN=mean)
write.table(data2,file="tidy_data.txt")
