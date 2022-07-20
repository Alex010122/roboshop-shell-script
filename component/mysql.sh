source component/comman.sh
CHECK_ROOT

if [ -z "${MYSQL_PASSWORD}" ]; then
  echo " need variable input "

exit 1
fi

PRINT " configure yum repos"
curl -s -L -o /etc/yum.repos.d/mysql.repo https://raw.githubusercontent.com/roboshop-devops-project/mysql/main/mysql.repo &>>${LOG}
CHECK_STAT $?

PRINT "install mysql"
yum install mysql-community-server -y &>>${LOG}
systemctl enable mysqld && systemctl start mysqld
CHECK_STAT $?


MYSQL_DEFAULT_PASSWORD=$(grep 'temporary password' /var/log/mysqld.log | awk '{print $NF}')
PRINT " reset root password"
echo "ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_PASSWORD}';" | mysql --connect-expired-password -uroot -p"${MYSQL_DEFAULT_PASSWORD}" ${LOG}
CHECK_STAT $?

exit
echo "uninstall plugin validate_password;" | mysql --connect-expired-password -uroot -p"${MYSQL_PASSWORD}"

curl -s -L -o /tmp/mysql.zip "https://github.com/roboshop-devops-project/mysql/archive/main.zip"
cd /tmp
cd mysql-main
unzip -o mysql.zip
mysql -u root -p"${MYSQL_PASSWORD}" <shipping.sql
