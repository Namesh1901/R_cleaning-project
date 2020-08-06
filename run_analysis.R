#TO IMPORT DATA IN FORM OF DATA FRAMES
library(dplyr)
features<-read.table("UCI HAR Dataset/features.txt",col.names = c("n","functions"))
activity<-read.table("UCI HAR Dataset/activity_labels.txt",col.names = c("code","activities"))
subject_test<-read.table("UCI HAR Dataset/test/subject_test.txt",col.names = "subjects")
subject_train<-read.table("UCI HAR Dataset/train/subject_train.txt",col.names = "subjects")
x_test<-read.table("UCI HAR Dataset/test/X_test.txt",col.names = features$functions)
y_test<-read.table("UCI HAR Dataset/test/Y_test.txt",col.names = "code")
x_train<-read.table("UCI HAR Dataset/train/X_train.txt",col.names = features$functions)
y_train<-read.table("UCI HAR Dataset/train/Y_train.txt",col.names = "code")
#TO MERGE DATASET TOGETHER
combine_subject<-rbind(subject_train,subject_test)
combine_x<-rbind(x_train,x_test)
combine_y<-rbind(y_train,y_test)
merge_data<-cbind(combine_subject,combine_y,combine_x)
#TO EXTRACT MEASUEMENTS OF MEAN AND STANDARD DEVIATION 
#INTO A extms DATA FRAME
extms<-merge_data[,grep("[Mm]ean|std",names(merge_data),value=TRUE)]
extmsn1<-cbind(combine_subject,combine_y,extms)
#TO REPLACE CODE FOR ACTIVITY WITH NAMES
extmsn1$code<-activity[extmsn1$code,2]
#LABEL DATASET WITH DESCRIPTIVE ANALYSIS
names(extmsn1)[1]<-"Subjects"
names(extmsn1)[2]<-"Activities"
names(extmsn1)<-gsub("Acc","Accelerometer",names(extmsn1))
names(extmsn1)<-gsub("Gyro","Gyroscope",names(extmsn1))
names(extmsn1)<-gsub("^t","time",names(extmsn1))
names(extmsn1)<-gsub("^f","frequency",names(extmsn1))
names(extmsn1)<-gsub("Mag","magnitude",names(extmsn1))
#CREATE FINAL DATASET HAVING MEANS OF EACH QUANTITY GROUPED BY SUBJECT AND ACTIVITIES
finaldat<-extmsn1 %>% group_by(Subjects,Activities) %>% summarise_at(colnames(select(extmsn1,-(Subjects:Activities))),funs(mean))
write.table(finaldat,"finaldata.txt",row.name=FALSE)

