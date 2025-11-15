FROM php:8.1-apache

# Instalar dependencias
RUN apt-get update && apt-get install -y \
    libpng-dev libjpeg-dev libfreetype6-dev libzip-dev unzip curl libpq-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd pdo pdo_pgsql pgsql zip \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Versión MantisBT
ENV MANTIS_VERSION=2.26.1

# Descargar MantisBT
RUN curl -L https://github.com/mantisbt/mantisbt/archive/release-${MANTIS_VERSION}.zip -o /tmp/mantis.zip \
    && unzip /tmp/mantis.zip -d /var/www/html \
    && mv /var/www/html/mantisbt-release-${MANTIS_VERSION}/* /var/www/html \
    && rm -rf /var/www/html/mantisbt-release-${MANTIS_VERSION} /tmp/mantis.zip

# Crear carpeta de configuración
RUN mkdir -p /var/www/html/config

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

RUN chown -R www-data:www-data /var/www/html

WORKDIR /var/www/html

EXPOSE 80
CMD ["entrypoint.sh"]
