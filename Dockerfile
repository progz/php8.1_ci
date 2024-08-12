FROM php:8.1-bullseye

RUN apt update && apt install -y libonig-dev libxml2-dev libzip-dev unzip curl rsync openssh-server libpng-dev libc-client-dev libkrb5-dev

RUN docker-php-ext-configure imap --with-kerberos --with-imap-ssl && docker-php-ext-install mbstring pdo_mysql xml zip gd imap

RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && \
php -r "if (hash_file('sha384', 'composer-setup.php') === 'dac665fdc30fdd8ec78b38b9800061b4150413ff2e3b6f88543c636f7cd84f6db9189d43a81e5503cda447da73c7e5b6') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" && \
php composer-setup.php && \
php -r "unlink('composer-setup.php');" && \
mv composer.phar /usr/local/bin/composer

RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
unzip awscliv2.zip && \
./aws/install

RUN pecl install xdebug \
    && docker-php-ext-enable xdebug
