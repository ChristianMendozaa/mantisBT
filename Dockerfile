FROM php:8.1-apache

# Instalar dependencias necesarias
RUN apt-get update && apt-get install -y \
    libpng-dev libjpeg-dev libfreetype6-dev libzip-dev unzip curl \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd mysqli pdo pdo_mysql zip \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Versión de MantisBT
ENV MANTIS_VERSION=2.26.1

# Descargar y descomprimir MantisBT
RUN curl -L https://github.com/mantisbt/mantisbt/archive/release-${MANTIS_VERSION}.zip -o /tmp/mantis.zip \
    && unzip /tmp/mantis.zip -d /var/www/html \
    && mv /var/www/html/mantisbt-release-${MANTIS_VERSION}/* /var/www/html \
    && rm -rf /var/www/html/mantisbt-release-${MANTIS_VERSION} /tmp/mantis.zip

# Crear carpeta de configuración
RUN mkdir -p /var/www/html/config

# Copiar entrypoint
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Permisos
RUN chown -R www-data:www-data /var/www/html

WORKDIR /var/www/html

EXPOSE 80

CMD ["entrypoint.sh"]
