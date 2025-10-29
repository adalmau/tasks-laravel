# Utilitzar la imatge oficial de PHP amb Alpine
FROM php:8.2-fpm-alpine

# Instal·lar dependències necessàries
RUN set -eux; \
    apk add --no-cache --virtual .build-deps $PHPIZE_DEPS icu-dev sqlite-dev oniguruma-dev libzip-dev; \
    apk add --no-cache icu sqlite-libs git unzip bash libpng-dev libjpeg-turbo-dev freetype-dev libxml2-dev zip; \
    # Instal·lar les extensions de PHP
    docker-php-ext-configure gd --with-freetype --with-jpeg && \
    docker-php-ext-install gd pdo pdo_mysql xml intl opcache && \
    docker-php-ext-configure intl && \
    docker-php-ext-install pdo_sqlite bcmath intl mbstring && \
    # Eliminar dependències de compilació
    apk del .build-deps icu-dev libxml2-dev libpng-dev libjpeg-turbo-dev freetype-dev

# Instal·lar Composer
RUN curl -sS https://getcomposer.org/installer | php -- \
    --install-dir=/usr/local/bin --filename=composer

# Configurar el directori de treball
WORKDIR /app

# Copiar els arxius del projecte a la imatge
COPY . .

# Instal·lar les dependències de Laravel
RUN rm -rf /app/vendor /app/composer.lock && \
    composer install

# Instal·lar Laravel Octane i RoadRunner
RUN composer require laravel/octane spiral/roadrunner

# Crear els directoris necessaris per Laravel
RUN mkdir -p /app/storage/logs

# Instal·lar Octane (s'assegura que estigui configurat correctament)
RUN php artisan octane:install --server="swoole"

# Començar el servidor Octane
CMD ["php", "artisan", "octane:start", "--server=swoole", "--host=0.0.0.0"]

# Exposar el port 8000
EXPOSE 8000
