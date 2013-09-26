#!/bin/sh
    apt-get -y update
    if [ ! -f /vagrant/init ]; then
        export DEBIAN_FRONTEND=noninteractive
        #Install basic apps
        apt-get -y install vim mc git build-essential curl python-software-properties zip unzip expect locate

        add-apt-repository ppa:svn/ppa -y
        add-apt-repository ppa:chris-lea/node.js -y
        apt-get -y update

        #set configs from bootstrap.cfg
        . /vagrant/bootstrap.cfg
        echo "mysql-server mysql-server/root_password password $mysql_password" | debconf-set-selections
        echo "mysql-server mysql-server/root_password_again password $mysql_password" | debconf-set-selections
        echo "phpmyadmin phpmyadmin/dbconfig-install boolean false" | debconf-set-selections
        echo "phpmyadmin phpmyadmin/reconfigure-webserver multiselect none" | debconf-set-selections
        echo "phpmyadmin phpmyadmin/mysql/admin-pass password $mysql_password" | debconf-set-selections
        echo "phpmyadmin phpmyadmin/password-confirm password $mysql_password" | debconf-set-selections
        echo "phpmyadmin phpmyadmin/setup-password password $mysql_password" | debconf-set-selections
        echo "phpmyadmin phpmyadmin/database-type select mysql" | debconf-set-selections

        #install webserver
        apt-get install -y subversion nodejs
        apt-get install  -y mysql-server mysql-client
        apt-get install -y php5 libapache2-mod-php5 php-apc php5-mysql php5-dev php-pear libcurl4-openssl-dev php5-xdebug php5-gd
        apt-get install -y apache2 phpmyadmin

        #enable apache modules
        a2enmod rewrite
        a2enmod expires
        a2enmod headers

        #link files
        ln -s /etc/phpmyadmin/apache.conf /etc/apache2/conf.d/phpmyadmin.conf
        ln -s /vagrant/vhosts/ /etc/apache2/conf.d/.
        ln -s /vagrant/custom.ini /etc/php5/conf.d/custom.ini
        echo "<?php phpinfo(); " > /var/www/index.php
        unlink /var/www/index.html

        usermod -a -G vagrant www-data
        #install pecl
        pecl install pecl_http
        echo "extension=http.so" > /etc/php5/conf.d/http.ini
        #install npm
        curl https://npmjs.org/install.sh | sudo sh
        npm install -g less
        #install composer
        curl -sS https://getcomposer.org/installer | php
        mv composer.phar /usr/local/bin/composer
        chmod a+x /usr/local/bin/composer
        #set locale and timezone
        update-locale LANG=de_DE.UTF-8 LC_MESSAGES=POSIX
        echo "Europe/Berlin" | sudo tee /etc/timezone
        sudo dpkg-reconfigure --frontend noninteractive tzdata
        #create ini file
        touch /vagrant/init
    fi
    service apache2 restart

    apt-get autoclean -y
    apt-get autoremove -y
  



