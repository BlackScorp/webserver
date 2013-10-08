#!/bin/sh
    apt-get -y update
    if [ ! -f /vagrant/init ]; then
        export DEBIAN_FRONTEND=noninteractive
        #Install basic apps
        apt-get -y install vim mc git build-essential curl python-software-properties zip unzip expect locate grub

        add-apt-repository ppa:svn/ppa -y
        add-apt-repository ppa:chris-lea/node.js -y
	add-apt-repository ppa:ondrej/php5 -y
	add-apt-repository ppa:ondrej/apache2 -y
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
	echo "phpmyadmin phpmyadmin/database-type select mysql" | debconf-set-selections
	
        #install webserver
        apt-get install -y subversion nodejs graphviz
        apt-get install -y mysql-server mysql-client
        apt-get install -y php5 libapache2-mod-php5 php-apc php5-mysql php5-dev php-pear libcurl4-openssl-dev php5-xdebug php5-gd php5-sqlite
        apt-get install -y apache2 phpmyadmin

        #enable apache modules
        a2enmod rewrite
        a2enmod expires
        a2enmod headers

        usermod -a -G vagrant www-data
        #install pecl
     
        pecl install pecl_http
        pecl config-set preferred_state beta
        pecl install xhprof
        pecl config-set preferred_state stable
        #install npm
        curl https://npmjs.org/install.sh | sh
        npm install -g less
        #install composer
        curl -sS https://getcomposer.org/installer | php
        mv composer.phar /usr/local/bin/composer
        chmod a+x /usr/local/bin/composer
        #link files
        ln -s /etc/phpmyadmin/apache.conf /etc/apache2/conf-available/phpmyadmin.conf
        ln -s /vagrant/vhosts/example.conf /etc/apache2/conf-available/example.conf
	a2enconf phpmyadmin
	a2enconf example
        ln -s /vagrant/ini/cli.ini /etc/php5/cli/conf.d/custom.ini
	ln -s /vagrant/ini/apache2.ini /etc/php5/apache2/conf.d/custom.ini
        ln -s /usr/share/php/xhprof_html /var/www/xhprof
        echo "<?php phpinfo(); " > /var/www/index.php
        unlink /var/www/index.html
        #set locale and timezone
        update-locale LANG="$lang" LC_MESSAGES=POSIX
        echo $timezone > /etc/timezone
        #create ini file
        touch /vagrant/init
    fi
    service apache2 restart
    apt-get upgrade -y
    apt-get autoremove -y
    apt-get autoclean -y
