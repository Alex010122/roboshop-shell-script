CHECK_ROOT (){
   USER_ID=$(id -u)
   if [ $USER_ID -ne 0 ]; then
      echo -e "\e[31mYou should be ruuning this script as root user or sudo this script \e[0m"
      exit 1
   fi
}

CHECK_STAT() {
  echo "---------------------------------" &>>${LOG}
  if [ $1 -ne 0 ]; then
    echo -e "\e[31mFAILED\e[0m"
    echo -e "\n Check log file - ${LOG} for errors"
    exit 2
  else
    echo -e "\e[32mSUSSESS\e[0m"
  fi
}
LOG=/tmp/roboshop.log
rm -f $LOG

PRINT () {
  echo "--------------$1-------------------" &>>${LOG}
  echo "$1"
}


NODEJS() {
CHECK_ROOT

PRINT "setting up nodjs repos"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${LOG}
CHECK_STAT $?


PRINT "Installing nodejs"
yum install nodejs -y &>>${LOG}
CHECK_STAT $?

PRINT "creating application user"
id roboshop &>>${LOG}
if [ $? -ne 0 ]; then
  useradd roboshop &>>${LOG}
fi
CHECK_STAT $?

PRINT "Downloading ${COMPONENT} content"
curl -s -L -o /tmp/${COMPONENT}.zip "https://github.com/roboshop-devops-project/${COMPONENT}/archive/main.zip" &>>${LOG}
CHECK_STAT $?


cd /home/roboshop

PRINT "remove old content"
rm -rf ${COMPONENT} &>>${LOG}
CHECK_STAT $?

PRINT "extract ${COMPONENT} content"
unzip /tmp/${COMPONENT}.zip &>>${LOG}
CHECK_STAT $?


mv ${COMPONENT}-main ${COMPONENT}
cd ${COMPONENT}

PRINT "install nodjs dependencies for ${COMPONENT} component"
npm install &>>${LOG}
CHECK_STAT $?

PRINT "update systemd configuration"
sed -i -e 's/REDIS_ENDPOINT/redis.roboshop.internal/' -e 's/CATALOGUE_ENDPOINT/catalogue.roboshop.internal/' -e 's/MONGO_ENDPOINT/mongodb.roboshop.internal/' -e 's/MONGO_DNSNAME/mongodb.roboshop.internal/' /home/roboshop/${COMPONENT}/systemd.service &>>${LOG}
CHECK_STAT $?

PRINT "setup systemd conf"
mv /home/roboshop/${COMPONENT}/systemd.service /etc/systemd/system/${COMPONENT}.service &>>${LOG} && systemctl daemon-reload
CHECK_STAT $?

PRINT "restart ${COMPONENT} service"
systemctl enable ${COMPONENT} &>>${LOG} && systemctl restart ${COMPONENT} &>>${LOG}
CHECK_STAT $?

}

NGINX() {
  CHECK_ROOT

 echo "Install nginx"
 yum install nginx -y &>>${LOG}
 CHECK_STAT $?

PRINT "Download ${COMPONENT} content"
 curl -s -L -o /tmp/${COMPONENT}.zip "https://github.com/roboshop-devops-project/${COMPONENT}/archive/main.zip"
CHECK_STAT $?

PRINT "Clean old content"
 cd /usr/share/nginx/html
 rm -rf * &>>${LOG}
 CHECK_STAT $?

 PRINT "extract ${COMPONENT} content "
 unzip /tmp/${COMPONENT}.zip
 CHECK_STAT $?

 PRINT "Configure ${COMPONENT} "
 mv ${COMPONENT}-main/* . && mv static/* .&& rm -rf ${COMPONENT}-main README.md && mv localhost.conf /etc/nginx/default.d/roboshop.conf
  CHECK_STAT $?

PRINT "update ${COMPONENT} configuration "
 sed -i -e '/catalogue/ s/localhost/catalogue.roboshop.internal/' -e '/user/ s/localhost/user.roboshop.internal/' -e '/cart/ s/localhost/cart.roboshop.internal/' -e '/payment/ s/localhost/payment.roboshop.internal/' -e '/shipping/ s/localhost/shipping.roboshop.internal/' /etc/nginx/default.d/roboshop.conf

PRINT " Start Nginx Service"
systemctl enable nginx &>>${LOG} && systemctl restart nginx &>>${LOG}
CHECK_STAT $?

}