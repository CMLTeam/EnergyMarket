#!/usr/bin/env bash

USER=energymarket
SERV=104.46.54.140
APP=energymarket

echo
echo "BUILD..."
echo

mvn clean package -DskipTests

echo
echo "DEPLOY..."
echo

scp $APP.conf target/$APP.jar $USER@$SERV:~/

echo
echo "RESTART..."
echo

ssh $USER@$SERV "
if [ ! -f /etc/init.d/$APP ]
then
    sudo ln -s /home/$USER/$APP.jar /etc/init.d/$APP
fi
sudo /etc/init.d/$APP restart
tail -f /var/log/$APP.log
"