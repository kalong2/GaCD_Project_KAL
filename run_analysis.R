#load in column names
features<-read.delim("features.txt", sep="", header = FALSE)

#load in test data
#using this separator avoids the NAs that results from a difference in the length of whitespace
Test_data<-read.delim("test/X_test.txt", sep="", header = FALSE)
names(Test_data) <- features[,2] #gives variable names from features
Test_subjects<-read.delim("test/subject_test.txt", sep="", header = FALSE)
names(Test_subjects) <- "Subject"
Test_labels<-read.delim("test/y_test.txt", sep="", header = FALSE)
names(Test_labels) <- "Label"
Test_all<-cbind(Test_subjects, Test_labels, Test_data)

#load in training data
#using this separator avoids the NAs that results from a difference in the length of whitespace
Training_data<-read.delim("train/X_train.txt", sep="", header = FALSE)
names(Training_data) <- features[,2] #gives variable names from features
Training_subjects<-read.delim("train/subject_train.txt", sep="", header = FALSE)
names(Training_subjects) <- "Subject"
Training_labels<-read.delim("train/y_train.txt", sep="", header = FALSE)
names(Training_labels) <- "Label"
Training_all<-cbind(Training_subjects, Training_labels, Training_data)

#combine test and training data
all_data <- rbind(Test_all, Training_all)

#load in activity labels
activity_labels<-read.delim("activity_labels.txt", sep="", header = FALSE)
names(activity_labels) <- c("Label","Activity Label")
all_data_Labeled<-merge(activity_labels, all_data)

#get only mean and std variables
all_data_Labeled_mean_std<-all_data_Labeled[,grepl("\\bmean()\\b|std()", names(all_data_Labeled))]
#reattach columns with activity labels and subject
final_data <- cbind(all_data_Labeled[2:3],all_data_Labeled_mean_std)
final_data_sorted <- final_data[order(final_data$Subject),] 
write.table(final_data_sorted, file='Tidy_Data.txt', sep='\t', row.names = FALSE)

final_data_mean <- aggregate(.~Subject + `Activity Label`, final_data, mean)
write.table(final_data_mean, file='Tidy_Data_Mean.txt', sep='\t', row.names = FALSE)

