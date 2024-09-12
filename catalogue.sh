source utils.sh
cp catalogue.service /etc/systemd/system/catalogue.service
cp mongo.repo /etc/yum.repos.d/mongo.repo
NODEJS
useradd roboshop
mkdir /app
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue-v3.zip
cd /app || return
unzip /tmp/catalogue.zip
cd /app
npm install
# change catalogue to service vim /etc/systemd/system/catalogue.service
systemctl daemon-reload
systemctl enable catalogue
systemctl start catalogue
#add client address /etc/yum.repos.d/mongo.repo
dnf install mongodb-mongosh -y
mongosh --host mongo.dev.codedeploywithbharath.tech</app/db/master-data.js