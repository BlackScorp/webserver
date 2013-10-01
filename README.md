webserver
=========

#My Personal Vagrant webserver

## How to use
* Install and Download [Virtual Box](https://www.virtualbox.org/wiki/Downloads)
* Install and Download [Vagrant](http://downloads.vagrantup.com/)
* Install and Download [Putty Installer] (http://www.chiark.greenend.org.uk/~sgtatham/putty/download.html)
* Download this [Repository](https://github.com/BlackScorp/webserver/archive/master.zip)
* Unzip it (e.g C:/)
* Edit C:/webserver-master/vagrant/bootstrap.cfg setup your MySQL Root Password and Timezone
* (Optional) Edit ini/cli.ini and ini/apache2.ini
* Execute C:/webserver-master/vagrant/control/start.bat
* you can save your php files in C:/webserver-master/projects

## vagrant/control
* start.bat - starting/installing webserver
* shutdown.bat - stoppin webserver
* destroy.bat - deletes webserver
* restart.bat - restarts webserver

## paths

* [phpmyadmin](http://localhost:2200/phpmyadmin)
* [xhprof](http://localhost:2200/xhprof)
* [phpinfo](http://localhost:2200)
* [example](http://localhost:2200/example)

## new path
* Copy and paste C:/webserver-master/vagrant/vhosts/example.conf to mytest.conf
* Edit info in mytest.conf
* Open putty and connect to your server IP: vagrant@127.0.0.1 Port:2222 Password: vagrant
* Type in console sudo a2enconf mytest
* Type in console sudo apache2 reload
* Open in windows localhost:2200/<alias name you used in mytest.conf>