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
source component/comman.sh
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

PRINT "DownloADING CARt content"
curl -s -L -o /tmp/cart.zip "https://github.com/roboshop-devops-project/cart/archive/main.zip" &>>${LOG}
CHECK_STAT $?


cd /home/roboshop

PRINT "remove old content"
rm -rf cart &>>${LOG}
CHECK_STAT $?

PRINT "extract cart content"
unzip /tmp/cart.zip &>>${LOG}
CHECK_STAT $?


mv cart-main cart
cd cart

PRINT "install nodjs dependencies"
npm install &>>${LOG}
CHECK_STAT $?

PRINT "update systemd configuration"
sed -i -e 's/REDIS_ENDPOINT/redis.roboshop.internal/' -e 's/CATALOGUE_ENDPOINT/catalogue.roboshop.internal/' /home/roboshop/cart/systemd.service &>>${LOG}
CHECK_STAT $?

PRINT "setup systemd conf"
mv /home/roboshop/cart/systemd.service /etc/systemd/system/cart.service &>>${LOG}
CHECK_STAT $?


systemctl daemon-reload
systemctl enable cart

PRINT "start cart service"
systemctl restart cart &>>${LOG}
CHECK_STAT $?

}