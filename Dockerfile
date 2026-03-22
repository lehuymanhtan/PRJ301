FROM maven:3.9.9-eclipse-temurin-11 AS builder
WORKDIR /build

COPY pom.xml ./
COPY src ./src
RUN mvn -B -DskipTests clean package

FROM tomcat:10.1-jdk17-temurin
USER root

RUN apt-get update \
    && apt-get install -y --no-install-recommends curl gnupg ca-certificates apt-transport-https \
    && curl -fsSL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > /usr/share/keyrings/microsoft-prod.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/microsoft-prod.gpg] https://packages.microsoft.com/debian/12/prod bookworm main" > /etc/apt/sources.list.d/microsoft-prod.list \
    && apt-get update \
    && ACCEPT_EULA=Y apt-get install -y --no-install-recommends mssql-tools18 unixodbc \
    && rm -rf /var/lib/apt/lists/*

ENV PATH="${PATH}:/opt/mssql-tools18/bin"
ENV DB_HOST=localhost \
    DB_PORT=1433 \
    DB_NAME=PRJ301 \
    DB_USER=sa \
    DB_PASSWORD=password \
    DB_ENCRYPT=True \
    DB_TRUST_SERVER_CERT=True \
    DB_EXTRA_PARAMS="sendStringParametersAsUnicode=true;characterEncoding=UTF-8" \
    SKIP_DB_IMPORT=false \
    DB_IMPORT_RETRIES=20 \
    DB_IMPORT_RETRY_DELAY=5 \
    RESEND_API_KEY=resend_api_key \
    RESEND_SEND_DOMAIN=your-domain.resend.dev

WORKDIR /opt/app
COPY --from=builder /build/target/PRJ301-1.0-SNAPSHOT.war /usr/local/tomcat/webapps/ROOT.war
COPY database/sql.sql /opt/app/database/sql.sql
COPY start-prophet-server.sh /opt/app/start-prophet-server.sh
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh /opt/app/start-prophet-server.sh

EXPOSE 8080
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
