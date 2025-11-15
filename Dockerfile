FROM php:8.1-apache

# Instalar dependencias
RUN apt-get update && apt-get install -y \
    libpng-dev libjpeg-dev libfreetype6-dev libzip-dev unzip curl libpq-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd pdo pdo_pgsql pgsql zip \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Versión de MantisBT
ENV MANTIS_VERSION=2.26.1

# 🔹 Descargar el paquete OFICIAL (incluye vendor/)
RUN curl -L "https://downloads.sourceforge.net/project/mantisbt/mantis-stable/${MANTIS_VERSION}/mantisbt-${MANTIS_VERSION}.tar.gz" -o /tmp/mantis.tar.gz \
    && tar -xzf /tmp/mantis.tar.gz -C /tmp \
    && mv /tmp/mantisbt-${MANTIS_VERSION}/* /var/www/html \
    && rm -rf /tmp/mantisbt-${MANTIS_VERSION} /tmp/mantis.tar.gz

# Carpeta de config
RUN mkdir -p /var/www/html/config

# Copiar entrypoint
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Permisos
RUN chown -R www-data:www-data /var/www/html

WORKDIR /var/www/html

EXPOSE 80
CMD ["entrypoint.sh"]
