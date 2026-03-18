#!/bin/sh
set -eu

# Start SQL Server in background
/opt/mssql/bin/sqlservr &
MSSQL_PID=$!

# Wait until SQL Server accepts queries
SQLCMD="/opt/mssql-tools18/bin/sqlcmd"
SQL_READY=0
for i in $(seq 1 60); do
  if "$SQLCMD" -C -S localhost -U sa -P "${MSSQL_SA_PASSWORD}" -Q "SELECT 1" >/dev/null 2>&1; then
    SQL_READY=1
    break
  fi
  sleep 2
done

if [ "$SQL_READY" -ne 1 ]; then
  echo "SQL Server did not become ready in time."
  exit 1
fi

# Ensure target database exists
"$SQLCMD" -C -S localhost -U sa -P "${MSSQL_SA_PASSWORD}" -Q "IF DB_ID(N'PRJ301_ASSIGNMENT') IS NULL CREATE DATABASE PRJ301_ASSIGNMENT;"

# Seed schema/data only once if the script exists
DB_INIT_MARKER="/var/opt/mssql/.prj301_db_initialized"
if [ -f /app/database/sql.sql ] && [ ! -f "$DB_INIT_MARKER" ]; then
  "$SQLCMD" -C -S localhost -U sa -P "${MSSQL_SA_PASSWORD}" -d PRJ301_ASSIGNMENT -i /app/database/sql.sql
  touch "$DB_INIT_MARKER"
fi

# Start Prophet API so the Java app can call localhost:8000
cd /app/model
/app/model/.venv/bin/uvicorn server.main:app --host "${PROPHET_HOST:-0.0.0.0}" --port "${PROPHET_PORT:-8000}" &
PROPHET_PID=$!

# Fail fast if Prophet crashes during startup
sleep 3
if ! kill -0 "$PROPHET_PID" 2>/dev/null; then
  echo "Prophet server failed to start."
  exit 1
fi

if ! kill -0 "$MSSQL_PID" 2>/dev/null; then
  echo "SQL Server process is not running."
  exit 1
fi

cd /usr/local/tomcat
exec catalina.sh run
