source component/comman.sh
CHECK_ROOT

PRINT " Setup yum repos"
yum install https://github.com/rabbitmq/erlang-rpm/releases/download/v23.2.6/erlang-23.2.6-1.el7.x86_64.rpm -y
CHECK_STAT $?

PRINT " Install Erlang"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | sudo bash
CHECK_STAT $?

PRINT " Start Rabitmq service"
yum install rabbitmq-server -y
CHECK_STAT $?

systemctl enable rabbitmq-server
systemctl start rabbitmq-server
rabbitmqctl add_user roboshop roboshop123
rabbitmqctl set_user_tags roboshop administrator
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"
