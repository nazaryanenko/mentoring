FROM php:8.3-fpm

# Arguments defined in docker-compose.yml
ARG user
ARG uid

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    libgd-dev \
    zip \
    unzip \
    libzip-dev \
    libpq-dev && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Install PHP extensions
RUN docker-php-ext-install pdo_mysql mbstring pcntl bcmath gd zip intl exif

# Install Redis extension
RUN pecl install redis && docker-php-ext-enable redis

# Get latest Composer
COPY --from=composer /usr/bin/composer /usr/bin/composer

# Create system user to run Composer and Artisan Commands
RUN useradd -G www-data,root -u $uid -d /home/$user $user && \
    mkdir -p /home/$user/.composer && \
    chown -R $user:$user /home/$user

# Set working directory
WORKDIR /var/www

USER $user







#FROM php:8.3-fpm
#
## Arguments defined in docker-compose.yml
#ARG user
#ARG uid
#
## Install system dependencies
#RUN apt-get update && apt-get install -y \
#    git \
#    curl \
#    libpng-dev \
#    libonig-dev \
#    libxml2-dev \
#    libgd-dev \
#    zip \
#    unzip \
#    libzip-dev \
#    libpq-dev
## Clear cache
#RUN apt-get clean && rm -rf /var/lib/apt/lists/*
#
## Install PHP extensions
#RUN docker-php-ext-install pdo_mysql mbstring pcntl bcmath gd zip intl exif
#
#
#RUN pecl install redis
#RUN docker-php-ext-enable redis
## Get latest Composer
#COPY --from=composer /usr/bin/composer /usr/bin/composer
#
## Create system user to run Composer and Artisan Commands
#RUN useradd -G www-data,root -u $uid -d /home/$user $user
#RUN mkdir -p /home/$user/.composer && \
#    chown -R $user:$user /home/$user
#
## Create the log file to be able to run tail
## RUN touch /var/log/ayadi_scheduler.log
#
## Extra permissions cron needs to run
#RUN chmod gu+rw /var/run
#
## Set working directory
#WORKDIR /var/www
#
#USER $user
