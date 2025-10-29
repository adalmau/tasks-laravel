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

WORKDIR /var/www/html

# Copiar el projecte Laravel dins de la imatge
COPY . .

# Usuari no root
RUN addgroup -g 1000 laravel && adduser -G laravel -g laravel -D -u 1000 laravel
USER laravel

# Fase 2: Configurar Nginx
FROM nginx:alpine as final

# Copiar fitxers de configuració de Nginx
COPY ./nginx/default.conf /etc/nginx/conf.d/default.conf

# Copiar la carpeta amb el codi del projecte Laravel
COPY --from=base /var/www/html /var/www/html

# Exposar el port per a l'aplicació
EXPOSE 80

# Comandar per executar Nginx
CMD ["nginx", "-g", "daemon off;"]