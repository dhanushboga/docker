#!/bin/bash

LOG_FOLDER="/var/log/docker_installation"
LOG_FILE=$(echo $0 | cut -d '.' -f1)
TIME_STAMP=$(date +%Y-%m-%d-%H-%m-%s)
LOG_FILE_NAME=$LOG_FOLDER/$LOG_FILE-$TIME_STAMP.log

USER_ID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

VALIDATE(){
if [ $1 -ne 0 ]
   then
     echo -e "$2............$R FAILURE $N"
   else
     echo -e "$2............$G SUCCESS $N"
fi
}

CHECK_ROOT(){
    if [ $USER_ID -ne 0 ]
    then
      echo -e $R "ERROR::Please run this Script under root access" $N
      exit 1
    fi
}

echo "The $0 Script run at :$TIME_STAMP" &>>$LOG_FILE_NAME

mkdir -p $LOG_FOLDER
VALIDATE $? "Creating Logs Folder for docker"

dnf install dnf-plugins-core -y &>>$LOG_FILE_NAME
VALIDATE $? "Installing plugins core"

dnf config-manager --add-repo https://download.docker.com/linux/rhel/docker-ce.repo &>>$LOG_FILE_NAME
VALIDATE $? "adding the repos"

dnf install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y &>>$LOG_FILE_NAME
VALIDATE $? "Installing Docker engine"


systemctl start docker &>>$LOG_FILE_NAME
VALIDATE $? "Starting the Docker"

systemctl enable docker &>>$LOG_FILE_NAME
VALIDATE $? "Enabling Docker"

usermod -aG docker ec2-user &>>$LOG_FILE_NAME
VALIDATE $? "adding the ec2-user to docker group"







