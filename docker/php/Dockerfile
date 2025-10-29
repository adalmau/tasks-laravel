# Fase 1: Crear la imatge base amb PHP i les extensions necessàries per Laravel
FROM php:8.2-fpm-alpine as base

# Paquets i extensions PHP necessàries per Laravel + SQLite
RUN set -eux; \
    apk add --no-cache --virtual .build-deps $PHPIZE_DEPS icu-dev sqlite-dev oniguruma-dev libzip-dev; \
    apk add --no-cache icu sqlite-libs git unzip; \
    docker-php-ext-configure intl; \
    docker-php-ext-install -j"$(nproc)" pdo_sqlite bcmath intl mbstring; \
    docker-php-ext-enable opcache; \
    apk del .build-deps

# Afegir Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Configurar el directori de treball
WORKDIR /var/www/html

# Copiar el projecte Laravel des del directori arrel
COPY ../../.. /var/www/html

# Usuari no root
RUN addgroup -g 1000 laravel && adduser -G laravel -g laravel -D -u 1000 laravel
USER laravel

# Fase 2: Configurar Nginx
FROM nginx:alpine as final

# Copiar fitxers de configuració de Nginx
COPY ./docker/nginx/default.conf /etc/nginx/conf.d/default.conf

# Copiar el projecte Laravel des del directori arrel
COPY --from=base /var/www/html /var/www/html

# Instal·lar PHP-FPM i altres dependències
RUN apk add --no-cache php8-fpm

# Copiar el fitxer d'entrada per iniciar PHP-FPM i Nginx
COPY ./docker/entrypoint.sh /entrypoint.sh

# Establir permisos d'execució per al fitxer d'entrada
RUN chmod +x /entrypoint.sh

# Exposar els ports per a PHP-FPM i Nginx
EXPOSE 80 9000

# Comandar per executar PHP-FPM i Nginx
CMD php-fpm & nginx -g 'daemon off;'
