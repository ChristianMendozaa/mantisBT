#!/bin/sh
set -e

CONFIG_FILE="/var/www/html/config/config_inc.php"

: "${MANTIS_DB_TYPE:=pgsql}"
: "${MANTIS_DB_HOST:=localhost}"
: "${MANTIS_DB_PORT:=5432}"
: "${MANTIS_DB_USER:=mantis}"
: "${MANTIS_DB_PASSWORD:=mantis}"
: "${MANTIS_DB_NAME:=mantisbt}"

: "${MANTIS_BASE_URL:=http://localhost}"
: "${MANTIS_ADMIN_EMAIL:=admin@example.com}"

if [ ! -f "$CONFIG_FILE" ]; then
  echo ">> Creando config_inc.php"

  cat > "$CONFIG_FILE" <<EOF
<?php
\$g_hostname               = '${MANTIS_DB_HOST}';
\$g_db_type                = 'pgsql';
\$g_database_name          = '${MANTIS_DB_NAME}';
\$g_db_username            = '${MANTIS_DB_USER}';
\$g_db_password            = '${MANTIS_DB_PASSWORD}';
\$g_db_port                = ${MANTIS_DB_PORT};

\$g_default_timezone       = 'America/La_Paz';
\$g_crypto_master_salt     = '$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 32)';

\$g_path                   = '${MANTIS_BASE_URL}/';

\$g_webmaster_email        = '${MANTIS_ADMIN_EMAIL}';
\$g_from_email             = '${MANTIS_ADMIN_EMAIL}';
\$g_return_path_email      = '${MANTIS_ADMIN_EMAIL}';
EOF

  chown www-data:www-data "$CONFIG_FILE"
fi

echo ">> Iniciando Apache..."
apache2-foreground
