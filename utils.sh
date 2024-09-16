LOG_FILE=/tmp/roboshop-shell.log
rm -f $LOG_FILE

PRINT() {
  echo &>>LOG_FILE
  echo "************************ $* ##################" &>>$LOG_FILE
  echo $*
}

NODEJS(){
  PRINT Disabling NodeJS Default Version
  dnf module disable nodejs -y &>>LOG_FILE

  PRINT enabling NodeJS 20 Module
  dnf module enable nodejs:20 -y &>>LOG_FILE

  PRINT install NodeJS
  dnf install nodejs -y

  PRINT copy Service file
  cp ${component}.service  /etc/systemd/system/${component}.service &>>LOG_FILE

  PRINT copy Mongo repo
  cp mongo.repo /etc/yum.repos.d/mongo.repo &>>LOG_FILE

  PRINT add User
  useradd roboshop &>>LOG_FILE

  PRINT Cleaning old content
  rm -rd /app &>>LOG_FILE

  PRINT Create App Directory
  mkdir /app &>>LOG_FILE

  PRINT Download NodeJS Dependecy
  curl -L -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}-v3.zip
  cd /app

  PRINT Extract App content
  unzip /tmp/${component}.zip &>>LOG_FILE

  PRINT Download NodeJS Dependecies
  npm install &>>LOG_FILE

  PRINT Make it service
  systemctl daemon-reload &>>LOG_FILE

  PRINT enabling ${component}
  systemctl enable ${component} &>>LOG_FILE

  PRINT Start service
  systemctl start ${component} &>>LOG_FILE
}