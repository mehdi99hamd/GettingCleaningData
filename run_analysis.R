# Load Librairies
library(data.table)
library(dplyr)

setwd("D:/Auto_formation/Coursera_Getting_And_Cleaning_Data/Project")

# Merges the training and the test sets to create one data set:

X_train <- fread('train/X_train.txt', header = FALSE)
Y_train <- fread('train/y_train.txt', header = FALSE)
subject_train <- fread('train/subject_train.txt', header = FALSE)

X_test <- fread('test/X_test.txt', header = FALSE)
Y_test <- fread('test/y_test.txt', header = FALSE)
subject_test <- fread('test/subject_test.txt', header = FALSE)


Data_X <- rbind(X_train , X_test)
Data_y <- rbind(Y_train , Y_test)
Data_Subject <- rbind(subject_train , subject_test)


# Extracts only the measurements on the mean and standard deviation for each measurement :


features <- read.table('features.txt')[,2]

names(Data_Subject) <- "Subject"
names(Data_X) <- features
names(Data_y)<- "Activity"

features_extracted <- grep("mean\\(\\)|std\\(\\)", features)

Dataset_extracted <- Data_X[,..features_extracted]

Dataset <- cbind(Data_Subject, Dataset_extracted, Data_y)

# Uses descriptive activity names to name the activities in the data set : 

ActivityNames <- fread('activity_labels.txt', header = FALSE)[,2]

for (i in 1:6){
  Dataset$Activity[Dataset$Activity == i] <- as.character(ActivityNames[i]) 
}


# Appropriately labels the data set with descriptive variable names.

names(Dataset)<-gsub("^t", "time", names(Dataset))
names(Dataset)<-gsub("^f", "frequency", names(Dataset))
names(Dataset)<-gsub("Acc", "Accelerometer", names(Dataset))
names(Dataset)<-gsub("Gyro", "Gyroscope", names(Dataset))
names(Dataset)<-gsub("Mag", "Magnitude", names(Dataset))
names(Dataset)<-gsub("BodyBody", "Body", names(Dataset))

# Creates an independent tidy data set with the average of each variable for each activity and each subject.

Dataset_tidy <- aggregate(. ~Subject + Activity, Dataset, mean)

write.table(Dataset_tidy, file = "Tidy_Data.txt",row.name=FALSE)