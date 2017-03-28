## Cleanup the folder to download the data
if(!file.exists("./Week4test"))
  {
  dir.create("./Week4test")
}
# Setting the URL
url_f <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
# dowloading the file
download.file(url_f,destfile="./Week4test/Dataset.zip")
              #, method="curl")

# Unzipping the file

unzip(zipfile="./Week4test/Dataset.zip",exdir="./Week4test")

# read the labels

actlabels <- read.table(file.path("./Week4test/UCI HAR Dataset", "activity_labels.txt"),header = FALSE)
actlabels

featlabels <- read.table(file.path("./Week4test/UCI HAR Dataset", "features.txt"),header = FALSE)
label_name <- featlabels[,2]


display_labels <- grep("(mean|std)\\(\\)", label_name)

display_labels

## Read training data

Train_raw <- read.table(file.path("./Week4test/UCI HAR Dataset/train", "X_train.txt"),header = FALSE)
Test_raw <- read.table(file.path("./Week4test/UCI HAR Dataset/test", "X_test.txt"),header = FALSE)


Merged_raw <- rbind(Train_raw, Test_raw) 
# assign the names
names(Merged_raw) <- featlabels[,2]

relevent_raw_data <- Merged_raw[,display_labels]

# cleaning up headers

names(relevent_raw_data) <- gsub("^t", "Time", names(relevent_raw_data))
names(relevent_raw_data) <- gsub("^f", "Frequency", names(relevent_raw_data))
names(relevent_raw_data) <- gsub("-mean\\(\\)", "Mean", names(relevent_raw_data))
names(relevent_raw_data) <- gsub("-std\\(\\)", "StdDev", names(relevent_raw_data))
names(relevent_raw_data) <- gsub("-", "", names(relevent_raw_data))
names(relevent_raw_data) <- gsub("BodyBody", "Body", names(relevent_raw_data))
names(relevent_raw_data) <- gsub("Acc", "Accelerometer", names(relevent_raw_data))
names(relevent_raw_data) <- gsub("Gyro", "Gyroscope", names(relevent_raw_data))
names(relevent_raw_data) <- gsub("Mag", "Magnitude", names(relevent_raw_data))


# reading activity dtata

activity_train_raw  <- read.table(file.path("./Week4test/UCI HAR Dataset/train", "y_train.txt"),header = FALSE)
activity_test_raw  <- read.table(file.path("./Week4test/UCI HAR Dataset/test", "y_test.txt"),header = FALSE)

activity_Merged_raw  <- rbind(activity_train_raw, activity_test_raw)[, 1]

activitiesdata <- actlabels[,2][activity_Merged_raw]


# reading Subject Data

subject_Train_raw <- read.table(file.path("./Week4test/UCI HAR Dataset/train", "subject_train.txt"),header = FALSE) 
subject_Test_raw   <- read.table(file.path("./Week4test/UCI HAR Dataset/test", "subject_test.txt"),header = FALSE)
subjects_data <- rbind(subject_Train_raw, subject_Test_raw)[, 1]

# creating the final data set
final_activity_data <- cbind(subjects_data,activitiesdata,relevent_raw_data)

names(final_activity_data) <- c("Subjects","Activities",names(final_data)[3:68])

# Creating a data for finding the mean

mean_data <- 
  final_activity_data %>%
  group_by(Subjects,Activities) %>%
  summarise_each(funs(mean))

write.table(mean_data, "mean_data.txt",row.name=FALSE)


