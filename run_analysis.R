dataDirectory <- 'UCI HAR Dataset'
if (!file.exists(dataDirectory)) {
    zipFileName <- 'data.zip'
    zipFileUrl <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip'
    download.file(zipFileUrl, destfile = zipFileName, method='curl')
    unzip(zipFileName)
    file.remove(zipFileName)
}

#1. Merges the training and the test sets to create one data set.
train_set <- read.table(file.path(dataDirectory, 'train/X_train.txt'))
test_set <- read.table(file.path(dataDirectory, 'test/X_test.txt'))
merged_set <- rbind(train_set, test_set)

#2. Extracts only the measurements on the mean and standard deviation for each measurement.
features <- read.table(file.path(dataDirectory, 'features.txt'), sep = ' ')
names(features) <- c('column_number', 'column_name')
measures_column_names <- grep('(?:mean|std|meanFreq)\\(\\)', features$column_name, value = T)
column_numbers <- features[features$column_name %in% measures_column_names, 'column_number']
selected_variables_data_set <- merged_set[, column_numbers]

#3. Uses descriptive activity names to name the activities in the data set
train_num_labels <- read.table(file.path(dataDirectory, 'train/y_train.txt'), colClasses = 'character')
test_num_labels <- read.table(file.path(dataDirectory, 'test/y_test.txt'), colClasses = 'character')
merged_num_labels <- rbind(train_num_labels, test_num_labels)
activity_labels <- read.table(file.path(dataDirectory, 'activity_labels.txt'), sep = ' ', colClasses = c('character', 'character'))
names(activity_labels) <- c('activity_number', 'activity_name')
row.names(activity_labels) <- activity_labels[, 'activity_number']
merged_activity_labels <- activity_labels[merged_num_labels[[1]], 'activity_name']
activity_labeled_data_set <- cbind(merged_activity_labels, selected_variables_data_set)

#4. Appropriately labels the data set with descriptive variable names.
activity_column_name <- 'activity'
names(activity_labeled_data_set) <- c(activity_column_name, measures_column_names)

#5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
train_subject_labels <- read.table(file.path(dataDirectory, 'train/subject_train.txt'))
test_subject_labels <- read.table(file.path(dataDirectory, 'test/subject_test.txt'))
merged_subject_labels <- rbind(train_subject_labels, test_subject_labels)
subject_column_name <- 'subject_number'
names(merged_subject_labels) <- subject_column_name
subj_act_labeled_data_set <- cbind(merged_subject_labels, activity_labeled_data_set)
measures_part <- subj_act_labeled_data_set[3:length(subj_act_labeled_data_set)]
group_by_list <- list(subj_act_labeled_data_set$subject_num, subj_act_labeled_data_set$activity)
subj_act_averaged <- aggregate(measures_part, by=group_by_list, mean)

#renaming
avg_measures_column_names <- sub('^t', 'time_', measures_column_names)
avg_measures_column_names <- sub('^f', 'frequency_', avg_measures_column_names)
avg_measures_column_names <- sub('BodyBody', 'Body', avg_measures_column_names)
avg_measures_column_names <- sub('BodyAcc', '_body_acceleration_', avg_measures_column_names)
avg_measures_column_names <- sub('GravityAcc', '_gravity_acceleration_', avg_measures_column_names)
avg_measures_column_names <- sub('BodyGyro', '_body_gyroscope_', avg_measures_column_names)
avg_measures_column_names <- sub('Jerk', '_jerk_score_', avg_measures_column_names)
avg_measures_column_names <- sub('Mag', '_magnitude_', avg_measures_column_names)
avg_measures_column_names <- sub('\\-mean\\(\\)', '_mean_', avg_measures_column_names)
avg_measures_column_names <- sub('\\-meanFreq\\(\\)', '_mean_frequency_', avg_measures_column_names)
avg_measures_column_names <- sub('\\-std\\(\\)', '_standard_deviation_', avg_measures_column_names)
avg_measures_column_names <- tolower(avg_measures_column_names)
avg_measures_column_names <- gsub('[-_]+', '_', avg_measures_column_names)
avg_measures_column_names <- sub('_$', '', avg_measures_column_names)

names(subj_act_averaged) <- c(subject_column_name, activity_column_name, avg_measures_column_names)
write.table(subj_act_averaged, file='result.txt', row.names=F)


