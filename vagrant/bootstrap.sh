#!/bin/sh

  
    apt-get -y update
      if [ ! -f /vagrant/init ]; then
    . /vagrant/bootstrap.cfg
    export DEBIAN_FRONTEND=noninteractive
    apt-get -y install vim mc git build-essential curl python-software-properties zip unzip expect locate 
    add-apt-repository ppa:svn/ppa
    add-apt-repository ppa:chris-lea/node.js 
    apt-get -y update
    apt-get install -y subversion nodejs npm 
    if [ ! -f /etc/apache2/apache2.conf ];
    then
        echo "mysql-server mysql-server/root_password password $mysql_password" | debconf-set-selections
        echo "mysql-server mysql-server/root_password_again password $mysql_password" | debconf-set-selections
        apt-get -y install mysql-server mysql-client
        apt-get install -y apache2
        apt-get -y install php5 libapache2-mod-php5 php-apc php5-mysql php5-dev php-pear libcurl4-openssl-dev php5-xdebug

        pecl install pecl_http
        echo "extension=http.so" > /etc/php5/conf.d/http.ini
        ln -s /vagrant/custom.ini /etc/php5/conf.d/custom.ini
       
        echo "<?php phpinfo(); " > /var/www/index.php
        unlink /var/www/index.html

        a2enmod rewrite
        a2enmod expires
        a2enmod headers
        usermod -a -G vagrant www-data
        npm install less

        echo 'phpmyadmin phpmyadmin/dbconfig-install boolean false' | debconf-set-selections
        echo 'phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2' | debconf-set-selections

        echo "phpmyadmin phpmyadmin/app-password-confirm password $mysql_password" | debconf-set-selections
        echo "phpmyadmin phpmyadmin/mysql/admin-pass password $mysql_password" | debconf-set-selections
        echo "phpmyadmin phpmyadmin/password-confirm password $mysql_password" | debconf-set-selections
        echo "phpmyadmin phpmyadmin/setup-password password $mysql_password" | debconf-set-selections
        echo 'phpmyadmin phpmyadmin/database-type select mysql' | debconf-set-selections
        echo "phpmyadmin phpmyadmin/mysql/app-pass password $mysql_password" | debconf-set-selections

        apt-get install -y phpmyadmin
        ln -s /etc/phpmyadmin/apache.conf /etc/apache2/conf.d/phpmyadmin.conf
        ln -s /vagrant/vhosts/ /etc/apache2/conf.d/.
        
        service apache2 restart
        service mysql restart

        curl -sS https://getcomposer.org/installer | php
        mv composer.phar /usr/local/bin/composer
        chmod a+x /usr/local/bin/composer

        update-locale LANG=de_DE.UTF-8 LC_MESSAGES=POSIX
        echo "Europe/Berlin" | sudo tee /etc/timezone
        sudo dpkg-reconfigure --frontend noninteractive tzdata
    fi
    touch /vagrant/init
fi

    sudo apt-get autoclean -y
    sudo apt-get autoremove -y
  



