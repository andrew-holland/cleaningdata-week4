install.packages("dataMaid")
library(dataMaid)
##Load in the libraries
library(readr)
library(dplyr)

#load in data (file is in repo directory)
X_train <- read_table2("UCI HAR Dataset/train/X_train.txt", 
                        col_names = FALSE)
y_train <- read_table2("UCI HAR Dataset/train/y_train.txt", 
                        col_names = FALSE)
subject_train <- read_table2("UCI HAR Dataset/train/subject_train.txt", 
                        col_names = FALSE)
X_test <- read_table2("UCI HAR Dataset/test/X_test.txt", 
                        col_names = FALSE)
y_test <- read_table2("UCI HAR Dataset/test/y_test.txt", 
                        col_names = FALSE)
subject_test <- read_table2("UCI HAR Dataset/test/subject_test.txt", 
                        col_names = FALSE)
features <- read_table2("UCI HAR Dataset/features.txt", 
                        col_names = FALSE)
activity_labels <- read_table2("UCI HAR Dataset/activity_labels.txt", 
                        col_names = FALSE)


#STEP 1 is done throughout lines 23-56   

#combine test and train datasets by row binding
X_full <- rbind(X_test, X_train)

#remove the "x" from the column names, so they are easier to match with the measurements
names(X_full)[1:ncol(X_full)] <- sub("X", "", names(X_full)[1:ncol(X_full)])

#STEPS 2 and 4A -  take the list of features, and extract only those rows with mean() or std() measurements
std_nos <- filter(features, X2 %in% grep("std()", X2, value=TRUE))
mean_nos <- filter(features, X2 %in% grep("mean()", X2, value=TRUE))
std_mean_table <- arrange(rbind(std_nos, mean_nos), X1)
std_mean_features <- as.numeric(std_mean_table$X1)
#now subset X_full to select columns with names according to the numbers above
X_full2 <- X_full[, (names(X_full) %in% std_mean_features)]
#the names of X_full can now be interchanged with the actual measurement descriptions (same length, same order)
names(X_full2) <- std_mean_table$X2

#combine the y_test and y_train as done with X_test and X_train
y_full <- rbind(y_test, y_train)
##combine the subject_test and subject_train as done with X_test and X_train
subject_full <- rbind(subject_test, subject_train)

#combine the subject data, y_ data and X_ data by column binding
full <- cbind(subject_full, y_full, X_full2)

#STEP 4B - just need to change the names of the y_ and subject_ columns, we've already done the X_ columns)
names(full)[1] <- "Person_ID"
names(full)[2] <- "Activity_ID"

#STEP 3 - change the values in the Activity_ID column from a number to its appropriate designation.
class(full[,1]) <- "character"
full[,2] <- as.factor((full[,2]))
levels(full[,2]) <- list("WALKING"=1, "WALKING_UPSTAIRS"=2, "WALKING_DOWNSTAIRS"=3, "SITTING"=4, "STANDING"=5, "LAYING"=6)

#STEP 5 - separate table that provides the mean for each person and activity.
data_summary <- full %>%
    #from the step above, the Person_ID column was of character class. Not a problem for this, but changing to numeric lets
    #us actually order the column numerically (Ie otherwise you get 1, 10, 11... which isn't ideal!)
    mutate(Person_ID = as.numeric(Person_ID)) %>%
    #group_by both person and activity, so we'll get summarised stats for all available combinations of these.
    group_by(Person_ID, Activity_ID) %>%
    #summarise_all does the same as summarise, but across all columns (except for those being used for grouping!)
    summarise_all(list(mean=mean)) %>%
    #for tidiness, lets quickly arrange according to person, and then activity.
    arrange(Person_ID, Activity_ID)
#DONE!


write.table(data_summary, file = "data_summary.txt", row.names = FALSE)
?write.table  

makeCodebook(data_summary)
