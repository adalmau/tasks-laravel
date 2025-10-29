FROM php:8.2-fpm-alpine as base

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

# Configurar el directori de treball
WORKDIR /var/www/html

# Copiar el projecte Laravel des del directori arrel
COPY ../../.. /var/www/html

# Usuari no root
RUN addgroup -g 1000 laravel && adduser -G laravel -g laravel -D -u 1000 laravel
USER laravel

# Fase 2: Configurar Nginx i PHP-FPM
FROM nginx:alpine as final

# Copiar fitxers de configuració de Nginx
COPY ./docker/nginx/default.conf /etc/nginx/conf.d/default.conf

# Copiar la carpeta amb el codi del projecte Laravel
COPY --from=base /var/www/html /var/www/html

# Instal·lar PHP-FPM
RUN apk add --no-cache php8-fpm

# Configurar el directori de treball
WORKDIR /var/www/html

# Exposar el port per a l'aplicació
EXPOSE 80

# Comandar per executar Nginx i PHP-FPM
CMD ["/bin/sh", "-c", "php-fpm & nginx -g 'daemon off;'"]
