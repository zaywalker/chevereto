ARG PHP_VERSION=apache
FROM alpine as downloader

RUN apk add --no-cache curl && \

FROM php:$PHP_VERSION

RUN apt-get update && apt-get install -y \
        libgd-dev && \
    docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ && \
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
ENV CHEVERETO_DB_HOST=db CHEVERETO_DB_USERNAME=chevereto CHEVERETO_DB_PASSWORD=chevereto CHEVERETO_DB_NAME=chevereto CHEVERETO_DB_PREFIX=chv_ CHEVERETO_DB_PORT=3306
