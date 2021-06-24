FROM php:8.0-fpm
MAINTAINER Victor Apostol <apostol.victor@gmail.com>
ENV LAST_UPDATED 2021-04-24-c
RUN pecl install redis-5.3.3 \
    && docker-php-ext-enable redis

RUN docker-php-ext-install mysqli pdo pdo_mysql bcmath
RUN apt-get update && apt-get install -y libfreetype6-dev libjpeg62-turbo-dev libpng-dev 
RUN docker-php-ext-configure gd --with-freetype --with-jpeg
RUN docker-php-ext-install -j$(nproc) gd
RUN docker-php-ext-install sockets

RUN apt-get install -y \
        libzip-dev \
        zip \
  && docker-php-ext-install zip

RUN apt-get install -y libicu-dev \ 
&& docker-php-ext-configure intl \
&& docker-php-ext-install intl

RUN curl -o /tmp/composer-setup.php https://getcomposer.org/installer \
  && curl -o /tmp/composer-setup.sig https://composer.github.io/installer.sig \
  && php -r "if (hash('SHA384', file_get_contents('/tmp/composer-setup.php')) !== trim(file_get_contents('/tmp/composer-setup.sig'))) { unlink('/tmp/composer-setup.php'); echo 'Invalid installer' . PHP_EOL; exit(1); }"
ENV COMPOSER_VERSION 2.0.9

# Install Composer
RUN php /tmp/composer-setup.php --no-ansi --install-dir=/usr/local/bin --filename=composer --version=${COMPOSER_VERSION} && rm -rf /tmp/composer-setup.php


RUN curl -fsSL https://deb.nodesource.com/setup_14.x | bash -

RUN apt-get -y install unzip zip nodejs sqlite3
RUN npm install --global yarn

RUN docker-php-ext-configure pcntl --enable-pcntl
RUN docker-php-ext-install pcntl
