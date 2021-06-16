#!/bin/bash
#sudo apt-get upgrade -y
#wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
#sudo sh -c 'echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list'
#sudo apt-get update
#sudo apt-get install google-chrome-stable
sudo apt-get install apt-transport-https ca-certificates curl -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository \
       "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
       $(lsb_release -cs) \
       edge"
sudo apt-get update 
sleep 8
sudo apt install docker-ce mc htop wget git mariadb-client-10.1 -y
sudo systemctl enable docker
sudo systemctl start docker
sudo usermod -aG docker $USER
sudo  mkdir -p -m 0777 /var/www
mkdir /var/www/magento1 /var/www/magento2 /var/www/nginx_conf /var/www/log 
wget http://conf.m-dev.info/devmagento1.conf -P /var/www/nginx_conf/
wget http://conf.m-dev.info/devmagento2.conf -P /var/www/nginx_conf/
sudo docker pull magecom/maria
sudo docker pull magecom/nginx
sudo docker pull magecom/php:dev7
sudo docker pull magecom/php:dev56
sudo docker pull magecom/php:dev71
sudo docker pull magecom/php:dev72
sudo docker rm -f php7 php71 php nginx myadmin mysql 
sudo docker network  rm net
sudo docker network create net
sudo docker run -dti --restart always --net net --name mysql -v /var/www/mysql/:/var/lib/mysql/ -e MARIADB_PASS="admin" -p 3306:3306 magecom/maria
sudo docker run -dti --restart always --net net -u apache --name php7  -v /var/www/:/var/www/ magecom/php:dev7
sudo docker run -dti --restart always --net net --name php -v /var/www/:/var/www/ magecom/php:dev56
sudo docker run -dti --restart always --net net -u apache --name php71  -v /var/www/:/var/www/ magecom/php:dev71
sudo docker run -dti --restart always --net net -u apache --name php72  -v /var/www/:/var/www/ magecom/php:dev72
sudo docker run -dti --restart always --net net -u apache --name php73  -v /var/www/:/var/www/ magecom/php:dev73
sudo docker run -dti --restart always --net net --name nginx -p80:80 -v /var/www/:/var/www/ -v /var/www/nginx_conf/:/etc/nginx/conf.d/ magecom/nginx
sudo docker run -dti --restart always --net net -e MYSQL_USERNAME=root -e MYSQL_PORT_3306_TCP_ADDR=mysql -p 8080:80 --name myadmin corbinu/docker-phpmyadmin
## Add UID GUID localuser to user apache in php-fpm
uid=`id -u $USER`
guid=`id -g $USER`
sudo docker exec -it -u root php usermod -u $uid apache
sudo docker exec -it -u root php7 usermod -u $uid apache
sudo docker exec -it -u root php71 usermod -u $uid apache
sudo docker exec -it -u root php groupmod -g $guid apache
sudo docker exec -it -u root php7 groupmod -g $guid apache
sudo docker exec -it -u root php71 groupmod -g $guid apache
sudo docker exec -it -u root php72 usermod -u $uid apache
sudo docker exec -it -u root php72 groupmod -g $guid apache
sudo docker exec -it nginx groupmod -g $guid nginx
sudo docker exec -it nginx usermod -u $uid nginx
sudo docker restart php php7 php71 php72 nginx
sudo chmod a+w /etc/hosts
