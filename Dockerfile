# Based on php:7.4-apache
FROM php:7.4-apache

# Maintainer label by
LABEL maintainer "Jaeyoon KIM <zaywalker@gmail.com>"

# Install some packages required
RUN apt-get update && apt-get install -y \
        curl \
        libgd-dev \
        libwebp-dev \
        libzip-dev \
        zip && \
    docker-php-ext-configure gd --with-freetype=/usr/include/ --with-jpeg=/usr/include/ --with-webp=/usr/include/ && \
    docker-php-ext-install \
        exif \
        gd \
        mysqli \
        pdo \
        pdo_mysql \
        zip && \
    a2enmod rewrite

# Expose the html directory as a volume
VOLUME /var/www/html

# DB connection environment variables
# ENV CHEVERETO_DB_HOST=db CHEVERETO_DB_USERNAME=chevereto CHEVERETO_DB_PASSWORD=chevereto CHEVERETO_DB_NAME=chevereto CHEVERETO_DB_PREFIX=chv_ CHEVERETO_DB_PORT=3306

# Copy entrypoint to get installer.php and run apache2 foreground
COPY docker-entrypoint.sh /

# Change attribute docker-entrypoint.sh to make excutable
RUN chmod +x /docker-entrypoint.sh

# Entrypoint to get installer.php and run apache2 foreground
ENTRYPOINT /docker-entrypoint.sh
