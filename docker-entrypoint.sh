#!/bin/sh
set -eu

DB_HOST="${DB_HOST:-localhost}"
DB_PORT="${DB_PORT:-1433}"
DB_NAME="${DB_NAME:-PRJ301_ASSIGNMENT}"
DB_USER="${DB_USER:-sa}"
DB_PASSWORD="${DB_PASSWORD:-Alonept2}"
DB_ENCRYPT="${DB_ENCRYPT:-True}"
DB_TRUST_SERVER_CERT="${DB_TRUST_SERVER_CERT:-True}"
DB_EXTRA_PARAMS="${DB_EXTRA_PARAMS:-sendStringParametersAsUnicode=true;characterEncoding=UTF-8}"
RESEND_API_KEY="${RESEND_API_KEY:-}"
RESEND_SEND_DOMAIN="${RESEND_SEND_DOMAIN:-resend.dev}"
SKIP_DB_IMPORT="${SKIP_DB_IMPORT:-false}"
DB_IMPORT_RETRIES="${DB_IMPORT_RETRIES:-20}"
DB_IMPORT_RETRY_DELAY="${DB_IMPORT_RETRY_DELAY:-5}"
APP_DIR="/usr/local/tomcat/webapps/ROOT"
WAR_FILE="/usr/local/tomcat/webapps/ROOT.war"
PROPHET_START_SCRIPT="/opt/app/start-prophet-server.sh"

if [ -z "${DB_URL:-}" ]; then
  DB_URL="jdbc:sqlserver://${DB_HOST}:${DB_PORT};databaseName=${DB_NAME};Encrypt=${DB_ENCRYPT};TrustServerCertificate=${DB_TRUST_SERVER_CERT};${DB_EXTRA_PARAMS}"
fi

if [ ! -d "${APP_DIR}" ]; then
  mkdir -p "${APP_DIR}"
  (cd "${APP_DIR}" && jar xf "${WAR_FILE}")
  rm -f "${WAR_FILE}"
fi

APP_ENV_FILE="${APP_DIR}/WEB-INF/.env"
cat > "${APP_ENV_FILE}" <<EOF
RESEND_API_KEY=${RESEND_API_KEY}
RESEND_SEND_DOMAIN=${RESEND_SEND_DOMAIN}
DB_URL=${DB_URL}
DB_HOST=${DB_HOST}
DB_PORT=${DB_PORT}
DB_NAME=${DB_NAME}
DB_USER=${DB_USER}
DB_PASSWORD=${DB_PASSWORD}
DB_ENCRYPT=${DB_ENCRYPT}
DB_TRUST_SERVER_CERT=${DB_TRUST_SERVER_CERT}
DB_EXTRA_PARAMS=${DB_EXTRA_PARAMS}
EOF

if [ "${SKIP_DB_IMPORT}" = "true" ] || [ "${SKIP_DB_IMPORT}" = "1" ]; then
  echo "Skipping database import because SKIP_DB_IMPORT=${SKIP_DB_IMPORT}."
else
  if [ ! -f "/opt/app/database/sql.sql" ]; then
    echo "SQL file /opt/app/database/sql.sql not found, skipping import."
  else
    echo "Preparing SQL import for database ${DB_NAME}."
    sed "s/PRJ301_ASSIGNMENT/${DB_NAME}/g" /opt/app/database/sql.sql > /tmp/import.sql

    i=1
    while [ "${i}" -le "${DB_IMPORT_RETRIES}" ]; do
      echo "Running SQL import attempt ${i}/${DB_IMPORT_RETRIES}..."
      if sqlcmd -C -S "${DB_HOST},${DB_PORT}" -U "${DB_USER}" -P "${DB_PASSWORD}" -i /tmp/import.sql; then
        echo "Database import completed successfully."
        break
      fi

      if [ "${i}" -eq "${DB_IMPORT_RETRIES}" ]; then
        echo "Database import failed after ${DB_IMPORT_RETRIES} attempts."
        exit 1
      fi

      i=$((i + 1))
      sleep "${DB_IMPORT_RETRY_DELAY}"
    done
  fi
fi

if [ -x "${PROPHET_START_SCRIPT}" ]; then
  echo "Starting Prophet server using ${PROPHET_START_SCRIPT}..."
  "${PROPHET_START_SCRIPT}" &
else
  echo "Prophet start script not found or not executable at ${PROPHET_START_SCRIPT}, skipping."
fi

exec catalina.sh run
