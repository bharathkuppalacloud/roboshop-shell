source utils.sh
component=catalogue
NODEJS
#add client address /etc/yum.repos.d/mongo.repo
PRINT Install mongodb client
dnf install mongodb-mongosh -y &>>LOG_FILE

PRINT Load Data
mongosh --host mongo.dev.codedeploywithbharath.tech</app/db/master-data.js &>>LOG_FILE