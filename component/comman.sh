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