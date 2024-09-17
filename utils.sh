LOG_FILE=/tmp/roboshop-shell.log
rm -f $LOG_FILE

SUCCESS() {
  # shellcheck disable=SC1073
  if [ $1 -eq 0 ]; then
      echo -e "\e[32mSUCCESS\e[0m"
    else
      echo -e "\e[31mFAILURE\e[0m"
      echo
      echo "Refer the log file for more information : File Path : ${LOG_FILE}"
      exit $1
    fi
}

PRINT() {
  echo &>>$LOG_FILE
    echo &>>$LOG_FILE
    echo " ####################################### $* ########################################" &>>$LOG_FILE
    echo $*
}

NODEJS(){
  PRINT Disabling NodeJS Default Version
  dnf module disable nodejs -y &>>LOG_FILE
  SUCCESS $?

  PRINT enabling NodeJS 20 Module
  dnf module enable nodejs:20 -y &>>LOG_FILE
  SUCCESS $?

  PRINT install NodeJS
  dnf install nodejs -y
  SUCCESS $?

  PRINT copy Service file
  cp ${component}.service  /etc/systemd/system/${component}.service &>>LOG_FILE
  SUCCESS $?

  PRINT copy Mongo repo
  cp mongo.repo /etc/yum.repos.d/mongo.repo &>>LOG_FILE
  SUCCESS $?

  PRINT add User
  id roboshop &>>LOG_FILE
  if [ $? -ne 0 ]; then
    useradd roboshop &>>LOG_FILE
  fi
  SUCCESS $?

  PRINT Cleaning old content
  rm -rd /app &>>LOG_FILE
  SUCCESS $?

  PRINT Create App Directory
  mkdir /app &>>LOG_FILE
  SUCCESS $?

  PRINT Download NodeJS Dependecy
  curl -L -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}-v3.zip
  SUCCESS $?

  cd /app

  PRINT Extract App content
  unzip /tmp/${component}.zip &>>LOG_FILE
  SUCCESS $?

  PRINT Download NodeJS Dependecies
  npm install &>>LOG_FILE
  SUCCESS $?

  PRINT Make it service
  systemctl daemon-reload &>>LOG_FILE
  SUCCESS $?

  PRINT enabling ${component}
  systemctl enable ${component} &>>LOG_FILE
  SUCCESS $?

  PRINT Start service
  systemctl start ${component} &>>LOG_FILE
  SUCCESS $?
}

#session 15 16