# Reading the data into R
x_test <-read.table("./UCI HAR Dataset/test/X_test.txt")
str(x_test)
dim(x_test)
y_test <-read.table("./UCI HAR Dataset/test/y_test.txt")
str(y_test)
dim(y_test)
subject_test <-read.table("./UCI HAR Dataset/test/subject_test.txt")
str(subject_test)
dim(subject_test)
x_train <-read.table("./UCI HAR Dataset/train/X_train.txt")
str(x_train)
dim(x_train)
y_train <-read.table("./UCI HAR Dataset/train/y_train.txt")
str(y_train)
dim(y_train)
subject_train <-read.table("./UCI HAR Dataset/train/subject_train.txt")
str(subject_train)
dim(subject_train)
features <-read.table("./UCI HAR Dataset/features.txt")
str(features)

# Labeling the different data frames with features.txt labels
names(x_train)<-features$V2
names(x_test)<-features$V2
names(y_train)<-c("activity")
names(y_test)<-c("activity")
names(subject_train)<-c("subject")
names(subject_test)<-c("subject")

# Merging the different data frames
train <-cbind(x_train, y_train, subject_train)
str(train)
dim(train)
test <- cbind(x_test, y_test, subject_test)
str(train)
dim(test)
data <-rbind(train, test)
str(data)
dim(data)

# Extracting the mean and standard deviation measurements for each measurement
subsetnames<-grep(("mean|std"),names(data))
subsetnames<-c(subsetnames, 562, 563)
data2 <-data[,subsetnames]
str(data2)

# Labeling the activity names variable to descriptive activity names
factors <-factor(data2$activity)
levels(factors)<-c("walking", "walkingup", "walkingdown", "sitting", "standing","laying")
data2$activity<-factors

# Cleaning and labeling correctly the data set descriptive variable names 
varnames<-gsub("^t","Time",names(data2))
varnames<-gsub("^f","FFT",varnames)
varnames<-gsub("-","_",varnames)
varnames<-gsub("\\()_","",varnames)
varnames<-gsub("\\()$","",varnames)
varnames<-gsub("BodyBody","Body", varnames)
varnames<-gsub("Acc", "Acceleration",varnames)
varnames<-gsub("Gyro", "Gyroscope", varnames)
varnames<-gsub("Mag", "Magnitude", varnames)
names(data2)<-varnames
names(data2)
str(data2)

# Creation of a new tidy data set with the average of each variable for each activity and each subject
tidy <-aggregate(.~activity+subject,data=data2,mean)
str(tidy)
head(tidy)
write.table(tidy,file="./getDataProject.txt",sep=",",row.name=FALSE)
