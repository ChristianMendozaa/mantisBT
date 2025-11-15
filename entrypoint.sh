#!/bin/sh
set -e

# Valores por defecto
: "${MANTIS_DB_TYPE:=mysqli}"
: "${MANTIS_DB_HOST:=localhost}"
: "${MANTIS_DB_USER:=mantis}"
: "${MANTIS_DB_PASSWORD:=mantis}"
: "${MANTIS_DB_NAME:=mantisbt}"
: "${MANTIS_ADMIN_USER:=admin}"
: "${MANTIS_ADMIN_EMAIL:=admin@example.com}"
: "${MANTIS_ADMIN_PASS:=admin123}"
: "${MANTIS_BASE_URL:=http://localhost}"

CONFIG_FILE="/var/www/html/config/config_inc.php"

if [ ! -f "$CONFIG_FILE" ]; then
  echo ">> Generando $CONFIG_FILE"

  cat > "$CONFIG_FILE" <<EOF
<?php
\$g_hostname               = '${MANTIS_DB_HOST}';
\$g_db_username            = '${MANTIS_DB_USER}';
\$g_db_password            = '${MANTIS_DB_PASSWORD}';
\$g_database_name          = '${MANTIS_DB_NAME}';
\$g_db_type                = '${MANTIS_DB_TYPE}';

\$g_default_timezone       = 'America/La_Paz';
\$g_crypto_master_salt     = '$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 32)';

\$g_webmaster_email        = '${MANTIS_ADMIN_EMAIL}';
\$g_from_email             = '${MANTIS_ADMIN_EMAIL}';
\$g_return_path_email      = '${MANTIS_ADMIN_EMAIL}';

\$g_window_title           = 'MantisBT';
\$g_path                   = '${MANTIS_BASE_URL}/';
\$g_allow_signup           = OFF;
EOF

  chown www-data:www-data "$CONFIG_FILE"
fi

echo ">> Iniciando Apache..."
apache2-foreground
