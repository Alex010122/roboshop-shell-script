source component/comman.sh
CHECK_ROOT

PRINT " setup yum repo"
 curl -L https://raw.githubusercontent.com/roboshop-devops-project/redis/main/redis.repo -o /etc/yum.repos.d/redis.repo &>>${LOG}
 CHECK_STAT $?

 PRINT " install redis"
 yum install redis-6.2.7 -y &>>${LOG}
CHECK_STAT $?

PRINT "Configure redis config"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/redis.conf /etc/redis/redis.conf &>>${LOG}
CHECK_STAT $?

#2. Update the `bind` from `127.0.0.1` to `0.0.0.0` in config file `/etc/redis.conf` & `/etc/redis/redis.conf`



PRINT "Start Redis Database"
systemctl enable redis &>>${LOG} && systemctl restart redis &>>${LOG}