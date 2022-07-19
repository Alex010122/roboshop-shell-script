CHECK_ROOT (){
   USER_ID=$(id -u)
   if [ $USER_ID -ne 0 ]; then
      echo You are non root user
      echo you can run this script as root user or with sudo
      exit 1
   fi
}