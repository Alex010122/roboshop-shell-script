

curl -s -L -o /etc/yum.repos.d/mysql.repo https://raw.githubusercontent.com/roboshop-devops-project/mysql/main/mysql.repo
yum install mysql-community-server -y
systemctl enable mysqld
systemctl start mysqld

MYSQL_DEFAULT_PASSWORD=$(grep 'temporary password' /var/log/mysqld.log | awk '{print $NF}')
echo "ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_PASSWORD}';" | mysql --connect-expired-password -uroot -p"${MYSQL_DEFAULT_PASSWORD}"
echo "uninstall plugin validate_password;" | mysql --connect-expired-password -uroot -p"${MYSQL_PASSWORD}"
#
##grep temp /var/log/mysqld.log
#
#mysql_secure_installation
#
#
# mysql -uroot -pRoboShop@1
#
#
##Once after login to MySQL prompt then run this SQL Command.
#
##sql

#
#
##As per the architecture diagram, MySQL is needed by
#
##Shipping Service
#
##So we need to load that schema into the database, So those applications will detect them and run accordingly.
#
##To download schema, Use the following command
#> uninstall plugin validate_password;
#
curl -s -L -o /tmp/mysql.zip "https://github.com/roboshop-devops-project/mysql/archive/main.zip"
cd /tmp
cd mysql-main
unzip -o mysql.zip
mysql -u root -p"${MYSQL_PASSWORD}" <shipping.sql
#
#
#Load the schema for Services.