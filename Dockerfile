# Utilitzar la imatge oficial de PHP amb Alpine
FROM php:8.2-fpm-alpine

# Instal·lar dependències necessàries
RUN set -eux; \
    apk add --no-cache --virtual .build-deps $PHPIZE_DEPS icu-dev sqlite-dev oniguruma-dev libzip-dev; \
    apk add --no-cache icu sqlite-libs git unzip; \
    apk add --no-cache \
    bash \
    git \
    libpng-dev \
    libjpeg-turbo-dev \
    libfreetype6-dev \
    libxml2-dev \
    icu-dev \
    zip \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd pdo pdo_mysql xml intl opcache \
    && docker-php-ext-configure intl; \
    && docker-php-ext-install -j"$(nproc)" pdo_sqlite bcmath intl mbstring; \
    && docker-php-ext-enable opcache; \
    && apk del icu-dev libxml2-dev libpng-dev libjpeg-turbo-dev libfreetype6-dev

# Instal·lar Composer
RUN curl -sS https://getcomposer.org/installer | php -- \
    --install-dir=/usr/local/bin --filename=composer

# Instal·lar dependències de Laravel Octane (inclou roadrunner)
RUN curl -sS https://getcomposer.org/installer | php -- \
    --install-dir=/usr/local/bin --filename=composer

# Configurar el directori de treball
WORKDIR /app

# Copiar els arxius del projecte a la imatge
COPY . .

# Instalar les dependències de Laravel
RUN rm -rf /app/vendor
RUN rm -rf /app/composer.lock
RUN composer install

# Instalar Octane i RoadRunner
RUN composer require laravel/octane spiral/roadrunner

# Crear els directoris necessaris per Laravel
RUN mkdir -p /app/storage/logs

# Netegem la configuració de la caché
RUN php artisan cache:clear
RUN php artisan view:clear
RUN php artisan config:clear

# Instal·lar Octane
RUN php artisan octane:install --server="swoole"

# Començar el servidor Octane
CMD php artisan octane:start --server="swoole" --host="0.0.0.0"

# Exposar el port 8000
EXPOSE 8000
