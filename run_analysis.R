if(!file.exists("./Accelerometer")){dir.create("./Accelerometer")}
fileUrl="https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./Accelerometer/dataset.zip")
dataset<-unzip("dataset.zip")   
z1.test<-read.table("./UCI HAR Dataset/test/X_test.txt")
z2.test<-read.table("./UCI HAR Dataset/test/y_test.txt")
sub.test<-read.table("./UCI HAR Dataset/test/subject_test.txt")

t1.train<-read.table("./UCI HAR Dataset/train/X_train.txt")
t2.train<-read.table("./UCI HAR Dataset/train/y_train.txt")
sub.train<-read.table("./UCI HAR Dataset/train/subject_train.txt")
activitylabel<-read.table("./UCI HAR Dataset/activity_labels.txt")

predata<-rbind(z1.test,t1.train)  
subject<-rbind(sub.test,sub.train)
y<-rbind(z2.test,t2.train)

features<-read.table("./UCI HAR Dataset/features.txt")
names<-make.names(features[,2])    
meanstd<-grep("(mean|std)", names, value=F)
sel.dat<-predata[,meanstd]
data<-cbind(subject,y,sel.dat)

meanstdval<-grep("(mean|std)",names,value=T)
colnames(data)<-c("subject","activity",meanstdval)

data$activity<-factor(data$activity, levels=activitylabel$V1, labels=activitylabel$V2)

dataMelt<-melt(data, id=c("subject","activity"), measure, vars=meanstdval)
newdata<-dcast(dataMelt, subject + activity ~ variable, mean)