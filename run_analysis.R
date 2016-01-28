  ##Setting workdir., crating folder for data, getting and unziping data
  setwd("C:/Users/Birthe/Desktop/DataS Data/Modul 3 cleaning data/Oppgaver/Prosjekt uke 4")
  if(!file.exists("data")){dir.create("data")}

  downloadurl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  downloadfile <- "./data/Dataset.zip"
  download.file(downloadurl,downloadfile)
  unzip(downloadfile)

 
  
  ##Creating path and getting the fils
  filesPath <- "C:/Users/Birthe/Desktop/DataS Data/Modul 3 cleaning data/Oppgaver/Prosjekt uke 4/UCI HAR Dataset"
  list.files(filesPath)
  
  # Read subject files
  dataSubjectTrain <- read.table(file.path(filesPath, "train", "subject_train.txt"))
  dataSubjectTest  <- read.table(file.path(filesPath, "test" , "subject_test.txt" ))
  summary(dataSubjectTrain)
  summary(dataSubjectTest)
  
  ## Read activity files
  dataActivityTrain <- read.table(file.path(filesPath, "train", "Y_train.txt"))
  dataActivityTest  <- read.table(file.path(filesPath, "test" , "Y_test.txt" ))
  summary(dataActivityTrain)
  summary(dataActivityTest)
  
  ##Read features files.
  dataFeaturesTest  <- read.table(file.path(filesPath, "test" , "X_test.txt" ))
  dataFeaturesTrain <- read.table(file.path(filesPath, "train", "X_train.txt" ))
  str(dataFeaturesTrain)
  str(dataFeaturesTest)
  
  ##Merging datasets by row
  dataSubject <- rbind(dataSubjectTrain, dataSubjectTest)
  str(dataSubject)
  dataActivity<- rbind(dataActivityTrain, dataActivityTest)
  str(dataActivity)
  dataFeatures<- rbind(dataFeaturesTrain, dataFeaturesTest)
  str(dataFeatures)
  
  ##Setting names
  names(dataSubject)<-c("subject")
  head(dataSubject,1)
  names(dataActivity)<- c("activity")
  head(dataActivity,1)
  dataFeaturesNames <- read.table(file.path(filesPath, "features.txt"))
  head(dataFeaturesNames)
  names(dataFeatures)<- dataFeaturesNames$V2
  str(dataFeatures)
  
  ##Merging by collum cheeking that all variabals and rows are included
  dataSubAct <- cbind(dataSubject, dataActivity)
  str(dataSubAct)
  Data <- cbind(dataFeatures, dataSubAct)
  head(Data,skip=90, 2)
  str(Data)
  
  
  ##Subset Name of Features by measurements on the mean or standard deviation
  subdataFeaturesNames<-dataFeaturesNames$V2[grep("mean\\(\\)|std\\(\\)", dataFeaturesNames$V2)]
  str(subdataFeaturesNames)
  
  ##Subset Data by seleted names of Features
  selectedNames<-c(as.character(subdataFeaturesNames), "subject", "activity" )
  Data<-subset(Data,select=selectedNames)
  str(Data)
  
  ##Set descriptive activity names to the activities
  activityLabels <- read.table(file.path(filesPath, "activity_labels.txt"))
  
  
  ##Getting activity labels 
    activityLabels<- read.table(file.path(filesPath, "activity_labels.txt"))
    setnames(activityLabels, names(activityLabels), c("activity","activityName"))
    head(activityLabels,1)
  
  ##Merging descriptive activity into Data
  Data <- merge(activityLabels, Data , by="activity", all.x=TRUE)
  head(Data$activityName, 40)
  
  ##Labeleing dataset with descriptive variable names
  names(Data)<-gsub("^t", "time", names(Data))
  names(Data)<-gsub("^f", "frequency", names(Data))
  names(Data)<-gsub("Acc", "Accelerometer", names(Data))
  names(Data)<-gsub("Gyro", "Gyroscope", names(Data))
  names(Data)<-gsub("Mag", "Magnitude", names(Data))
  names(Data)<-gsub("BodyBody", "Body", names(Data))
  names(Data)
  
  ##Creating tidy dataset, organising collums and rows
  library(dplyr)
  Dataorg<-aggregate(. ~subject + activityName, Data, mean)
  Dataorg<-Dataorg[order(Data2$subject,Data2$activityName),]
  write.table(Dataorg, file = "tidydata.txt",row.name=FALSE)
  
  ## Checking to see that file looks according to spesifications
  checkfile<- read.table(file.path(filesPath, "tidydata.txt"), header = TRUE)
 