#add repo at this address /etc/yum.repos.d/mongo.repo
dnf install mongodb-org -y
systemctl enable mongod
systemctl start mongod
systemctl restart mongod