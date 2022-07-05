

curl -s -L -o /etc/yum.repos.d/mysql.repo https://raw.githubusercontent.com/roboshop-devops-project/mysql/main/mysql.repo
yum install mysql-community-server -y
systemctl enable mysqld
systemctl start mysqld

MYSQL_DEFAULT_PASSWORD=$(grep 'temporary password' /var/log/mysqld.log | awk '{print $NF}')
echo "ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_PASSWORD}';" >/tmp/mysql
mysql -uroot -p"${MYSQL_DEFAULT_PASSWORD}" < /tmp/mysql

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
##uninstall plugin validate_password;
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
#curl -s -L -o /tmp/mysql.zip "https://github.com/roboshop-devops-project/mysql/archive/main.zip"
#cd /tmp
#cd mysql-main
#unzip mysql.zip
#mysql -u root -pRoboShop@1 <shipping.sql
#
#
#Load the schema for Services.