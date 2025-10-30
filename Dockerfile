# docker/php/Dockerfile
FROM php:8.2-fpm-alpine

# Paquets + extensions PHP necessàries per Laravel + SQLite
RUN set -eux; \
    apk add --no-cache --virtual .build-deps $PHPIZE_DEPS icu-dev sqlite-dev oniguruma-dev libzip-dev; \
    apk add --no-cache icu sqlite-libs git unzip; \
    docker-php-ext-configure intl; \
    docker-php-ext-install -j"$(nproc)" pdo_sqlite bcmath intl mbstring; \
    docker-php-ext-enable opcache; \
    apk del .build-deps

# Afegim Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Afegim el codi de Laravel a la imatge
COPY . /var/www/html

WORKDIR /var/www/html

# Usuari no root
RUN addgroup -g 1000 laravel && adduser -G laravel -g laravel -D -u 1000 laravel
USER laravel

# Instal·lem les dependències de PHP amb Composer
RUN composer install --no-dev --optimize-autoloader
