FROM php:7.4-apache

RUN apt-get update \
&& apt-get install -y \ 
libfreetype6-dev \
libjpeg62-turbo-dev \
libpng-dev \
libzip-dev \
&& pecl install xdebug \
&& a2enmod rewrite \ 
&& a2enmod headers

RUN docker-php-ext-configure gd --with-freetype --with-jpeg 
RUN docker-php-ext-install opcache gd pdo_mysql zip 
RUN docker-php-ext-enable opcache gd xdebug zip 

RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf
RUN service apache2 restart