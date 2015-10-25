
# 1 Merge the training and the test sets to create one data set.

library(data.table, quietly=TRUE)
library(dplyr, quietly=TRUE)
library(stringr, quietly=TRUE)

dataDir = "./"

activities = read.table(paste0(dataDir, "activity_labels.txt"), header=FALSE, sep=" ")
features = read.table(paste0(dataDir, "features.txt"), header=FALSE, sep=" ")

meanSTD = features[which(str_locate(features$V2, "-mean\\(") != 0 | 
                         str_locate(features$V2, "-std\\(") != 0),]
meanSTD = meanSTD[complete.cases(meanSTD),]

rawDataFiles = paste0(dataDir, c("X_test.txt",
                                 "Y_test.txt",
                                 "subject_test.txt",
                                 "X_train.txt",
                                 "Y_train.txt",
                                 "subject_train.txt"))

dTRaw = lapply(rawDataFiles, fread)

names(dTRaw[[2]])[names(dTRaw[[2]])=="V1"] = "Activity"
names(dTRaw[[3]])[names(dTRaw[[3]])=="V1"] = "Subject"
names(dTRaw[[5]])[names(dTRaw[[5]])=="V1"] = "Activity"
names(dTRaw[[6]])[names(dTRaw[[6]])=="V1"] = "Subject"

for (i in 1:6) 
    dTRaw[[i]]$id = seq.int(nrow(dTRaw[[i]]))

dTRaw[[1]]$source = "test"
dTRaw[[4]]$source = "train"
test = merge(merge(dTRaw[[1]], dTRaw[[2]], by=c("id")), dTRaw[[3]], by=c("id"))
train = merge(merge(dTRaw[[4]], dTRaw[[5]], by=c("id")), dTRaw[[6]], by=c("id"))

# 2 Extract only the measurements on the mean and standard deviation for each measurement.
columns = c(c("id","Subject","Activity"), paste("V", meanSTD$V1, sep=""))
onlyMeanSTD = as.data.frame(rbind(test, train))[,columns]

# 3 Use descriptive activity names to name the activities in the data set.
onlyMeanSTD$Activity = activities$V2[onlyMeanSTD$Activity]

# 4 Appropriately label the data set with descriptive variable names.
meanSTD <- data.frame(lapply(meanSTD, as.character), stringsAsFactors=FALSE)
colnames(onlyMeanSTD) = c(c("id","Subject","Activity"), meanSTD[,2])

# 5 From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
onlyMeanSTD$Activity = activities$V1[onlyMeanSTD$Activity]
byActivitySubject = aggregate(onlyMeanSTD, by=list(onlyMeanSTD$Activity, onlyMeanSTD$Subject), FUN=mean, na.rm=TRUE)
byActivitySubject$Activity = activities$V2[byActivitySubject$Activity]
byActivitySubject$Group.1=NULL
byActivitySubject$Group.2=NULL
byActivitySubject$id=NULL
write.table(byActivitySubject, file='tidy.txt', sep=',', row.names = FALSE, col.names = FALSE)


