 USER_ID=$(id -u)
 if [ $USER_ID -ne 0 ]; then
    echo You are non root user
    echo you can run this script as root user or with sudo
    exit 1
 fi

curl -s -L -o /etc/yum.repos.d/mysql.repo https://raw.githubusercontent.com/roboshop-devops-project/mysql/main/mysql.repo
yum install mysql-community-server -y
systemctl enable mysqld
systemctl start mysqld

MYSQL_DEFAULT_PASSWORD=$(grep 'temporary password' /var/log/mysqld.log | awk '{print $NF}')
echo "ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_PASSWORD}';" | mysql --connect-expired-password -uroot -p"${MYSQL_DEFAULT_PASSWORD}"
echo "uninstall plugin validate_password;" | mysql --connect-expired-password -uroot -p"${MYSQL_PASSWORD}"

curl -s -L -o /tmp/mysql.zip "https://github.com/roboshop-devops-project/mysql/archive/main.zip"
cd /tmp
cd mysql-main
unzip -o mysql.zip
mysql -u root -p"${MYSQL_PASSWORD}" <shipping.sql
