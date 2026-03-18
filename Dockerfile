# syntax=docker/dockerfile:1

# -------- Build Java WAR --------
FROM maven:3.9.11-eclipse-temurin-17 AS build
WORKDIR /build

COPY pom.xml ./
COPY src ./src
RUN mvn -DskipTests clean package

# -------- Runtime: MSSQL + Tomcat + Python Prophet in one container --------
FROM mcr.microsoft.com/mssql/server:2022-latest

ENV ACCEPT_EULA=Y \
    MSSQL_PID=Developer \
    MSSQL_SA_PASSWORD=YourStrong!Passw0rd \
    PROPHET_HOST=0.0.0.0 \
    PROPHET_PORT=8000

ARG TOMCAT_VERSION=10.1.39

WORKDIR /app

# Install Java, Tomcat runtime and Python needed by the Prophet API
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        curl \
        ca-certificates \
        mssql-tools18 \
        python3 \
        python3-pip \
        python3-venv \
        openjdk-17-jre-headless \
    && curl -fsSL "https://archive.apache.org/dist/tomcat/tomcat-10/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz" -o /tmp/tomcat.tgz \
    && mkdir -p /usr/local/tomcat \
    && tar -xzf /tmp/tomcat.tgz -C /usr/local/tomcat --strip-components=1 \
    && rm -f /tmp/tomcat.tgz \
    && rm -rf /var/lib/apt/lists/*

ENV PATH="/opt/mssql-tools18/bin:${PATH}"

# Copy and install Python model server dependencies
COPY model /app/model
RUN python3 -m venv /app/model/.venv \
    && /app/model/.venv/bin/pip install --no-cache-dir --upgrade pip \
    && /app/model/.venv/bin/pip install --no-cache-dir -r /app/model/requirements.txt

# Copy DB initialization script
COPY database/sql.sql /app/database/sql.sql

# Deploy WAR to Tomcat as ROOT app
COPY --from=build /build/target/*.war /usr/local/tomcat/webapps/ROOT.war

# Startup script that launches MSSQL + Prophet + Tomcat
COPY docker/start.sh /start.sh
RUN chmod +x /start.sh

EXPOSE 1433 8080 8000

CMD ["/start.sh"]
